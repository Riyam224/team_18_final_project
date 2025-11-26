import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  /// ---------------------- WRITE ----------------------
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// ---------------------- READ -----------------------
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// ---------------------- DELETE ---------------------
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// ---------------------- DELETE ALL -----------------
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
