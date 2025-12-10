import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';
import 'package:team_18_final_project/core/config/routes_config.dart';
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

  final List<String> sensitiveRoutes = RoutesConfig.sensitiveRoutes;

  final List<String> nonBlurRoutes = [
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.setFaceIDRegister,
    AppRoutes.faceIdScanningRegister,
    AppRoutes.faceIdSuccessRegister,
    AppRoutes.setFingerprintRegister,
    AppRoutes.fingerprintSuccessRegister,
    AppRoutes.faceIdScanningLogin,
    AppRoutes.faceIdVerifiedSuccessLogin,
    AppRoutes.verifyFingerprintLogin,
    AppRoutes.verifyFingerprintLoginSuccess,
    AppRoutes.appLock,
    AppRoutes.lock,
    AppRoutes.biometric,
    AppRoutes.market,
    AppRoutes.settings,
    AppRoutes.myAccount,
    AppRoutes.rootWarning,
    AppRoutes.biometricTest,
    AppRoutes.debugBiometrics,
  ];

  void attachController(SecureApplicationController controller) {
    _controller = controller;
    _controller?.open();
  }

  bool _isSensitive(String? name) =>
      name != null && sensitiveRoutes.any((r) => name.startsWith(r));

  bool _isNonBlur(String? name) =>
      name != null && nonBlurRoutes.any((r) => name.startsWith(r));

  void _applySecurity(String? routeName) {
    if (_controller == null) return;

    if (_isNonBlur(routeName)) {
      _controller!.open();
      _screenshotService.disable();
      return;
    }

    if (_isSensitive(routeName)) {
      _controller!.secure();
      _screenshotService.enable();
      return;
    }

    _controller!.open();
    _screenshotService.disable();
  }

  void _handleSecurity(Route<dynamic>? route) {
    final name = route?.settings.name;

    _appLockService.updateActivity();

    _applySecurity(name);
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
