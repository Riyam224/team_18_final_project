import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_application/secure_application.dart';

import 'package:team_18_final_project/core/config/app_config.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/observers/app_route_observer.dart';
import 'package:team_18_final_project/core/routing/app_router.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/core/security/interfaces/i_root_detection_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_audit_log_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/utils/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  await setupDependencies();

  // Set system UI overlay style
  AppTheme.setSystemUIOverlayStyle(ThemeMode.system);

  // Optional: Check for rooted/jailbroken device
  await _performSecurityChecks();

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

    _checkRootAndWarn();

    // Update activity timestamp on app launch
    _appLockService.updateActivity();
  }

  Future<void> _initializeSession() async {
    // Note: The new ISessionManager interface doesn't have an initialize method
    // Session initialization is handled internally by the implementation
    // We just need to start monitoring session state if needed
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // App returns to foreground
      final tokenResult = await _secureStorage.read(key: StorageKeysConfig.authToken);
      final token = tokenResult.fold((_) => null, (value) => value);

      // Check if session is still valid
      final isValidResult = await _sessionManager.isSessionValid();
      final isValid = isValidResult.fold((_) => false, (valid) => valid);

      // If session expired but a token existed, enforce app-lock
      if (token != null && !isValid && mounted) {
        appNavigatorKey.currentContext?.go('/app-lock');
        return;
      }

      // Respect inactivity timeout only (no immediate app-lock after login)
      final shouldLockResult = await _appLockService.isLocked();
      final shouldLock = shouldLockResult.fold((_) => false, (locked) => locked);
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
    final result = await _rootDetectionService.performSecurityCheck();

    result.fold(
      (failure) => debugPrint('Root detection check failed: ${failure.message}'),
      (securityCheck) async {
        if (!securityCheck.isSecure && mounted) {
          await _auditLogService.log(
            event: 'security_root_jailbreak_detected',
            metadata: {'message': 'Root/Jailbreak detected'},
          );
          // Allow splash screen to display before showing the warning
          await Future.delayed(TimingConfig.splashRootWarningDelay);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            appNavigatorKey.currentContext?.go('/root-warning');
          });
        }
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        return Listener(
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

            // Disable global SecureApplication blur; handled selectively via observer
            builder: (context, child) => child ?? const SizedBox(),
          ),
        );
      },
    );
  }
}
