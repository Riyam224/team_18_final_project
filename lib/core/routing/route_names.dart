class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';

  static const home = '/home';
  static const market = '/market';
  static const portfolio = '/portfolio';
  static const settings = '/settings';

  static const coinDetails = '/coinDetails';
  static const buySell = '/buySell';
  static const payment = '/payment';

  static const lock = '/lock';
  static const biometric = '/biometric';
}

class RouteParams {
  RouteParams._();

  static const id = 'id';
}

class RoutePaths {
  RoutePaths._();

  static String coinDetailsPath = '${AppRoutes.coinDetails}/:${RouteParams.id}';
  static String buySellPath = '${AppRoutes.buySell}/:${RouteParams.id}';

  static String coinDetailsRoute(String coinId) => '${AppRoutes.coinDetails}/$coinId';
  static String buySellRoute(String coinId) => '${AppRoutes.buySell}/$coinId';
}
