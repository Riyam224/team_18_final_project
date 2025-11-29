import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/login_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUserUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUserUseCase(mockRepository);
  });

  group('LoginUserUseCase', () {
    final testSession = AuthSessionEntity(
      userId: 'test-user-id',
      token: 'test-token',
      refreshToken: 'test-refresh-token',
      startedAt: DateTime(2024, 1, 1),
      expiresAt: DateTime(2024, 1, 2),
    );

    test('should clean input and call repository login', () async {
      // arrange
      const email = 'test@example.com';
      const password = 'password123';
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      final result = await useCase(email, password);

      // assert
      expect(result, Right(testSession));
      verify(() => mockRepository.login(email, password)).called(1);
    });

    test('should clean email with leading/trailing whitespace', () async {
      // arrange
      const emailWithSpaces = '  test@example.com  ';
      const cleanedEmail = 'test@example.com';
      const password = 'password123';
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      await useCase(emailWithSpaces, password);

      // assert
      verify(() => mockRepository.login(cleanedEmail, password)).called(1);
    });

    test('should clean password with leading/trailing whitespace', () async {
      // arrange
      const email = 'test@example.com';
      const passwordWithSpaces = '  password123  ';
      const cleanedPassword = 'password123';
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      await useCase(email, passwordWithSpaces);

      // assert
      verify(() => mockRepository.login(email, cleanedPassword)).called(1);
    });

    test('should return failure when repository returns UserNotFoundFailure',
        () async {
      // arrange
      const email = 'test@example.com';
      const password = 'password123';
      const failure = UserNotFoundFailure();
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(email, password);

      // assert
      expect(result, const Left(failure));
    });

    test(
        'should return failure when repository returns InvalidCredentialsFailure',
        () async {
      // arrange
      const email = 'test@example.com';
      const password = 'wrongpassword';
      const failure = InvalidCredentialsFailure();
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(email, password);

      // assert
      expect(result, const Left(failure));
    });

    test('should return failure when repository returns AuthNetworkFailure',
        () async {
      // arrange
      const email = 'test@example.com';
      const password = 'password123';
      const failure = AuthNetworkFailure();
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(email, password);

      // assert
      expect(result, const Left(failure));
    });

    test('should handle empty email and password', () async {
      // arrange
      const email = '';
      const password = '';
      const failure = InvalidEmailFailure();
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      await useCase(email, password);

      // assert
      verify(() => mockRepository.login(email, password)).called(1);
    });
  });
}
