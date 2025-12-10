import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_encryption_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/biometric_credentials_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/storage_failure.dart';
import 'package:team_18_final_project/core/error/failures.dart';

class MockSecureStorage extends Mock implements ISecureStorage {}

class MockEncryptionService extends Mock implements IEncryptionService {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockSecureStorage mockSecureStorage;
  late MockEncryptionService mockEncryptionService;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    mockEncryptionService = MockEncryptionService();
    dataSource = AuthLocalDataSourceImpl(
      secureStorage: mockSecureStorage,
      encryptionService: mockEncryptionService,
    );
  });

  group('cacheSession', () {
    final tSession = AuthSessionEntity(
      userId: 'user123',
      token: 'token123',
      startedAt: DateTime(2024, 1, 1),
    );

    test('should encrypt and cache session data', () async {
      when(() => mockEncryptionService.encrypt(any()))
          .thenAnswer((_) async => const Right('encrypted_data'));
      when(() => mockSecureStorage.write(
              key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.cacheSession(tSession);

      verify(() => mockEncryptionService.encrypt(any())).called(2);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.sessionId,
            value: any(named: 'value'),
          )).called(1);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.userId,
            value: tSession.userId,
          )).called(1);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.authToken,
            value: any(named: 'value'),
          )).called(1);
    });

    test('should use original value if encryption fails', () async {
      when(() => mockEncryptionService.encrypt(any())).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Encryption failed')));
      when(() => mockSecureStorage.write(
              key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.cacheSession(tSession);

      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.sessionId,
            value: any(named: 'value'),
          )).called(1);
    });
  });

  group('getLastSession', () {
    test('should return session when data exists and decryption succeeds',
        () async {
      const encryptedData = 'encrypted_session';
      const decryptedData =
          'user123|token123||2024-01-01T00:00:00.000|2024-01-01T00:00:00.000';

      when(() => mockSecureStorage.read(key: StorageKeysConfig.sessionId))
          .thenAnswer((_) async => const Right(encryptedData));
      when(() => mockEncryptionService.decrypt(encryptedData))
          .thenAnswer((_) async => const Right(decryptedData));

      final result = await dataSource.getLastSession();

      expect(result, isNotNull);
      expect(result?.userId, 'user123');
      expect(result?.token, 'token123');
    });

    test('should return null when no session data exists', () async {
      when(() => mockSecureStorage.read(key: StorageKeysConfig.sessionId))
          .thenAnswer((_) async => const Right(null));

      final result = await dataSource.getLastSession();

      expect(result, isNull);
    });

    test('should return null when storage read fails', () async {
      when(() => mockSecureStorage.read(key: StorageKeysConfig.sessionId))
          .thenAnswer((_) async => const Left(StorageReadFailure()));

      final result = await dataSource.getLastSession();

      expect(result, isNull);
    });
  });

  group('clearSession', () {
    test('should delete all session-related keys', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.clearSession();

      verify(() => mockSecureStorage.delete(key: StorageKeysConfig.sessionId))
          .called(1);
      verify(() => mockSecureStorage.delete(key: StorageKeysConfig.authToken))
          .called(1);
      verify(() =>
              mockSecureStorage.delete(key: StorageKeysConfig.sessionActive))
          .called(1);
      verify(() =>
              mockSecureStorage.delete(key: StorageKeysConfig.lastActivityTime))
          .called(1);
    });
  });

  group('cacheBiometricCredentials', () {
    final tCredentials = BiometricCredentialsEntity(
      email: 'test@example.com',
      encryptedPassword: 'encrypted_password',
      biometricType: BiometricType.fingerprint,
      storedAt: DateTime(2024, 1, 1),
    );

    test('should encrypt and cache biometric credentials', () async {
      when(() => mockEncryptionService.encrypt(any()))
          .thenAnswer((_) async => const Right('encrypted_value'));
      when(() => mockSecureStorage.write(
              key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.cacheBiometricCredentials(tCredentials);

      verify(() => mockEncryptionService.encrypt(tCredentials.email)).called(1);
      verify(() =>
              mockEncryptionService.encrypt(tCredentials.encryptedPassword))
          .called(1);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.biometricEmail,
            value: 'encrypted_value',
          )).called(1);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.biometricPassword,
            value: 'encrypted_value',
          )).called(1);
    });

    test('should throw exception when email encryption fails', () async {
      when(() => mockEncryptionService.encrypt(tCredentials.email))
          .thenAnswer((_) async => const Left(CacheFailure(message: 'Failed')));
      when(() => mockEncryptionService.encrypt(tCredentials.encryptedPassword))
          .thenAnswer((_) async => const Right('encrypted_password'));

      await expectLater(
        dataSource.cacheBiometricCredentials(tCredentials),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw exception when password encryption fails', () async {
      when(() => mockEncryptionService.encrypt(tCredentials.email))
          .thenAnswer((_) async => const Right('encrypted_email'));
      when(() => mockEncryptionService.encrypt(tCredentials.encryptedPassword))
          .thenAnswer((_) async => const Left(CacheFailure(message: 'Failed')));

      await expectLater(
        dataSource.cacheBiometricCredentials(tCredentials),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getBiometricCredentials', () {
    test(
        'should return credentials when all data exists and decryption succeeds',
        () async {
      when(() => mockSecureStorage.read(key: StorageKeysConfig.biometricEmail))
          .thenAnswer((_) async => const Right('encrypted_email'));
      when(() =>
              mockSecureStorage.read(key: StorageKeysConfig.biometricPassword))
          .thenAnswer((_) async => const Right('encrypted_password'));
      when(() => mockSecureStorage.read(key: StorageKeysConfig.biometricType))
          .thenAnswer((_) async => const Right('fingerprint'));
      when(() => mockEncryptionService.decrypt('encrypted_email'))
          .thenAnswer((_) async => const Right('test@example.com'));
      when(() => mockEncryptionService.decrypt('encrypted_password'))
          .thenAnswer((_) async => const Right('password123'));

      final result = await dataSource.getBiometricCredentials();

      expect(result, isNotNull);
      expect(result?.email, 'test@example.com');
      expect(result?.encryptedPassword, 'password123');
      expect(result?.biometricType, BiometricType.fingerprint);
    });

    test('should return null when email is missing', () async {
      when(() => mockSecureStorage.read(key: StorageKeysConfig.biometricEmail))
          .thenAnswer((_) async => const Right(null));
      when(() =>
              mockSecureStorage.read(key: StorageKeysConfig.biometricPassword))
          .thenAnswer((_) async => const Right('encrypted_password'));
      when(() => mockSecureStorage.read(key: StorageKeysConfig.biometricType))
          .thenAnswer((_) async => const Right('fingerprint'));
      when(() => mockEncryptionService.decrypt(any()))
          .thenAnswer((_) async => const Right('decrypted_value'));

      final result = await dataSource.getBiometricCredentials();

      expect(result, isNull);
    });

    test('should return null when decryption fails', () async {
      when(() => mockSecureStorage.read(key: StorageKeysConfig.biometricEmail))
          .thenAnswer((_) async => const Right('encrypted_email'));
      when(() =>
              mockSecureStorage.read(key: StorageKeysConfig.biometricPassword))
          .thenAnswer((_) async => const Right('encrypted_password'));
      when(() => mockSecureStorage.read(key: StorageKeysConfig.biometricType))
          .thenAnswer((_) async => const Right('fingerprint'));
      when(() => mockEncryptionService.decrypt('encrypted_email')).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'Decryption failed')));
      when(() => mockEncryptionService.decrypt('encrypted_password'))
          .thenAnswer((_) async => const Right('password123'));

      final result = await dataSource.getBiometricCredentials();

      expect(result, isNull);
    });
  });

  group('clearBiometricCredentials', () {
    test('should delete all biometric-related keys', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.clearBiometricCredentials();

      verify(() =>
              mockSecureStorage.delete(key: StorageKeysConfig.biometricEmail))
          .called(1);
      verify(() => mockSecureStorage.delete(
          key: StorageKeysConfig.biometricPassword)).called(1);
      verify(() =>
              mockSecureStorage.delete(key: StorageKeysConfig.biometricType))
          .called(1);
      verify(() => mockSecureStorage.delete(
          key: StorageKeysConfig.biometricCredentialsStored)).called(1);
      verify(() =>
              mockSecureStorage.delete(key: StorageKeysConfig.biometricEnabled))
          .called(1);
    });
  });

  group('cacheUser', () {
    final tUser = UserEntity(
      id: 'user123',
      email: 'test@example.com',
      displayName: 'Test User',
      phoneNumber: '+1234567890',
      isEmailVerified: true,
    );

    test('should cache user data with all fields', () async {
      when(() => mockSecureStorage.write(
              key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.cacheUser(tUser);

      verify(() => mockSecureStorage.write(
            key: '${StorageKeysConfig.userId}_data',
            value: any(named: 'value'),
          )).called(1);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.userId,
            value: tUser.id,
          )).called(1);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.userEmail,
            value: tUser.email,
          )).called(1);
    });
  });

  group('getCachedUser', () {
    test('should return user when data exists', () async {
      final userMap = {
        'id': 'user123',
        'email': 'test@example.com',
        'displayName': 'Test User',
        'phoneNumber': '+1234567890',
        'photoUrl': null,
        'isEmailVerified': true,
        'createdAt': null,
        'updatedAt': null,
      };
      final userJson = jsonEncode(userMap);

      when(() =>
              mockSecureStorage.read(key: '${StorageKeysConfig.userId}_data'))
          .thenAnswer((_) async => Right(userJson));

      final result = await dataSource.getCachedUser();

      expect(result, isNotNull);
      expect(result?.id, 'user123');
      expect(result?.email, 'test@example.com');
      expect(result?.displayName, 'Test User');
    });

    test('should return null when no user data exists', () async {
      when(() =>
              mockSecureStorage.read(key: '${StorageKeysConfig.userId}_data'))
          .thenAnswer((_) async => const Right(null));

      final result = await dataSource.getCachedUser();

      expect(result, isNull);
    });

    test('should return null when JSON decoding fails', () async {
      when(() =>
              mockSecureStorage.read(key: '${StorageKeysConfig.userId}_data'))
          .thenAnswer((_) async => const Right('invalid json'));

      final result = await dataSource.getCachedUser();

      expect(result, isNull);
    });
  });

  group('cacheUserSettings', () {
    final tSettings = UserSettingsEntity(
      userId: 'user123',
      biometricEnabled: true,
      biometricType: BiometricType.fingerprint,
      sessionTimeoutMinutes: 30,
      autoLockTimeoutSeconds: 120,
    );

    test('should cache user settings', () async {
      when(() => mockSecureStorage.write(
              key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.cacheUserSettings(tSettings);

      verify(() => mockSecureStorage.write(
            key: '${StorageKeysConfig.userId}_settings',
            value: any(named: 'value'),
          )).called(1);
      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.biometricEnabled,
            value: 'true',
          )).called(1);
    });
  });

  group('isBiometricEnabled', () {
    test('should return true when biometric is enabled', () async {
      when(() =>
              mockSecureStorage.read(key: StorageKeysConfig.biometricEnabled))
          .thenAnswer((_) async => const Right('true'));

      final result = await dataSource.isBiometricEnabled();

      expect(result, true);
    });

    test('should return false when biometric is disabled', () async {
      when(() =>
              mockSecureStorage.read(key: StorageKeysConfig.biometricEnabled))
          .thenAnswer((_) async => const Right('false'));

      final result = await dataSource.isBiometricEnabled();

      expect(result, false);
    });

    test('should return false when read fails', () async {
      when(() =>
              mockSecureStorage.read(key: StorageKeysConfig.biometricEnabled))
          .thenAnswer((_) async => const Left(StorageReadFailure()));

      final result = await dataSource.isBiometricEnabled();

      expect(result, false);
    });
  });

  group('setBiometricEnabled', () {
    test('should store biometric enabled status as string', () async {
      when(() => mockSecureStorage.write(
              key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.setBiometricEnabled(true);

      verify(() => mockSecureStorage.write(
            key: StorageKeysConfig.biometricEnabled,
            value: 'true',
          )).called(1);
    });
  });

  group('clearAllCache', () {
    test('should delete all cached data', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.clearAllCache();

      verify(() => mockSecureStorage.delete(key: StorageKeysConfig.sessionId))
          .called(1);
      verify(() =>
              mockSecureStorage.delete(key: '${StorageKeysConfig.userId}_data'))
          .called(1);
      verify(() => mockSecureStorage.delete(
          key: '${StorageKeysConfig.userId}_settings')).called(1);
      verify(() => mockSecureStorage.delete(key: StorageKeysConfig.authToken))
          .called(2);
      verify(() =>
              mockSecureStorage.delete(key: StorageKeysConfig.refreshToken))
          .called(1);
    });
  });

  group('clearUserDataOnly', () {
    test('should clear user data but preserve biometric credentials', () async {
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      await dataSource.clearUserDataOnly();

      verify(() =>
              mockSecureStorage.delete(key: '${StorageKeysConfig.userId}_data'))
          .called(1);
      verify(() => mockSecureStorage.delete(
          key: '${StorageKeysConfig.userId}_settings')).called(1);
      verifyNever(() =>
          mockSecureStorage.delete(key: StorageKeysConfig.biometricEmail));
      verifyNever(() =>
          mockSecureStorage.delete(key: StorageKeysConfig.biometricPassword));
    });
  });
}
