import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/register_user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/register_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUserUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUserUseCase(mockRepository);
  });

  final tUser = RegisterUserEntity(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
    phone: '1234567890',
    password: 'Password123!',
    biometricEnabled: false,
  );

  final tAuthSession = AuthSessionEntity(
    userId: 'user123',
    token: 'token123',
    refreshToken: 'refresh123',
    startedAt: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(tUser);
  });

  group('call', () {
    test('should call repository register with user data', () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(tAuthSession));

      // Act
      await useCase.call(tUser);

      // Assert
      verify(() => mockRepository.register(tUser)).called(1);
    });

    test('should return AuthSessionEntity when registration is successful',
        () async {
      // Arrange
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(tAuthSession));

      // Act
      final result = await useCase.call(tUser);

      // Assert
      expect(result, equals(Right(tAuthSession)));
    });

    test(
        'should return EmailAlreadyExistsFailure when email is already registered',
        () async {
      // Arrange
      const tFailure = EmailAlreadyExistsFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.call(tUser);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return WeakPasswordFailure when password is weak', () async {
      // Arrange
      const tFailure = WeakPasswordFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.call(tUser);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return InvalidEmailFailure when email format is invalid',
        () async {
      // Arrange
      const tFailure = InvalidEmailFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.call(tUser);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });

    test('should return NetworkFailure when network error occurs', () async {
      // Arrange
      const tFailure = AuthNetworkFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase.call(tUser);

      // Assert
      expect(result, equals(const Left(tFailure)));
    });
  });
}
