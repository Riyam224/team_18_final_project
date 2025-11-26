import 'package:team_18_final_project/core/security/secure_storage_service.dart';

/// Service to handle app locking after inactivity
class AppLockService {
  /// Default auto-lock timeout: 2 minutes
  static const int defaultAutoLockMinutes = 2;

  /// Update last activity timestamp
  static Future<void> updateActivity() async {
    await SecureStorageService.saveLastActivity();
  }

  /// Check if app should auto-lock based on inactivity
  static Future<bool> shouldLock() async {
    final lastActivity = await SecureStorageService.getLastActivity();
    if (lastActivity == null) return true;

    final timeoutMinutes = await getAutoLockTimeout();
    final timeout = Duration(minutes: timeoutMinutes);
    final now = DateTime.now();

    return now.difference(lastActivity) > timeout;
  }

  /// Get remaining time before auto-lock
  static Future<Duration?> getTimeUntilLock() async {
    final lastActivity = await SecureStorageService.getLastActivity();
    if (lastActivity == null) return null;

    final timeoutMinutes = await getAutoLockTimeout();
    final timeout = Duration(minutes: timeoutMinutes);
    final now = DateTime.now();
    final elapsed = now.difference(lastActivity);

    if (elapsed >= timeout) return Duration.zero;

    return timeout - elapsed;
  }

  /// Set custom auto-lock timeout (in minutes)
  static Future<void> setAutoLockTimeout(int minutes) async {
    await SecureStorageService.saveAutoLockTimeout(minutes);
  }

  /// Get current auto-lock timeout setting (in minutes)
  static Future<int> getAutoLockTimeout() async {
    return await SecureStorageService.getAutoLockTimeout();
  }

  /// Check if auto-lock is enabled
  static Future<bool> isAutoLockEnabled() async {
    final timeout = await getAutoLockTimeout();
    return timeout > 0;
  }

  /// Disable auto-lock
  static Future<void> disableAutoLock() async {
    await setAutoLockTimeout(0);
  }

  /// Enable auto-lock with default timeout
  static Future<void> enableAutoLock() async {
    await setAutoLockTimeout(defaultAutoLockMinutes);
  }
}
