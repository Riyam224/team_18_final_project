import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_screenshot_prevention_service.dart';

final AppRouteObserver appRouteObserver = AppRouteObserver(
  appLockService: sl<IAppLockService>(),
  screenshotService: sl<IScreenshotPreventionService>(),
);

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final IAppLockService _appLockService;
  final IScreenshotPreventionService _screenshotService;
  SecureApplicationController? _controller;

  AppRouteObserver({
    required IAppLockService appLockService,
    required IScreenshotPreventionService screenshotService,
  })  : _appLockService = appLockService,
        _screenshotService = screenshotService;

  /// Sensitive screens that require blur and screenshot blocking
  /// Only financial/sensitive data screens should have blur
  final List<String> sensitiveRoutes = [
    AppRoutes.home,
    AppRoutes.portfolio,
    AppRoutes.coinDetails,
    '/transactions',
    AppRoutes.buySell,
    AppRoutes.payment,
  ];

  /// Screens that should NOT have blur
  /// Includes ALL authentication screens (login, register, biometric)
  /// and non-sensitive screens (settings, profile, onboarding)
  final List<String> nonBlurRoutes = [
    // Splash and Onboarding
    AppRoutes.splash,
    AppRoutes.onboarding,

    // Authentication Screens
    AppRoutes.login,
    AppRoutes.register,

    // Face ID Registration Screens
    AppRoutes.setFaceIDRegister,
    AppRoutes.faceIdScanningRegister,
    AppRoutes.faceIdSuccessRegister,

    // Fingerprint Registration Screens
    AppRoutes.setFingerprintRegister,
    AppRoutes.fingerprintSuccessRegister,

    // Face ID Login Screens
    AppRoutes.faceIdScanningLogin,
    AppRoutes.faceIdVerifiedSuccessLogin,

    // Fingerprint Login Screens
    AppRoutes.verifyFingerprintLogin,
    AppRoutes.verifyFingerprintLoginSuccess,

    // Security Screens (non-financial)
    AppRoutes.appLock,
    AppRoutes.lock,
    AppRoutes.biometric,

    // Settings and Profile (non-financial data)
    AppRoutes.settings,
    AppRoutes.profile,
    '/account',

    // Other non-sensitive screens
    AppRoutes.market,
    AppRoutes.rootWarning,
    AppRoutes.biometricTest,
    AppRoutes.debugBiometrics,
  ];

  void attachController(SecureApplicationController controller) {
    _controller = controller;
    // Start with blur DISABLED by default
    // Blur will only be enabled when navigating to sensitive routes
    _controller?.open();
  }

  bool _isSensitive(String? routeName) {
    if (routeName == null) return false;
    return sensitiveRoutes.any((r) => routeName.startsWith(r));
  }

  bool _shouldDisableBlur(String? routeName) {
    if (routeName == null) return false;
    return nonBlurRoutes.any((r) => routeName.startsWith(r));
  }

  void _handleSecurity(Route<dynamic>? route) {
    final name = route?.settings.name;

    // Update last activity timestamp
    _appLockService.updateActivity();

    if (_controller == null) return;

    // Check if this is a biometric screen that should NOT have blur
    if (_shouldDisableBlur(name)) {
      _controller!.open(); // 🔓 NO blur for Face ID/fingerprint screens
      _screenshotService.disable();
    } else if (_isSensitive(name)) {
      _controller!.secure(); // 🔒 blur + block screenshots (SecureApplication)
      _screenshotService.enable();
    } else {
      _controller!.open(); // 🔓 remove blur for normal screens
      _screenshotService.disable();
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _handleSecurity(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _handleSecurity(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _handleSecurity(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
