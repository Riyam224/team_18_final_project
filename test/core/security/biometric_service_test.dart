import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/implementations/local_auth_biometric_impl.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:local_auth/local_auth.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late LocalAuthBiometricImpl biometricService;
  late MockLocalAuthentication mockLocalAuth;

  setUp(() {
    mockLocalAuth = MockLocalAuthentication();
    biometricService = LocalAuthBiometricImpl(
      localAuth: mockLocalAuth,
    );
  });

  group('BiometricService - isAvailable', () {
    test('should return true when biometrics are available', () async {
      // Arrange
      when(() => mockLocalAuth.canCheckBiometrics)
          .thenAnswer((_) async => true);
      when(() => mockLocalAuth.isDeviceSupported())
          .thenAnswer((_) async => true);

      // Act
      final result = await biometricService.isAvailable();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (isAvailable) => expect(isAvailable, isTrue),
      );
    });

    test('should return false when biometrics are not available', () async {
      // Arrange
      when(() => mockLocalAuth.canCheckBiometrics)
          .thenAnswer((_) async => false);
      when(() => mockLocalAuth.isDeviceSupported())
          .thenAnswer((_) async => true);

      // Act
      final result = await biometricService.isAvailable();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isAvailable) => expect(isAvailable, isFalse),
      );
    });

    test('should return false when device is not supported', () async {
      // Arrange
      when(() => mockLocalAuth.isDeviceSupported())
          .thenAnswer((_) async => false);

      // Act
      final result = await biometricService.isAvailable();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isAvailable) => expect(isAvailable, isFalse),
      );
    });

    test('should handle errors and return BiometricFailure', () async {
      // Arrange
      when(() => mockLocalAuth.isDeviceSupported())
          .thenThrow(Exception('Device error'));

      // Act
      final result = await biometricService.isAvailable();

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('BiometricService - getAvailableBiometrics', () {
    test('should return fingerprint when available', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.fingerprint]);

      // Act
      final result = await biometricService.getAvailableBiometrics();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (biometrics) {
          expect(biometrics.length, 1);
          expect(biometrics.first, AvailableBiometricType.fingerprint);
        },
      );
    });

    test('should return face when available', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.face]);

      // Act
      final result = await biometricService.getAvailableBiometrics();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (biometrics) {
          expect(biometrics.length, 1);
          expect(biometrics.first, AvailableBiometricType.face);
        },
      );
    });

    test('should return multiple biometric types', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => [
                BiometricType.fingerprint,
                BiometricType.face,
              ]);

      // Act
      final result = await biometricService.getAvailableBiometrics();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (biometrics) {
          expect(biometrics.length, 2);
          expect(biometrics.contains(AvailableBiometricType.fingerprint), true);
          expect(biometrics.contains(AvailableBiometricType.face), true);
        },
      );
    });

    test('should return empty list when no biometrics available', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => []);

      // Act
      final result = await biometricService.getAvailableBiometrics();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (biometrics) => expect(biometrics.isEmpty, true),
      );
    });
  });

  group('BiometricService - authenticate', () {
    const localizedReason = 'Verify your identity';

    test('should authenticate successfully', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.fingerprint]);
      when(() => mockLocalAuth.canCheckBiometrics)
          .thenAnswer((_) async => true);
      when(() => mockLocalAuth.isDeviceSupported())
          .thenAnswer((_) async => true);
      when(() => mockLocalAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
          )).thenAnswer((_) async => true);

      // Act
      final result = await biometricService.authenticate(
        localizedReason: localizedReason,
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (authenticated) => expect(authenticated, isTrue),
      );
    });

    test('should return false when authentication fails', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.fingerprint]);
      when(() => mockLocalAuth.canCheckBiometrics)
          .thenAnswer((_) async => true);
      when(() => mockLocalAuth.isDeviceSupported())
          .thenAnswer((_) async => true);
      when(() => mockLocalAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
          )).thenAnswer((_) async => false);

      // Act
      final result = await biometricService.authenticate(
        localizedReason: localizedReason,
      );

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (authenticated) => expect(authenticated, isFalse),
      );
    });

    test('should handle authentication errors', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.fingerprint]);
      when(() => mockLocalAuth.canCheckBiometrics)
          .thenAnswer((_) async => true);
      when(() => mockLocalAuth.isDeviceSupported())
          .thenAnswer((_) async => true);
      when(() => mockLocalAuth.authenticate(
            localizedReason: any(named: 'localizedReason'),
            biometricOnly: any(named: 'biometricOnly'),
          )).thenThrow(Exception('Auth error'));

      // Act
      final result = await biometricService.authenticate(
        localizedReason: localizedReason,
      );

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('BiometricService - isEnrolled', () {
    test('should return true when biometrics are enrolled', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => [BiometricType.fingerprint]);

      // Act
      final result = await biometricService.isEnrolled();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not fail'),
        (isEnrolled) => expect(isEnrolled, isTrue),
      );
    });

    test('should return false when no biometrics are enrolled', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenAnswer((_) async => []);

      // Act
      final result = await biometricService.isEnrolled();

      // Assert
      result.fold(
        (failure) => fail('Should not fail'),
        (isEnrolled) => expect(isEnrolled, isFalse),
      );
    });

    test('should handle errors when checking enrollment', () async {
      // Arrange
      when(() => mockLocalAuth.getAvailableBiometrics())
          .thenThrow(Exception('Enrollment check error'));

      // Act
      final result = await biometricService.isEnrolled();

      // Assert
      expect(result.isLeft(), true);
    });
  });

  group('BiometricService - stopAuthentication', () {
    test('should call stopAuthentication on localAuth', () async {
      // Arrange
      when(() => mockLocalAuth.stopAuthentication())
          .thenAnswer((_) async => true);

      // Act
      await biometricService.stopAuthentication();

      // Assert
      verify(() => mockLocalAuth.stopAuthentication()).called(1);
    });

    test('should handle errors during stop authentication', () async {
      // Arrange
      when(() => mockLocalAuth.stopAuthentication())
          .thenThrow(Exception('Stop error'));

      // Act & Assert - should not throw
      expect(
        () => biometricService.stopAuthentication(),
        returnsNormally,
      );
    });
  });
}
