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

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tAuthSession = AuthSessionEntity(
    userId: 'user123',
    token: 'token123',
    refreshToken: 'refresh123',
    startedAt: DateTime(2024, 1, 1),
  );

  group('call', () {
    test('should call repository login with cleaned email and password',
        () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(tAuthSession));

      // Act
      await useCase.call(tEmail, tPassword);

      // Assert
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('should return AuthSessionEntity when login is successful', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(tAuthSession));

      // Act
      final result = await useCase.call(tEmail, tPassword);

      // Assert
      expect(result, equals(Right(tAuthSession)));
    });

    test('should return AuthFailure when login fails', () async {
      // Arrange
      const tFailure = InvalidCredentialsFailure();
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.call(tEmail, tPassword);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should clean email input by trimming whitespace', () async {
      // Arrange
      const tEmailWithSpaces = '  test@example.com  ';
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(tAuthSession));

      // Act
      await useCase.call(tEmailWithSpaces, tPassword);

      // Assert
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('should clean password input by trimming whitespace', () async {
      // Arrange
      const tPasswordWithSpaces = '  password123  ';
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => Right(tAuthSession));

      // Act
      await useCase.call(tEmail, tPasswordWithSpaces);

      // Assert
      verify(() => mockRepository.login(tEmail, 'password123')).called(1);
    });

    test('should return UserNotFoundFailure when user does not exist',
        () async {
      // Arrange
      const tFailure = UserNotFoundFailure();
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.call(tEmail, tPassword);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const tFailure = AuthNetworkFailure();
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.call(tEmail, tPassword);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });
  });
}
