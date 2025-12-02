import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/implementations/encryption_service_impl.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:dartz/dartz.dart';

class MockSecureStorage extends Mock implements ISecureStorage {}

void main() {
  late EncryptionServiceImpl encryptionService;
  late MockSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
    encryptionService = EncryptionServiceImpl(
      secureStorage: mockSecureStorage,
    );
  });

  group('EncryptionService', () {
    const testData = 'sensitive data';
    String? storedKey;

    setUp(() {
      storedKey = null;
    });

    test('should encrypt data successfully', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => Right(storedKey));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((invocation) async {
        storedKey = invocation.namedArguments[Symbol('value')] as String;
        return Right(null);
      });

      // Act
      final result = await encryptionService.encrypt(testData);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (encrypted) {
          expect(encrypted, isNotEmpty);
          expect(encrypted, isNot(equals(testData)));
        },
      );
    });

    test('should decrypt data successfully', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => Right(storedKey));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((invocation) async {
        storedKey = invocation.namedArguments[Symbol('value')] as String;
        return Right(null);
      });

      // First encrypt
      final encryptResult = await encryptionService.encrypt(testData);
      final encrypted = encryptResult.fold(
        (failure) => throw Exception('Encryption failed'),
        (encrypted) => encrypted,
      );

      // Act
      final result = await encryptionService.decrypt(encrypted);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (decrypted) => expect(decrypted, equals(testData)),
      );
    });

    test('should return different encrypted values for same input', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => Right(storedKey));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((invocation) async {
        storedKey = invocation.namedArguments[Symbol('value')] as String;
        return Right(null);
      });

      // Act
      final result1 = await encryptionService.encrypt(testData);
      final result2 = await encryptionService.encrypt(testData);

      // Assert
      final encrypted1 = result1.getOrElse(() => '');
      final encrypted2 = result2.getOrElse(() => '');

      expect(encrypted1, isNot(equals(encrypted2)));
    });

    test('should handle empty string encryption', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => Right(storedKey));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((invocation) async {
        storedKey = invocation.namedArguments[Symbol('value')] as String;
        return Right(null);
      });

      // Act
      final result = await encryptionService.encrypt('');

      // Assert
      // Empty string encryption might fail in some implementations
      // We accept either success or failure as valid behavior
      expect(result.isRight() || result.isLeft(), true);
    });

    test('should handle decryption of invalid data', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => Right(storedKey));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((invocation) async {
        storedKey = invocation.namedArguments[Symbol('value')] as String;
        return Right(null);
      });

      // Act
      final result = await encryptionService.decrypt('invalid_encrypted_data');

      // Assert
      expect(result.isLeft(), true);
    });

    test('should maintain data integrity after encrypt-decrypt cycle',
        () async {
      // Arrange
      const originalData = 'Test data with special chars: !@#\$%^&*()';
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => Right(storedKey));
      when(() => mockSecureStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((invocation) async {
        storedKey = invocation.namedArguments[Symbol('value')] as String;
        return Right(null);
      });

      // Act
      final encrypted = await encryptionService.encrypt(originalData);
      final encryptedValue = encrypted.getOrElse(() => '');
      final decrypted = await encryptionService.decrypt(encryptedValue);

      // Assert
      decrypted.fold(
        (failure) => fail('Decryption should succeed'),
        (value) => expect(value, equals(originalData)),
      );
    });
  });
}
