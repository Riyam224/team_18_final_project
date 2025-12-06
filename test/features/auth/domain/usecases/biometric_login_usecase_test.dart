import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/failures/biometric_failure.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/biometric_login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockBiometricService extends Mock implements IBiometricService {}

void main() {
  late BiometricLoginUseCase useCase;
  late MockAuthRepository mockRepository;
  late MockBiometricService mockBiometricService;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockBiometricService = MockBiometricService();
    useCase = BiometricLoginUseCase(mockRepository, mockBiometricService);
  });

  group('BiometricLoginUseCase', () {
    final testSession = AuthSessionEntity(
      userId: 'test-user-id',
      token: 'test-token',
      refreshToken: 'test-refresh-token',
      startedAt: DateTime(2024, 1, 1),
      expiresAt: DateTime(2024, 1, 2),
    );

    test('should authenticate with biometric and login successfully', () async {
      // arrange
      const storedEmail = 'test@example.com';
      const storedPassword = 'password123';

      when(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).thenAnswer((_) async => const Right(true));

      when(() => mockRepository.getStoredEmail())
          .thenAnswer((_) async => const Right(storedEmail));

      when(() => mockRepository.getStoredPassword())
          .thenAnswer((_) async => const Right(storedPassword));

      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      final result = await useCase();

      // assert
      expect(result, Right(testSession));
      verify(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).called(1);
      verify(() => mockRepository.getStoredEmail()).called(1);
      verify(() => mockRepository.getStoredPassword()).called(1);
      verify(() => mockRepository.login(storedEmail, storedPassword)).called(1);
    });

    test('should return failure when biometric authentication fails', () async {
      // arrange
      const biometricFailure = BiometricAuthFailedFailure();

      when(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).thenAnswer((_) async => const Left(biometricFailure));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GenericAuthFailure>());
          expect(failure.message, contains('Biometric authentication failed'));
        },
        (_) => fail('Should return failure'),
      );
      verify(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).called(1);
      verifyNever(() => mockRepository.getStoredEmail());
      verifyNever(() => mockRepository.getStoredPassword());
    });

    test('should return failure when no stored email found', () async {
      // arrange
      const failure = GenericAuthFailure(
        message: 'No email found',
        code: 'no-email',
      );

      when(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).thenAnswer((_) async => const Right(true));

      when(() => mockRepository.getStoredEmail())
          .thenAnswer((_) async => const Left(failure));

      when(() => mockRepository.getStoredPassword())
          .thenAnswer((_) async => const Right('password123'));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GenericAuthFailure>());
          expect(failure.message, contains('No stored credentials found'));
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return failure when no stored password found', () async {
      // arrange
      const failure = GenericAuthFailure(
        message: 'No password found',
        code: 'no-password',
      );

      when(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).thenAnswer((_) async => const Right(true));

      when(() => mockRepository.getStoredEmail())
          .thenAnswer((_) async => const Right('test@example.com'));

      when(() => mockRepository.getStoredPassword())
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GenericAuthFailure>());
          expect(failure.message, contains('No stored credentials found'));
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return failure when stored email is empty', () async {
      // arrange
      when(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).thenAnswer((_) async => const Right(true));

      when(() => mockRepository.getStoredEmail())
          .thenAnswer((_) async => const Right(''));

      when(() => mockRepository.getStoredPassword())
          .thenAnswer((_) async => const Right('password123'));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GenericAuthFailure>());
          expect(failure.message, contains('No stored credentials found'));
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return failure when stored password is empty', () async {
      // arrange
      when(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).thenAnswer((_) async => const Right(true));

      when(() => mockRepository.getStoredEmail())
          .thenAnswer((_) async => const Right('test@example.com'));

      when(() => mockRepository.getStoredPassword())
          .thenAnswer((_) async => const Right(''));

      // act
      final result = await useCase();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GenericAuthFailure>());
          expect(failure.message, contains('No stored credentials found'));
        },
        (_) => fail('Should return failure'),
      );
    });

    test('should return failure when login with stored credentials fails',
        () async {
      // arrange
      const storedEmail = 'test@example.com';
      const storedPassword = 'password123';
      const loginFailure = InvalidCredentialsFailure();

      when(() => mockBiometricService.authenticate(
            localizedReason: any(named: 'localizedReason'),
          )).thenAnswer((_) async => const Right(true));

      when(() => mockRepository.getStoredEmail())
          .thenAnswer((_) async => const Right(storedEmail));

      when(() => mockRepository.getStoredPassword())
          .thenAnswer((_) async => const Right(storedPassword));

      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(loginFailure));

      // act
      final result = await useCase();

      // assert
      expect(result, const Left(loginFailure));
    });
  });
}
