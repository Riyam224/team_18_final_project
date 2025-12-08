import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_application/secure_application.dart';

import 'package:team_18_final_project/core/config/app_config.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/observers/app_route_observer.dart';
import 'package:team_18_final_project/core/routing/app_router.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
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
  StreamSubscription<bool>? _lockStateSub;
  StreamSubscription<bool>? _sessionStateSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Inject services from DI container
    _sessionManager = sl<ISessionManager>();
    _appLockService = sl<IAppLockService>();
    _rootDetectionService = sl<IRootDetectionService>();
    _auditLogService = sl<IAuditLogService>();

    // Initialize secure application controller for background blur
    _secureController = SecureApplicationController(SecureApplicationState());
    appRouteObserver.attachController(_secureController);

    // Initialize session manager with auto-logout callback
    _initializeSession();

    _listenToAutoLock();
    _listenToSession();
    _checkRootAndWarn();

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
            child: MaterialApp.router(
              title: AppConstants.appTitle,
              debugShowCheckedModeBanner: false,

              // Themes
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,

              // Routing configuration
              routerConfig: RouteGenerator.mainRoutingInOurApp,

              // SecureApplication blur/screenshot handling routed via observer
              builder: (context, child) => child ?? const SizedBox(),
            ),
          ),
        );
      },
    );
  }
}
