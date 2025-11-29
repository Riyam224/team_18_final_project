import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/features/auth/data/models/user_model.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/register_user_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUserUseCase useCase;
  late MockAuthRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const UserModel(
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      password: '',
      biometricEnabled: false,
    ));
  });

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUserUseCase(mockRepository);
  });

  group('RegisterUserUseCase', () {
    final testSession = AuthSessionEntity(
      userId: 'new-user-id',
      token: 'new-token',
      refreshToken: 'new-refresh-token',
      startedAt: DateTime(2024, 1, 1),
      expiresAt: DateTime(2024, 1, 2),
    );

    final testUser = UserModel(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
      password: 'password123',
      biometricEnabled: false,
    );

    test('should clean user input and call repository register', () async {
      // arrange
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      final result = await useCase(testUser);

      // assert
      expect(result, Right(testSession));
      verify(() => mockRepository.register(any())).called(1);
    });

    test('should trim firstName and lastName', () async {
      // arrange
      final userWithSpaces = UserModel(
        firstName: '  John  ',
        lastName: '  Doe  ',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        password: 'password123',
        biometricEnabled: false,
      );

      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      await useCase(userWithSpaces);

      // assert
      final captured = verify(() => mockRepository.register(captureAny()))
          .captured
          .single as UserModel;
      expect(captured.firstName, 'John');
      expect(captured.lastName, 'Doe');
    });

    test('should clean email with whitespace', () async {
      // arrange
      final userWithSpacedEmail = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        email: '  john.doe@example.com  ',
        phone: '+1234567890',
        password: 'password123',
        biometricEnabled: false,
      );

      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      await useCase(userWithSpacedEmail);

      // assert
      final captured = verify(() => mockRepository.register(captureAny()))
          .captured
          .single as UserModel;
      expect(captured.email, 'john.doe@example.com');
    });

    test('should clean password with whitespace', () async {
      // arrange
      final userWithSpacedPassword = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        password: '  password123  ',
        biometricEnabled: false,
      );

      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      await useCase(userWithSpacedPassword);

      // assert
      final captured = verify(() => mockRepository.register(captureAny()))
          .captured
          .single as UserModel;
      expect(captured.password, 'password123');
    });

    test('should trim phone number', () async {
      // arrange
      final userWithSpacedPhone = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '  +1234567890  ',
        password: 'password123',
        biometricEnabled: false,
      );

      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      await useCase(userWithSpacedPhone);

      // assert
      final captured = verify(() => mockRepository.register(captureAny()))
          .captured
          .single as UserModel;
      expect(captured.phone, '+1234567890');
    });

    test('should preserve biometricEnabled value', () async {
      // arrange
      final userWithBiometric = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        password: 'password123',
        biometricEnabled: true,
      );

      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => Right(testSession));

      // act
      await useCase(userWithBiometric);

      // assert
      final captured = verify(() => mockRepository.register(captureAny()))
          .captured
          .single as UserModel;
      expect(captured.biometricEnabled, true);
    });

    test('should return failure when email already exists', () async {
      // arrange
      const failure = EmailAlreadyExistsFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(testUser);

      // assert
      expect(result, const Left(failure));
    });

    test('should return failure when password is weak', () async {
      // arrange
      const failure = WeakPasswordFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(testUser);

      // assert
      expect(result, const Left(failure));
    });

    test('should return failure when email is invalid', () async {
      // arrange
      const failure = InvalidEmailFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(testUser);

      // assert
      expect(result, const Left(failure));
    });

    test('should return failure when network error occurs', () async {
      // arrange
      const failure = AuthNetworkFailure();
      when(() => mockRepository.register(any()))
          .thenAnswer((_) async => const Left(failure));

      // act
      final result = await useCase(testUser);

      // assert
      expect(result, const Left(failure));
    });
  });
}
