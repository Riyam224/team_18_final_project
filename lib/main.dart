import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_application/secure_application.dart';

import 'package:team_18_final_project/core/config/app_config.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/observers/app_route_observer.dart';
import 'package:team_18_final_project/core/routing/app_router.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/utils/locale_controller.dart';
import 'package:team_18_final_project/core/utils/theme_controller.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/core/security/interfaces/i_root_detection_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_audit_log_service.dart';
import 'package:team_18_final_project/core/utils/app_theme.dart';
import 'firebase_options.dart';

Future<void> main({
  AppEnvironment env = AppEnvironment.prod,
  SecurityOverrides? securityOverrides,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (env == AppEnvironment.prod) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Initialize dependency injection
  await setupDependencies(
    env: env,
    securityOverrides: securityOverrides,
  );

  // Set system UI overlay style
  if (env == AppEnvironment.prod) {
    AppTheme.setSystemUIOverlayStyle(ThemeMode.system);
  }

  // Optional: Check for rooted/jailbroken device
  if (env == AppEnvironment.prod) {
    await _performSecurityChecks();
  }

  runApp(const FintechApp());
}

/// Perform initial security checks
Future<void> _performSecurityChecks() async {
  try {
    final rootDetectionService = sl<IRootDetectionService>();
    final result = await rootDetectionService.performSecurityCheck();

    result.fold(
      (failure) => debugPrint('Security check failed: ${failure.message}'),
      (securityCheck) {
        if (!securityCheck.isSecure) {
          debugPrint('⚠️ Security Warning: ${securityCheck.message}');
          // Optionally show warning to user or restrict app functionality
        }
      },
    );
  } catch (e) {
    debugPrint('Security check failed: $e');
  }
}

class FintechApp extends StatefulWidget {
  const FintechApp({super.key});

  @override
  State<FintechApp> createState() => _FintechAppState();
}

class _FintechAppState extends State<FintechApp> with WidgetsBindingObserver {
  late final SecureApplicationController _secureController;
  late final ISessionManager _sessionManager;
  late final IAppLockService _appLockService;
  late final IRootDetectionService _rootDetectionService;
  late final IAuditLogService _auditLogService;
  late final ISecureStorage _secureStorage;
  StreamSubscription<bool>? _lockStateSub;
  StreamSubscription<bool>? _sessionStateSub;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en', '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inject services from DI container
    _sessionManager = sl<ISessionManager>();
    _appLockService = sl<IAppLockService>();
    _rootDetectionService = sl<IRootDetectionService>();
    _auditLogService = sl<IAuditLogService>();
    _secureStorage = sl<ISecureStorage>();

    // Initialize secure application controller for background blur
    _secureController = SecureApplicationController(SecureApplicationState());
    appRouteObserver.attachController(_secureController);

    // Initialize session manager with auto-logout callback
    _initializeSession();

    _listenToAutoLock();
    _listenToSession();
    _checkRootAndWarn();
    _loadThemeMode();
    _loadLocale();

    // Update activity timestamp on app launch
    _appLockService.updateActivity();
  }

  Future<void> _initializeSession() async {
    // Note: The new ISessionManager interface doesn't have an initialize method
    // Session initialization is handled internally by the implementation
    // We just need to start monitoring session state if needed
  }

  void _listenToAutoLock() {
    _lockStateSub = _appLockService.lockStateStream.listen((locked) {
      if (locked && mounted) {
        appNavigatorKey.currentContext?.go(AppRoutes.appLock);
      }
    });
  }

  void _listenToSession() {
    _sessionStateSub = _sessionManager.sessionStateStream.listen((active) {
      if (!active && mounted) {
        appNavigatorKey.currentContext?.go(AppRoutes.login);
      }
    });
  }

  Future<void> _loadThemeMode() async {
    final storedMode =
        await _secureStorage.read(key: StorageKeysConfig.themeMode);
    final modeString = storedMode.fold((_) => null, (value) => value);
    final parsedMode = _parseThemeMode(modeString) ?? ThemeMode.system;
    await _setThemeMode(parsedMode, persist: false);
  }

  Future<void> _setThemeMode(ThemeMode mode, {bool persist = true}) async {
    if (!mounted) return;

    setState(() {
      _themeMode = mode;
    });
    AppTheme.setSystemUIOverlayStyle(mode);

    if (persist) {
      await _secureStorage.write(
        key: StorageKeysConfig.themeMode,
        value: mode.name,
      );
    }
  }

  ThemeMode? _parseThemeMode(String? modeString) {
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  Future<void> _loadLocale() async {
    final storedLocale =
        await _secureStorage.read(key: StorageKeysConfig.language);
    final localeString = storedLocale.fold((_) => null, (value) => value);
    final parsedLocale = _parseLocale(localeString);
    await _setLocale(parsedLocale, persist: false);
  }

  Future<void> _setLocale(Locale locale, {bool persist = true}) async {
    if (!mounted) return;

    setState(() {
      _locale = locale;
    });

    if (persist) {
      await _secureStorage.write(
        key: StorageKeysConfig.language,
        value: locale.languageCode,
      );
    }
  }

  Locale _parseLocale(String? localeString) {
    switch (localeString) {
      case 'en':
        return const Locale('en', '');
      case 'ar':
        return const Locale('ar', '');
      default:
        return const Locale('en', '');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // App returns to foreground
      final sessionResult = await _sessionManager.getCurrentSession();
      final session = sessionResult.fold((_) => null, (value) => value);
      final isValidResult = await _sessionManager.isSessionValid();
      final isValid = isValidResult.fold((_) => false, (valid) => valid);

      // If session expired but data existed, enforce app-lock
      if (session != null && !isValid && mounted) {
        appNavigatorKey.currentContext?.go('/app-lock');
        return;
      }

      // Respect inactivity timeout only (no immediate app-lock after login)
      final shouldLockResult = await _appLockService.isLocked();
      final shouldLock =
          shouldLockResult.fold((_) => false, (locked) => locked);
      if (shouldLock && mounted) {
        appNavigatorKey.currentContext?.go('/app-lock');
      }
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // App going to background - save timestamp for auto-lock
      await _appLockService.updateActivity();
      await _sessionManager.updateActivity();
    }
  }

  Future<void> _checkRootAndWarn() async {
    final secureStorage = sl<ISecureStorage>();

    // 👉 STEP 1: If user already accepted risk → skip warning
    final acceptedRiskResult =
        await secureStorage.read(key: 'accepted_root_risk');
    final acceptedRisk = acceptedRiskResult.fold((_) => null, (value) => value);

    if (acceptedRisk == 'true') {
      debugPrint('⚠️ User accepted risk before → skip root warning.');
      return;
    }

    // 👉 STEP 2: Check root/jailbreak normally
    final result = await _rootDetectionService.performSecurityCheck();

    result.fold(
      (failure) => debugPrint('Root detection failed: ${failure.message}'),
      (securityCheck) async {
        if (!securityCheck.isSecure && mounted) {
          await _auditLogService.log(
            event: 'security_root_jailbreak_detected',
            metadata: {'message': 'Root/Jailbreak detected'},
          );

          await Future.delayed(TimingConfig.splashRootWarningDelay);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            appNavigatorKey.currentContext?.go(AppRoutes.rootWarning);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lockStateSub?.cancel();
    _sessionStateSub?.cancel();
    _sessionManager.dispose();
    _appLockService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set preferred orientations (optional - remove if you want landscape support)
    SystemChrome.setPreferredOrientations(AppConstants.allowedOrientations);

    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return SecureApplication(
          secureApplicationController: _secureController,
          child: Listener(
            behavior: HitTestBehavior.deferToChild,
            onPointerDown: (_) {
              // Track user activity for auto-lock and session management
              _appLockService.updateActivity();
              _sessionManager.updateActivity();
            },
            child: ThemeController(
              themeMode: _themeMode,
              setThemeMode: (mode) => _setThemeMode(mode),
              child: LocaleController(
                locale: _locale,
                setLocale: (locale) => _setLocale(locale),
                child: MaterialApp.router(
                  title: AppConstants.appTitle,
                  debugShowCheckedModeBanner: false,

                  // Localization
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en', ''),
                    Locale('ar', ''),
                  ],
                  locale: _locale,

                  // Themes
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: _themeMode,

                  // Routing configuration
                  routerConfig: RouteGenerator.mainRoutingInOurApp,

                  // SecureApplication blur/screenshot handling routed via observer
                  builder: (context, child) => child ?? const SizedBox(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
