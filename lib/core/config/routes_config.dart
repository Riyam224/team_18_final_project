import 'package:team_18_final_project/core/routing/route_names.dart';

class RoutesConfig {
  const RoutesConfig._();

  static const List<String> sensitiveRoutes = [
    AppRoutes.home,
    AppRoutes.portfolio,
    AppRoutes.settings,
    AppRoutes.myAccount,
    AppRoutes.buySell,
    AppRoutes.payment,
    AppRoutes.coinDetails,
  ];

  static const List<String> authenticatedRoutes = [
    AppRoutes.home,
    AppRoutes.portfolio,
    AppRoutes.market,
    AppRoutes.settings,
    AppRoutes.myAccount,
    AppRoutes.buySell,
    AppRoutes.payment,
    AppRoutes.coinDetails,
  ];

  static const List<String> appLockExemptRoutes = [
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.onboarding,
    AppRoutes.splash,
  ];
}
