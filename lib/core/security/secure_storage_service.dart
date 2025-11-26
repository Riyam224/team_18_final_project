import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Keys for sensitive data
  static const String _keyUserId = 'user_id';
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyBiometricEmail = 'biometric_email';
  static const String _keyBiometricPassword = 'biometric_password';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyBiometricType = 'biometric_type';
  static const String _keyLastActive = 'lastActive';
  static const String _keySessionTimeout = 'session_timeout';
  static const String _keyAutoLockTimeout = 'auto_lock_timeout';

  /// Write a value to secure storage
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a value from secure storage
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a specific key
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete ALL keys (for logout)
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// Get all keys
  static Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  // === USER CREDENTIALS ===

  /// Store user authentication token
  static Future<void> saveAuthToken(String token) async {
    await write(_keyToken, token);
  }

  /// Get user authentication token
  static Future<String?> getAuthToken() async {
    return await read(_keyToken);
  }

  /// Store refresh token
  static Future<void> saveRefreshToken(String token) async {
    await write(_keyRefreshToken, token);
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    return await read(_keyRefreshToken);
  }

  /// Store user ID
  static Future<void> saveUserId(String userId) async {
    await write(_keyUserId, userId);
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    return await read(_keyUserId);
  }

  // === BIOMETRIC SETTINGS ===

  /// Store biometric credentials for quick login
  static Future<void> saveBiometricCredentials({
    required String email,
    required String password,
  }) async {
    await write(_keyBiometricEmail, email);
    await write(_keyBiometricPassword, password);
  }

  /// Get stored biometric email
  static Future<String?> getBiometricEmail() async {
    return await read(_keyBiometricEmail);
  }

  /// Get stored biometric password
  static Future<String?> getBiometricPassword() async {
    return await read(_keyBiometricPassword);
  }

  /// Enable/disable biometric authentication
  static Future<void> setBiometricEnabled(bool enabled) async {
    await write(_keyBiometricEnabled, enabled.toString());
  }

  /// Check if biometric is enabled
  static Future<bool> isBiometricEnabled() async {
    final value = await read(_keyBiometricEnabled);
    return value == 'true';
  }

  /// Store biometric type (fingerprint/face)
  static Future<void> setBiometricType(String type) async {
    await write(_keyBiometricType, type);
  }

  /// Get biometric type
  static Future<String?> getBiometricType() async {
    return await read(_keyBiometricType);
  }

  // === TRANSACTION HISTORY (ENCRYPTED) ===

  /// Save encrypted transaction history
  static Future<void> saveTransactionHistory(List<Map<String, dynamic>> transactions) async {
    final jsonString = jsonEncode(transactions);
    await write('transaction_history', jsonString);
  }

  /// Get encrypted transaction history
  static Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    final jsonString = await read('transaction_history');
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Clear transaction history
  static Future<void> clearTransactionHistory() async {
    await delete('transaction_history');
  }

  // === SESSION MANAGEMENT ===

  /// Save last activity timestamp
  static Future<void> saveLastActivity() async {
    await write(_keyLastActive, DateTime.now().toIso8601String());
  }

  /// Get last activity timestamp
  static Future<DateTime?> getLastActivity() async {
    final timestamp = await read(_keyLastActive);
    if (timestamp == null) return null;

    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  /// Save session timeout duration (in minutes)
  static Future<void> saveSessionTimeout(int minutes) async {
    await write(_keySessionTimeout, minutes.toString());
  }

  /// Get session timeout duration (in minutes)
  static Future<int> getSessionTimeout() async {
    final value = await read(_keySessionTimeout);
    return int.tryParse(value ?? '30') ?? 30; // Default 30 minutes
  }

  /// Save auto-lock timeout duration (in minutes)
  static Future<void> saveAutoLockTimeout(int minutes) async {
    await write(_keyAutoLockTimeout, minutes.toString());
  }

  /// Get auto-lock timeout duration (in minutes)
  static Future<int> getAutoLockTimeout() async {
    final value = await read(_keyAutoLockTimeout);
    return int.tryParse(value ?? '2') ?? 2; // Default 2 minutes
  }

  // === LOGOUT ===

  /// Clear all sensitive data (for logout)
  /// Keeps settings like biometric preferences
  static Future<void> clearUserData() async {
    await delete(_keyUserId);
    await delete(_keyToken);
    await delete(_keyRefreshToken);
    await delete(_keyLastActive);
    await clearTransactionHistory();
  }

  /// Complete logout - removes everything including biometric settings
  static Future<void> completeLogout() async {
    await deleteAll();
  }
}
