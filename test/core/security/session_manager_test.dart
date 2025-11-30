import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/implementations/session_manager_impl.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/security/interfaces/i_encryption_service.dart';
import 'package:dartz/dartz.dart';

class MockSecureStorage extends Mock implements ISecureStorage {}
class MockEncryptionService extends Mock implements IEncryptionService {}

void main() {
  late SessionManagerImpl sessionManager;
  late MockSecureStorage mockSecureStorage;
  late MockEncryptionService mockEncryptionService;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    mockEncryptionService = MockEncryptionService();
    sessionManager = SessionManagerImpl(
      secureStorage: mockSecureStorage,
      encryptionService: mockEncryptionService,
    );
  });

  tearDown(() {
    sessionManager.dispose();
  });

  group('SessionManager', () {
    const testUserId = 'test_user_123';
    const testToken = 'test_token_abc';

    test('should start session successfully', () async {
      // Arrange
      when(() => mockEncryptionService.encrypt(any()))
          .thenAnswer((_) async => const Right('encrypted_data'));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await sessionManager.startSession(
        userId: testUserId,
        token: testToken,
      );

      // Assert
      expect(result.isRight(), true);
      verify(() => mockEncryptionService.encrypt(any())).called(greaterThan(0));
      verify(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).called(greaterThan(0));
    });

    test('should check if session is valid', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('encrypted_session'));
      when(() => mockEncryptionService.decrypt(any()))
          .thenAnswer((_) async => Right(
                '{"userId":"$testUserId","token":"$testToken","startedAt":"${DateTime.now().toIso8601String()}"}',
              ));

      // Act
      final result = await sessionManager.isSessionValid();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (isValid) => expect(isValid, isTrue),
      );
    });

    test('should return false for expired session', () async {
      // Arrange
      final expiredTime = DateTime.now().subtract(const Duration(hours: 2));
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('encrypted_session'));
      when(() => mockEncryptionService.decrypt(any()))
          .thenAnswer((_) async => Right(
                '{"userId":"$testUserId","token":"$testToken","startedAt":"${expiredTime.toIso8601String()}"}',
              ));

      // Act
      final result = await sessionManager.isSessionValid();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isValid) => expect(isValid, isFalse),
      );
    });

    test('should update activity timestamp', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('encrypted_session'));
      when(() => mockEncryptionService.decrypt(any()))
          .thenAnswer((_) async => Right(
                '{"userId":"$testUserId","token":"$testToken","startedAt":"${DateTime.now().toIso8601String()}"}',
              ));
      when(() => mockEncryptionService.encrypt(any()))
          .thenAnswer((_) async => const Right('encrypted_updated_session'));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await sessionManager.updateActivity();

      // Assert
      expect(result.isRight(), true);
    });

    test('should end session and clear data', () async {
      // Arrange
      when(() => mockSecureStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await sessionManager.endSession();

      // Assert
      expect(result.isRight(), true);
      verify(() => mockSecureStorage.delete(key: any(named: 'key')))
          .called(greaterThan(0));
    });

    test('should emit session state changes', () async {
      // Arrange
      when(() => mockEncryptionService.encrypt(any()))
          .thenAnswer((_) async => const Right('encrypted_data'));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final stream = sessionManager.sessionStateStream;

      // Start session should emit true
      await sessionManager.startSession(
        userId: testUserId,
        token: testToken,
      );

      // Assert
      await expectLater(stream, emits(true));
    });

    test('should handle concurrent session updates', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => const Right('encrypted_session'));
      when(() => mockEncryptionService.decrypt(any()))
          .thenAnswer((_) async => Right(
                '{"userId":"$testUserId","token":"$testToken","startedAt":"${DateTime.now().toIso8601String()}"}',
              ));
      when(() => mockEncryptionService.encrypt(any()))
          .thenAnswer((_) async => const Right('encrypted_updated_session'));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async => const Right(null));

      // Act
      final futures = List.generate(
        5,
        (_) => sessionManager.updateActivity(),
      );
      final results = await Future.wait(futures);

      // Assert
      expect(results.every((r) => r.isRight()), true);
    });
  });
}
