import 'package:team_18_final_project/core/security/secure_storage_service.dart';

class AppLockService {
  static Duration timeout = const Duration(minutes: 2);

  /// Save last activity timestamp
  static Future<void> updateActivity() async {
    await SecureStorageService.write(
      'lastActive',
      DateTime.now().toIso8601String(),
    );
  }

  /// Check if app should lock
  static Future<bool> shouldLock() async {
    final ts = await SecureStorageService.read('lastActive');
    if (ts == null) return true;

    DateTime last = DateTime.parse(ts);
    DateTime now = DateTime.now();

    return now.difference(last) > timeout;
  }
}
