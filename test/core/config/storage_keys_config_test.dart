import 'package:flutter_test/flutter_test.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';

void main() {
  group('StorageKeysConfig', () {
    test('should have unique authentication keys', () {
      final authKeys = {
        StorageKeysConfig.userId,
        StorageKeysConfig.authToken,
        StorageKeysConfig.refreshToken,
        StorageKeysConfig.userEmail,
        StorageKeysConfig.userDisplayName,
        StorageKeysConfig.userFirstName,
        StorageKeysConfig.userLastName,
        StorageKeysConfig.userPhotoUrl,
        StorageKeysConfig.userPhoneNumber,
      };

      expect(authKeys.length, 9);
    });

    test('should have unique biometric keys', () {
      final biometricKeys = {
        StorageKeysConfig.biometricEnabled,
        StorageKeysConfig.biometricType,
        StorageKeysConfig.biometricEmail,
        StorageKeysConfig.biometricPassword,
        StorageKeysConfig.biometricCredentialsStored,
      };

      expect(biometricKeys.length, 5);
    });

    test('should have unique session keys', () {
      final sessionKeys = {
        StorageKeysConfig.sessionId,
        StorageKeysConfig.sessionStartTime,
        StorageKeysConfig.lastActivityTime,
        StorageKeysConfig.sessionTimeout,
        StorageKeysConfig.sessionActive,
      };

      expect(sessionKeys.length, 5);
    });

    test('all keys should be strings', () {
      expect(StorageKeysConfig.userId, isA<String>());
      expect(StorageKeysConfig.authToken, isA<String>());
      expect(StorageKeysConfig.biometricEnabled, isA<String>());
      expect(StorageKeysConfig.sessionId, isA<String>());
      expect(StorageKeysConfig.encryptionKey, isA<String>());
    });

    test('keys should not be empty', () {
      expect(StorageKeysConfig.userId.isNotEmpty, true);
      expect(StorageKeysConfig.authToken.isNotEmpty, true);
      expect(StorageKeysConfig.biometricEmail.isNotEmpty, true);
      expect(StorageKeysConfig.sessionId.isNotEmpty, true);
    });

    test('should have descriptive key names', () {
      expect(StorageKeysConfig.userId, contains('user'));
      expect(StorageKeysConfig.authToken, contains('token'));
      expect(StorageKeysConfig.biometricEnabled, contains('biometric'));
      expect(StorageKeysConfig.sessionId, contains('session'));
    });
  });
}
