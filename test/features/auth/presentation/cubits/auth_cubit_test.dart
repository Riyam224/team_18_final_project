import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
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

class MockLoginUserUseCase extends Mock implements LoginUserUseCase {}

class MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

class MockStoreUserCredentialsUseCase extends Mock
    implements StoreUserCredentialsUseCase {}

class MockBiometricLoginUseCase extends Mock implements BiometricLoginUseCase {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionManager extends Mock implements ISessionManager {}

void main() {
  late AuthCubit cubit;
  late MockLoginUserUseCase mockLoginUseCase;
  late MockRegisterUserUseCase mockRegisterUseCase;
  late MockStoreUserCredentialsUseCase mockStoreCredentials;
  late MockBiometricLoginUseCase mockBiometricLoginUseCase;
  late MockAuthRepository mockRepository;
  late MockSessionManager mockSessionManager;

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
    mockLoginUseCase = MockLoginUserUseCase();
    mockRegisterUseCase = MockRegisterUserUseCase();
    mockStoreCredentials = MockStoreUserCredentialsUseCase();
    mockBiometricLoginUseCase = MockBiometricLoginUseCase();
    mockRepository = MockAuthRepository();
    mockSessionManager = MockSessionManager();

    cubit = AuthCubit(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      storeCredentials: mockStoreCredentials,
      biometricLoginUseCase: mockBiometricLoginUseCase,
      repository: mockRepository,
      sessionManager: mockSessionManager,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthCubit', () {
    final testSession = AuthSessionEntity(
      userId: 'test-user-id',
      token: 'test-token',
      refreshToken: 'test-refresh-token',
      startedAt: DateTime(2024, 1, 1),
      expiresAt: DateTime(2024, 1, 2),
    );

    group('login', () {
      const email = 'test@example.com';
      const password = 'password123';

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthLoginSuccess] when login succeeds',
        build: () {
          when(() => mockLoginUseCase(any(), any()))
              .thenAnswer((_) async => Right(testSession));
          when(() => mockStoreCredentials(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.getUserFirstName())
              .thenAnswer((_) async => const Right('Test'));
          when(() => mockRepository.isBiometricEnabled())
              .thenAnswer((_) async => const Right(false));
          when(() => mockRepository.getBiometricType())
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.login(email, password),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthLoginSuccess>()
              .having((s) => s.biometricEnabled, 'biometricEnabled', false)
              .having((s) => s.biometricType, 'biometricType', null),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'stores user credentials and starts session on successful login',
        build: () {
          when(() => mockLoginUseCase(any(), any()))
              .thenAnswer((_) async => Right(testSession));
          when(() => mockStoreCredentials(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.getUserFirstName())
              .thenAnswer((_) async => const Right('Test'));
          when(() => mockRepository.isBiometricEnabled())
              .thenAnswer((_) async => const Right(true));
          when(() => mockRepository.getBiometricType())
              .thenAnswer((_) async => const Right('fingerprint'));
          return cubit;
        },
        act: (cubit) => cubit.login(email, password),
        verify: (_) {
          verify(() => mockStoreCredentials(
                userId: testSession.userId,
                token: testSession.token,
              )).called(1);
          verify(() => mockSessionManager.startSession(
                userId: testSession.userId,
                token: testSession.token,
              )).called(1);
          verify(() => mockRepository.storeCredentialsForBiometric(
                email: email,
                password: password,
              )).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'extracts username from email when no existing user data',
        build: () {
          when(() => mockLoginUseCase(any(), any()))
              .thenAnswer((_) async => Right(testSession));
          when(() => mockStoreCredentials(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.getUserFirstName())
              .thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeUserData(any()))
              .thenAnswer((_) async => const Right(null));
          when(() => mockRepository.isBiometricEnabled())
              .thenAnswer((_) async => const Right(false));
          when(() => mockRepository.getBiometricType())
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.login('john.doe@example.com', password),
        verify: (_) {
          verify(() => mockRepository.storeUserData(any())).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when login fails with UserNotFoundFailure',
        build: () {
          when(() => mockLoginUseCase(any(), any()))
              .thenAnswer((_) async => const Left(UserNotFoundFailure()));
          return cubit;
        },
        act: (cubit) => cubit.login(email, password),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'No account found with this email. Please check your credentials.',
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when login fails with InvalidCredentialsFailure',
        build: () {
          when(() => mockLoginUseCase(any(), any()))
              .thenAnswer((_) async => const Left(InvalidCredentialsFailure()));
          return cubit;
        },
        act: (cubit) => cubit.login(email, password),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'Invalid email or password. Please try again.',
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when login fails with AuthNetworkFailure',
        build: () {
          when(() => mockLoginUseCase(any(), any()))
              .thenAnswer((_) async => const Left(AuthNetworkFailure()));
          return cubit;
        },
        act: (cubit) => cubit.login(email, password),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'Network error. Please check your connection.',
          ),
        ],
      );
    });

    group('register', () {
      final testUser = UserModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        password: 'password123',
        biometricEnabled: false,
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthRegisterSuccess] when registration succeeds',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => Right(testSession));
          when(() => mockStoreCredentials(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeUserData(any()))
              .thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.register(testUser),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthRegisterSuccess>().having(
            (s) => s.userId,
            'userId',
            testSession.userId,
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'stores user data and credentials on successful registration',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => Right(testSession));
          when(() => mockStoreCredentials(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeUserData(any()))
              .thenAnswer((_) async => const Right(null));
          when(() => mockRepository.storeCredentialsForBiometric(
                email: any(named: 'email'),
                password: any(named: 'password'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.register(testUser),
        verify: (_) {
          verify(() => mockRepository.storeUserData(testUser)).called(1);
          verify(() => mockRepository.storeCredentialsForBiometric(
                email: testUser.email,
                password: testUser.password,
              )).called(1);
          verify(() => mockSessionManager.startSession(
                userId: testSession.userId,
                token: testSession.token,
              )).called(1);
        },
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails with EmailAlreadyExistsFailure',
        build: () {
          when(() => mockRegisterUseCase(any())).thenAnswer(
              (_) async => const Left(EmailAlreadyExistsFailure()));
          return cubit;
        },
        act: (cubit) => cubit.register(testUser),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'An account with this email already exists.',
          ),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails with WeakPasswordFailure',
        build: () {
          when(() => mockRegisterUseCase(any()))
              .thenAnswer((_) async => const Left(WeakPasswordFailure()));
          return cubit;
        },
        act: (cubit) => cubit.register(testUser),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'Password is too weak. Please use a stronger password.',
          ),
        ],
      );
    });

    group('loginWithBiometric', () {
      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthLoginSuccess] when biometric login succeeds',
        build: () {
          when(() => mockBiometricLoginUseCase())
              .thenAnswer((_) async => Right(testSession));
          when(() => mockStoreCredentials(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockSessionManager.startSession(
                userId: any(named: 'userId'),
                token: any(named: 'token'),
              )).thenAnswer((_) async => const Right(null));
          when(() => mockRepository.isBiometricEnabled())
              .thenAnswer((_) async => const Right(true));
          when(() => mockRepository.getBiometricType())
              .thenAnswer((_) async => const Right('face'));
          return cubit;
        },
        act: (cubit) => cubit.loginWithBiometric(),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthLoginSuccess>()
              .having((s) => s.biometricEnabled, 'biometricEnabled', true)
              .having((s) => s.biometricType, 'biometricType', 'face'),
        ],
      );

      blocTest<AuthCubit, AuthState>(
        'emits [AuthLoading, AuthError] when biometric login fails',
        build: () {
          when(() => mockBiometricLoginUseCase()).thenAnswer((_) async =>
              const Left(
                  GenericAuthFailure(message: 'Biometric auth failed')));
          return cubit;
        },
        act: (cubit) => cubit.loginWithBiometric(),
        expect: () => [
          isA<AuthLoading>(),
          isA<AuthError>().having(
            (s) => s.message,
            'message',
            'Biometric auth failed',
          ),
        ],
      );
    });
  });
}
