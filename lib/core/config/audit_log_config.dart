/// Audit log configuration for the application
/// Contains all audit log-related constants and message templates
class AuditLogConfig {
  const AuditLogConfig._();

  // Audit Log Settings
  static const int maxAuditLogEntries = 100;
  static const int maxEntries = 100; // Alias for consistency

  // Audit Log Types
  static const String sessionStartType = 'session_start';
  static const String sessionEndType = 'session_end';
  static const String sessionTimeoutType = 'session_timeout';
  static const String activityUpdateType = 'activity_update';
  static const String lockAppType = 'lock_app';
  static const String unlockAppType = 'unlock_app';
  static const String loginType = 'login';
  static const String logoutType = 'logout';
  static const String biometricAuthType = 'biometric_auth';
  static const String passwordChangeType = 'password_change';
  static const String settingsChangeType = 'settings_change';

  // Audit Log Messages
  static const String sessionStartedMessage = 'Session started';
  static const String sessionEndedMessage = 'Session ended';
  static const String sessionTimedOutMessage = 'Session timed out';
  static const String activityUpdatedMessage = 'Activity updated';
  static const String appLockedMessage = 'App locked';
  static const String appUnlockedMessage = 'App unlocked';
  static const String userLoggedInMessage = 'User logged in';
  static const String userLoggedOutMessage = 'User logged out';
  static const String biometricAuthSuccessMessage = 'Biometric authentication successful';
  static const String biometricAuthFailedMessage = 'Biometric authentication failed';
  static const String passwordChangedMessage = 'Password changed';
  static const String settingsChangedMessage = 'Settings changed';

  // Storage Keys
  static const String auditLogKey = 'audit_log';
  static const String lastAuditCleanupKey = 'last_audit_cleanup';
}
