/// Secure storage keys configuration
/// Centralized location for all storage keys used in the app
class StorageKeysConfig {
  const StorageKeysConfig._();

  // Authentication Keys
  static const String userId = 'user_id';
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userEmail = 'user_email';
  static const String userDisplayName = 'user_display_name';
  static const String userPhotoUrl = 'user_photo_url';
  static const String userPhoneNumber = 'user_phone_number';

  // Biometric Keys
  static const String biometricEnabled = 'biometric_enabled';
  static const String biometricType = 'biometric_type';
  static const String biometricEmail = 'biometric_email';
  static const String biometricPassword = 'biometric_password';
  static const String biometricCredentialsStored = 'biometric_credentials_stored';

  // Session Keys
  static const String sessionId = 'session_id';
  static const String sessionStartTime = 'session_start_time';
  static const String lastActivityTime = 'last_activity_time';
  static const String sessionTimeout = 'session_timeout';
  static const String sessionActive = 'session_active';

  // App Lock Keys
  static const String appLocked = 'app_locked';
  static const String lockTimestamp = 'lock_timestamp';
  static const String autoLockEnabled = 'auto_lock_enabled';
  static const String autoLockTimeout = 'auto_lock_timeout';

  // User Settings Keys
  static const String sessionTimeoutMinutes = 'session_timeout_minutes';
  static const String autoLockTimeoutSeconds = 'auto_lock_timeout_seconds';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';

  // Security Keys
  static const String isFirstLaunch = 'is_first_launch';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String lastLoginTimestamp = 'last_login_timestamp';
  static const String lastPasswordChange = 'last_password_change';
  static const String failedLoginAttempts = 'failed_login_attempts';
  static const String accountLockedUntil = 'account_locked_until';

  // Audit Log Keys
  static const String auditLog = 'audit_log';
  static const String auditLogs = 'audit_logs';
  static const String lastAuditCleanup = 'last_audit_cleanup';

  // Screenshot Prevention Keys
  static const String screenshotPreventionEnabled = 'screenshot_prevention_enabled';
  static const String protectedRoutes = 'protected_routes';

  // Blur Service Keys
  static const String blurEnabled = 'blur_enabled';

  // Device Info Keys
  static const String deviceId = 'device_id';
  static const String deviceName = 'device_name';
  static const String deviceModel = 'device_model';
  static const String osVersion = 'os_version';

  // Profile Keys
  static const String avatarUrl = 'avatar_url';
  static const String userBio = 'user_bio';
  static const String userPreferences = 'user_preferences';
}
