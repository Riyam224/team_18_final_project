import 'package:team_18_final_project/core/config/audit_log_config.dart';
import 'package:team_18_final_project/core/config/biometric_config.dart';
import 'package:team_18_final_project/core/config/routes_config.dart';
import 'package:team_18_final_project/core/config/timing_config.dart';

class SecurityConfig {
  const SecurityConfig._();

  static const int sessionTimeoutMinutes = TimingConfig.sessionTimeoutMinutes;
  static const Duration sessionTimeout = TimingConfig.sessionTimeout;
  static const Duration sessionPollInterval = TimingConfig.sessionPollInterval;

  static const int autoLockTimeoutSeconds = TimingConfig.autoLockTimeoutSeconds;
  static const Duration autoLockTimeout = TimingConfig.autoLockTimeout;

  static const String defaultBiometricReason =
      BiometricConfig.defaultAuthReason;
  static const String biometricVerifyReason =
      BiometricConfig.verifyIdentityReason;

  static const int maxAuditLogEntries = AuditLogConfig.maxAuditLogEntries;

  static const bool enableRootDetection = true;
  static const bool enableJailbreakDetection = true;
  static const bool enableEmulatorDetection = true;

  static const bool enableScreenshotPrevention = true;

  static const List<String> sensitiveRoutes = RoutesConfig.sensitiveRoutes;

  static const int defaultSessionTimeoutMinutesUserSetting =
      TimingConfig.defaultSessionTimeoutMinutes;
  static const int defaultAutoLockSecondsUserSetting =
      TimingConfig.defaultAutoLockTimeoutSeconds;
}
