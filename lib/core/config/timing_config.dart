class TimingConfig {
  const TimingConfig._();

  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(seconds: 2);
  static const Duration longDelay = Duration(seconds: 5);

  static const Duration biometricScanDelay = Duration(milliseconds: 500);
  static const Duration biometricSuccessDelay = Duration(seconds: 2);
  static const Duration biometricFailureDelay = Duration(seconds: 2);

  static const Duration navigationDelay = Duration(seconds: 2);
  static const Duration autoNavigationDelay = Duration(milliseconds: 500);

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const int sessionTimeoutMinutes = 30;
  static const Duration sessionTimeout = Duration(minutes: sessionTimeoutMinutes);
  static const Duration sessionPollInterval = Duration(seconds: 30);

  static const int autoLockTimeoutSeconds = 120;
  static const Duration autoLockTimeout = Duration(seconds: autoLockTimeoutSeconds);

  static const int defaultSessionTimeoutMinutes = 30;
  static const int defaultAutoLockTimeoutSeconds = 120;

  static const int shortDelayMs = 500;
  static const int mediumDelayMs = 2000;
  static const int longDelayMs = 5000;

  static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
  static const Duration splashRegisteredUserDelay = Duration(milliseconds: 3000);
  static const Duration splashNonRegisteredUserDelay = Duration(milliseconds: 2000);
  static const Duration splashRootWarningDelay = Duration(milliseconds: 2200);

  static const Duration onboardingPageTransitionDuration = Duration(milliseconds: 300);

  static const Duration indicatorAnimationDuration = Duration(milliseconds: 250);
}
