import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/features/auth/data/models/user_model.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/biometric_login_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/store_user_credentials_usecase.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_state.dart';
import 'package:team_18_final_project/features/auth/domain/entities/register_user_entity.dart';

class MockLoginUserUseCase extends Mock implements LoginUserUseCase {}

class MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

class MockStoreUserCredentialsUseCase extends Mock
    implements StoreUserCredentialsUseCase {}

class MockBiometricLoginUseCase extends Mock implements BiometricLoginUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionManager extends Mock implements ISessionManager {}

class MockBiometricService extends Mock implements IBiometricService {}

void main() {
  late AuthCubit cubit;
  late MockLoginUserUseCase mockLoginUseCase;
  late MockRegisterUserUseCase mockRegisterUseCase;
  late MockStoreUserCredentialsUseCase mockStoreCredentials;
  late MockBiometricLoginUseCase mockBiometricLoginUseCase;
  late MockAuthRepository mockRepository;
  late MockSessionManager mockSessionManager;
  late MockBiometricService mockBiometricService;

  setUp(() {
    mockLoginUseCase = MockLoginUserUseCase();
    mockRegisterUseCase = MockRegisterUserUseCase();
    mockStoreCredentials = MockStoreUserCredentialsUseCase();
    mockBiometricLoginUseCase = MockBiometricLoginUseCase();
    mockRepository = MockAuthRepository();
    mockSessionManager = MockSessionManager();
    mockBiometricService = MockBiometricService();

    cubit = AuthCubit(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      storeCredentials: mockStoreCredentials,
      biometricLoginUseCase: mockBiometricLoginUseCase,
      repository: mockRepository,
      sessionManager: mockSessionManager,
      biometricService: mockBiometricService,
    );
  });

  setUpAll(() {
    registerFallbackValue(const RegisterUserEntity(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phone: '1234567890',
      password: 'password',
      biometricEnabled: false,
    ));
    registerFallbackValue(UserModel(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phone: '1234567890',
      password: 'password',
      biometricEnabled: false,
    ));
  });

  tearDown(() {
    cubit.close();
  });

  const tEmail = 'test@example.com';
  const tPassword = 'Password123!';
  final tAuthSession = AuthSessionEntity(
    userId: 'user123',
    token: 'token123',
    refreshToken: 'refresh123',
    startedAt: DateTime(2024, 1, 1),
  );

  final tUser = UserModel(
    firstName: 'John',
    lastName: 'Doe',
    email: tEmail,
    phone: '1234567890',
    password: tPassword,
    biometricEnabled: false,
  );

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthLoginSuccess] when login is successful',
      build: () {
        when(() => mockLoginUseCase(any(), any()))
            .thenAnswer((_) async => Right(tAuthSession));
        when(() => mockStoreCredentials(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeUserEmail(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.getUserFirstName())
            .thenAnswer((_) async => const Right('John'));
        when(() => mockRepository.isBiometricEnabled())
            .thenAnswer((_) async => const Right(false));
        when(() => mockRepository.getBiometricType())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthLoginSuccess>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails with InvalidCredentialsFailure',
      build: () {
        when(() => mockLoginUseCase(any(), any()))
            .thenAnswer((_) async => const Left(InvalidCredentialsFailure()));
        return cubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails with UserNotFoundFailure',
      build: () {
        when(() => mockLoginUseCase(any(), any()))
            .thenAnswer((_) async => const Left(UserNotFoundFailure()));
        return cubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails with NetworkFailure',
      build: () {
        when(() => mockLoginUseCase(any(), any()))
            .thenAnswer((_) async => const Left(AuthNetworkFailure()));
        return cubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should store user credentials after successful login',
      build: () {
        when(() => mockLoginUseCase(any(), any()))
            .thenAnswer((_) async => Right(tAuthSession));
        when(() => mockStoreCredentials(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeUserEmail(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.getUserFirstName())
            .thenAnswer((_) async => const Right('John'));
        when(() => mockRepository.isBiometricEnabled())
            .thenAnswer((_) async => const Right(false));
        when(() => mockRepository.getBiometricType())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.login(tEmail, tPassword),
      verify: (_) {
        verify(() => mockStoreCredentials(
            userId: tAuthSession.userId, token: tAuthSession.token)).called(1);
      },
    );
  });

  group('register', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthRegisterSuccess] when registration is successful',
      build: () {
        when(() => mockRegisterUseCase(any()))
            .thenAnswer((_) async => Right(tAuthSession));
        when(() => mockStoreCredentials(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeUserData(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeUserEmail(any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockBiometricService.isAvailable())
            .thenAnswer((_) async => const Right(false));
        when(() => mockBiometricService.isEnrolled())
            .thenAnswer((_) async => const Right(false));
        return cubit;
      },
      act: (cubit) => cubit.register(tUser),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthRegisterSuccess>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when registration fails with EmailAlreadyExistsFailure',
      build: () {
        when(() => mockRegisterUseCase(any()))
            .thenAnswer((_) async => const Left(EmailAlreadyExistsFailure()));
        return cubit;
      },
      act: (cubit) => cubit.register(tUser),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when registration fails with WeakPasswordFailure',
      build: () {
        when(() => mockRegisterUseCase(any()))
            .thenAnswer((_) async => const Left(WeakPasswordFailure()));
        return cubit;
      },
      act: (cubit) => cubit.register(tUser),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );
  });

  group('loginWithBiometric', () {
    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthLoginSuccess] when biometric login is successful',
      build: () {
        when(() => mockBiometricLoginUseCase())
            .thenAnswer((_) async => Right(tAuthSession));
        when(() => mockStoreCredentials(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'), token: any(named: 'token')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.isBiometricEnabled())
            .thenAnswer((_) async => const Right(true));
        when(() => mockRepository.getBiometricType())
            .thenAnswer((_) async => const Right('fingerprint'));
        when(() => mockRepository.getStoredEmail())
            .thenAnswer((_) async => const Right(tEmail));
        when(() => mockRepository.getStoredPassword())
            .thenAnswer((_) async => const Right(tPassword));
        when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepository.storeUserEmail(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.loginWithBiometric(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthLoginSuccess>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when biometric login fails',
      build: () {
        when(() => mockBiometricLoginUseCase())
            .thenAnswer((_) async => const Left(InvalidCredentialsFailure()));
        return cubit;
      },
      act: (cubit) => cubit.loginWithBiometric(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );
  });
}
