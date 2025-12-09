class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';

  static const home = '/home';
  static const market = '/market';
  static const portfolio = '/portfolio';
  static const transactions = '/transactions';
  static const settings = '/settings';
  static const myAccount = '/profile';
  @Deprecated('Use myAccount')
  static const profile = myAccount;

  static const coinDetails = '/coinDetails';
  static const buySell = '/buySell';
  static const payment = '/payment';

  static const lock = '/lock';
  static const appLock = '/app-lock';
  static const biometric = '/biometric';
  static const setFingerprintRegister = '/setFingerprintRegister';
  static const fingerprintSuccessRegister = '/fingerprintSuccessRegister';
  static const setFaceIDRegister = '/setFaceIDRegister';
  static const faceIdScanningRegister = '/faceIdScanningRegister';

  static const faceIdSuccessRegister = '/faceIdSuccessRegister';

  static const verifyFingerprintLogin = '/verifyFingerprintLogin';
  static const verifyFingerprintLoginSuccess = '/verifyFingerprintLoginSuccess';
  static const faceIdScanningLogin = '/faceIdScanningLogin';
  static const faceIdVerifiedSuccessLogin = '/faceIdVerifiedSuccessLogin';

  static const biometricTest = '/biometric-test';
  static const debugBiometrics = '/debug-biometrics';

  static const rootWarning = '/root-warning';
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
