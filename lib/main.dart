import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:secure_application/secure_application.dart';

import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/observers/app_route_observer.dart';
import 'package:team_18_final_project/core/routing/app_router.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/security/session_manager.dart';
import 'package:team_18_final_project/core/security/root_detection_service.dart';
import 'package:team_18_final_project/core/utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    final securityCheck = await RootDetectionService.performSecurityCheck();

    if (!securityCheck.isSafe) {
      debugPrint('⚠️ Security Warning: ${securityCheck.warningMessage}');
      // Optionally show warning to user or restrict app functionality
    }
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize secure application controller for background blur
    _secureController = SecureApplicationController(SecureApplicationState());
    appRouteObserver.attachController(_secureController);

    // Initialize session manager with auto-logout callback
    SessionManager.initialize(
      onSessionExpired: _handleSessionExpired,
    );

    // Update activity timestamp on app launch
    AppLockService.updateActivity();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // App returns to foreground

      // Check if session is still valid
      await SessionManager.checkSessionValidity();

      // Respect inactivity timeout only (no immediate app-lock after login)
      final shouldLock = await AppLockService.shouldLock();
      if (shouldLock && mounted) {
        appNavigatorKey.currentContext?.go('/app-lock');
      }
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // App going to background - save timestamp for auto-lock
      await AppLockService.updateActivity();
      await SessionManager.updateActivity();
    }
  }

  /// Handle session expiration - logout user
  void _handleSessionExpired() {
    debugPrint('Session expired - logging out user');
    if (mounted) {
      // Navigate to login screen
      appNavigatorKey.currentContext?.go('/login');

      // Show session expired message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your session has expired. Please login again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set preferred orientations (optional - remove if you want landscape support)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return Listener(
          behavior: HitTestBehavior.deferToChild,
          onPointerDown: (_) {
            // Track user activity for auto-lock and session management
            AppLockService.updateActivity();
            SessionManager.updateActivity();
          },
          child: SecureApplication(
            secureApplicationController: _secureController,
            nativeRemoveDelay: 800, // Delay before removing blur on resume
            child: MaterialApp.router(
              title: 'Team 18 Fintech',
              debugShowCheckedModeBanner: false,

              // Themes
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,

              // Routing configuration
              routerConfig: RouteGenerator.mainRoutingInOurApp,
            ),
          ),
        );
      },
    );
  }
}
