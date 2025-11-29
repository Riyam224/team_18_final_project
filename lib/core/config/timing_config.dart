/// Timing configuration for the application
/// Contains all timing-related constants (delays, durations, timeouts)
class TimingConfig {
  const TimingConfig._();

  // UI Delay Durations
  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(seconds: 2);
  static const Duration longDelay = Duration(seconds: 5);

  // Biometric Authentication Delays
  static const Duration biometricScanDelay = Duration(milliseconds: 500);
  static const Duration biometricSuccessDelay = Duration(seconds: 2);
  static const Duration biometricFailureDelay = Duration(seconds: 2);

  // Navigation Delays
  static const Duration navigationDelay = Duration(seconds: 2);
  static const Duration autoNavigationDelay = Duration(milliseconds: 500);

  // Network Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Session Management
  static const int sessionTimeoutMinutes = 30;
  static const Duration sessionTimeout = Duration(minutes: sessionTimeoutMinutes);
  static const Duration sessionPollInterval = Duration(seconds: 30);

  // App Lock Settings
  static const int autoLockTimeoutSeconds = 120;
  static const Duration autoLockTimeout = Duration(seconds: autoLockTimeoutSeconds);

  // Default User Settings Timeouts
  static const int defaultSessionTimeoutMinutes = 30;
  static const int defaultAutoLockTimeoutSeconds = 120;

  // Millisecond values for explicit use
  static const int shortDelayMs = 500;
  static const int mediumDelayMs = 2000;
  static const int longDelayMs = 5000;
}
