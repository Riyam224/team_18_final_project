import 'package:team_18_final_project/core/routing/route_names.dart';

/// Routes configuration for the application
/// Contains sensitive routes and route-related constants
class RoutesConfig {
  const RoutesConfig._();

  /// Routes that should have screenshot prevention enabled
  static const List<String> sensitiveRoutes = [
    AppRoutes.home,
    AppRoutes.portfolio,
    AppRoutes.settings,
    AppRoutes.profile,
    AppRoutes.buySell,
    AppRoutes.payment,
    AppRoutes.coinDetails,
  ];

  /// Routes that require authentication
  static const List<String> authenticatedRoutes = [
    AppRoutes.home,
    AppRoutes.portfolio,
    AppRoutes.market,
    AppRoutes.settings,
    AppRoutes.profile,
    AppRoutes.buySell,
    AppRoutes.payment,
    AppRoutes.coinDetails,
  ];

  /// Routes that should bypass app lock
  static const List<String> appLockExemptRoutes = [
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.onboarding,
    AppRoutes.splash,
  ];
}
