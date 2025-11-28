class AppRoutes {
  // Splash + Onboarding + Auth
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';

  // Bottom Nav Routes
  static const home = '/home';
  static const market = '/market';
  static const portfolio = '/portfolio';
  static const settings = '/settings';

  // Other Routes (outside bottom nav)
  static const coinDetails = '/coinDetails';
  static const buySell = '/buySell';
  static const payment = '/payment';

  // Security
  static const lock = '/lock';
  static const appLock = '/app-lock';
  static const biometric = '/biometric';
  // register
  static const setFingerprintRegister = '/setFingerprintRegister';
  static const fingerprintSuccessRegister = '/fingerprintSuccessRegister';
  static const setFaceIDRegister = '/setFaceIDRegister';
  static const faceIdScanningRegister = '/faceIdScanningRegister';

  static const faceIdSuccessRegister = '/faceIdSuccessRegister';

  static const verifyFingerprintLogin = '/verifyFingerprintLogin';
  static const verifyFingerprintLoginSuccess = '/verifyFingerprintLoginSuccess';
  // static const verifyFaceIDLogin = '/verifyFaceIDLogin';
  static const faceIdScanningLogin = '/faceIdScanningLogin';
  static const faceIdVerifiedSuccessLogin = '/faceIdVerifiedSuccessLogin';

  // Debug Routes
  static const biometricTest = '/biometric-test';
  static const debugBiometrics = '/debug-biometrics';

  // Root warning
  static const rootWarning = '/root-warning';
}
