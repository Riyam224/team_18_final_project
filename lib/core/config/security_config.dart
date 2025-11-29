import 'package:team_18_final_project/core/config/audit_log_config.dart';
import 'package:team_18_final_project/core/config/biometric_config.dart';
import 'package:team_18_final_project/core/config/timing_config.dart';

/// Security configuration for the application
/// Contains all security-related constants
///
/// Note: Timing-related values are now in TimingConfig
/// Biometric-related values are now in BiometricConfig
/// Audit log-related values are now in AuditLogConfig
class SecurityConfig {
  const SecurityConfig._();

  // Session Management (delegated to TimingConfig)
  static const int sessionTimeoutMinutes = TimingConfig.sessionTimeoutMinutes;
  static const Duration sessionTimeout = TimingConfig.sessionTimeout;
  static const Duration sessionPollInterval = TimingConfig.sessionPollInterval;

  // App Lock Settings (delegated to TimingConfig)
  static const int autoLockTimeoutSeconds = TimingConfig.autoLockTimeoutSeconds;
  static const Duration autoLockTimeout = TimingConfig.autoLockTimeout;

  // Biometric Settings (delegated to BiometricConfig)
  static const String defaultBiometricReason = BiometricConfig.defaultAuthReason;
  static const String biometricVerifyReason = BiometricConfig.verifyIdentityReason;

  // Audit Log Settings (delegated to AuditLogConfig)
  static const int maxAuditLogEntries = AuditLogConfig.maxAuditLogEntries;

  // Security Checks
  static const bool enableRootDetection = true;
  static const bool enableJailbreakDetection = true;
  static const bool enableEmulatorDetection = true;

  // Screenshot Prevention
  static const bool enableScreenshotPrevention = true;

  // Sensitive Routes (routes that require screenshot prevention)
  static const List<String> sensitiveRoutes = [
    '/home',
    '/portfolio',
    '/transactions',
    '/coin-details',
    '/payment',
    '/buy-sell',
    '/settings',
    '/profile',
  ];

  // Default timeout values for user settings (delegated to TimingConfig)
  static const int defaultSessionTimeoutMinutesUserSetting =
      TimingConfig.defaultSessionTimeoutMinutes;
  static const int defaultAutoLockSecondsUserSetting =
      TimingConfig.defaultAutoLockTimeoutSeconds;
}
