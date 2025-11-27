import 'package:flutter/material.dart';
import 'package:secure_application/secure_application.dart';
import 'package:team_18_final_project/core/routing/route_names.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';

final AppRouteObserver appRouteObserver = AppRouteObserver();

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  SecureApplicationController? _controller;

  /// Sensitive screens that require blur and screenshot blocking
  final List<String> sensitiveRoutes = [
    AppRoutes.home,
    AppRoutes.portfolio,
    // AppRoutes.transactions,
    AppRoutes.buySell,
    AppRoutes.payment,
    // AppRoutes.wallet,
    '/settings',
    '/profile',
    '/account',
  ];

  void attachController(SecureApplicationController controller) {
    _controller = controller;
  }

  bool _isSensitive(String? routeName) {
    if (routeName == null) return false;
    return sensitiveRoutes.any((r) => routeName.startsWith(r));
  }

  void _handleSecurity(Route<dynamic>? route) {
    final name = route?.settings.name;

    // Update last activity timestamp
    AppLockService.updateActivity();

    if (_controller == null) return;

    if (_isSensitive(name)) {
      _controller!.secure(); // 🔒 blur + block screenshots
    } else {
      _controller!.open(); // 🔓 remove blur for normal screens
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
