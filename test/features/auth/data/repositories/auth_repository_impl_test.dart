import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:team_18_final_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/biometric_credentials_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/register_user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(UserEntity(
      id: 'test',
      email: 'test@example.com',
      isEmailVerified: false,
    ));
    registerFallbackValue(UserSettingsEntity(
      userId: 'test',
      biometricEnabled: false,
      biometricType: BiometricType.none,
    ));
    registerFallbackValue(const RegisterUserEntity(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      password: 'password',
      phone: '',
      biometricEnabled: false,
    ));
    registerFallbackValue(AuthSessionEntity(
      userId: 'test',
      token: 'test-token',
      startedAt: DateTime(2024, 1, 1),
    ));
    registerFallbackValue(BiometricCredentialsEntity(
      email: 'test@example.com',
      encryptedPassword: 'encrypted',
      biometricType: BiometricType.fingerprint,
      storedAt: DateTime(2024, 1, 1),
    ));
  });

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUser = UserEntity(
      id: 'user123',
      email: tEmail,
      isEmailVerified: true,
    );

    test('should return session when login is successful', () async {
      when(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.cacheSession(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});

      final result = await repository.login(tEmail, tPassword);

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not return failure'),
        (session) {
          expect(session.userId, tUser.id);
          expect(session.token, tUser.id);
        },
      );
      verify(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          )).called(1);
      verify(() => mockLocalDataSource.cacheSession(any())).called(1);
      verify(() => mockLocalDataSource.cacheUser(tUser)).called(1);
    });

    test('should return InvalidEmailFailure when email is invalid', () async {
      const invalidEmail = 'invalid-email';

      final result = await repository.login(invalidEmail, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidEmailFailure>()),
        (r) => fail('Should not succeed'),
      );
      verifyNever(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });

    test('should return InvalidCredentialsFailure when password is too short', () async {
      const shortPassword = '123';

      final result = await repository.login(tEmail, shortPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (r) => fail('Should not succeed'),
      );
    });

    test('should return UserNotFoundFailure when user does not exist', () async {
      final exception = firebase_auth.FirebaseAuthException(code: 'user-not-found');
      when(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(exception);

      final result = await repository.login(tEmail, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UserNotFoundFailure>()),
        (r) => fail('Should not succeed'),
      );
    });

    test('should return InvalidCredentialsFailure for wrong password', () async {
      final exception = firebase_auth.FirebaseAuthException(code: 'wrong-password');
      when(() => mockRemoteDataSource.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(exception);

      final result = await repository.login(tEmail, tPassword);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (r) => fail('Should not succeed'),
      );
    });
  });

  group('register', () {
    final tRegisterUser = RegisterUserEntity(
      email: 'test@example.com',
      password: 'Password123!',
      firstName: 'John',
      lastName: 'Doe',
      phone: '+1234567890',
      biometricEnabled: true,
    );
    final tUser = UserEntity(
      id: 'user123',
      email: tRegisterUser.email,
      displayName: 'John Doe',
      phoneNumber: tRegisterUser.phone,
      isEmailVerified: false,
    );

    test('should register user and cache data when successful', () async {
      when(() => mockRemoteDataSource.registerWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.cacheSession(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUserSettings(any())).thenAnswer((_) async => {});

      final result = await repository.register(tRegisterUser);

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.registerWithEmailAndPassword(
            email: tRegisterUser.email,
            password: tRegisterUser.password,
            displayName: 'John Doe',
            phoneNumber: tRegisterUser.phone,
          )).called(1);
      verify(() => mockLocalDataSource.cacheSession(any())).called(1);
      verify(() => mockLocalDataSource.cacheUser(tUser)).called(1);
      verify(() => mockLocalDataSource.cacheUserSettings(any())).called(1);
    });

    test('should return InvalidEmailFailure for invalid email', () async {
      final invalidRegisterUser = RegisterUserEntity(
        email: 'invalid-email',
        password: 'Password123!',
        firstName: 'John',
        lastName: 'Doe',
        phone: '',
        biometricEnabled: false,
      );

      final result = await repository.register(invalidRegisterUser);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidEmailFailure>()),
        (r) => fail('Should not succeed'),
      );
    });

    test('should return WeakPasswordFailure for weak password', () async {
      final weakPasswordUser = RegisterUserEntity(
        email: 'test@example.com',
        password: '123',
        firstName: 'John',
        lastName: 'Doe',
        phone: '',
        biometricEnabled: false,
      );

      final result = await repository.register(weakPasswordUser);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<WeakPasswordFailure>()),
        (r) => fail('Should not succeed'),
      );
    });

    test('should return EmailAlreadyExistsFailure for duplicate email', () async {
      final exception = firebase_auth.FirebaseAuthException(code: 'email-already-in-use');
      when(() => mockRemoteDataSource.registerWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
            displayName: any(named: 'displayName'),
            phoneNumber: any(named: 'phoneNumber'),
          )).thenThrow(exception);

      final result = await repository.register(tRegisterUser);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<EmailAlreadyExistsFailure>()),
        (r) => fail('Should not succeed'),
      );
    });
  });

  group('signOut', () {
    test('should sign out and clear user data but preserve biometric credentials', () async {
      when(() => mockRemoteDataSource.signOut()).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.clearUserDataOnly()).thenAnswer((_) async => {});

      final result = await repository.signOut();

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.signOut()).called(1);
      verify(() => mockLocalDataSource.clearUserDataOnly()).called(1);
    });

    test('should return failure when sign out fails', () async {
      final exception = firebase_auth.FirebaseAuthException(code: 'network-request-failed');
      when(() => mockRemoteDataSource.signOut()).thenThrow(exception);

      final result = await repository.signOut();

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthNetworkFailure>()),
        (r) => fail('Should not succeed'),
      );
    });
  });

  group('getCurrentUser', () {
    final tUser = UserEntity(
      id: 'user123',
      email: 'test@example.com',
      isEmailVerified: true,
    );

    test('should return cached user when available', () async {
      when(() => mockLocalDataSource.getCachedUser()).thenAnswer((_) async => tUser);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not fail'),
        (user) => expect(user, tUser),
      );
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
      verifyNever(() => mockRemoteDataSource.getCurrentUser());
    });

    test('should fetch from remote when cache is empty', () async {
      when(() => mockLocalDataSource.getCachedUser()).thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.getCurrentUser()).thenAnswer((_) async => tUser);
      when(() => mockLocalDataSource.cacheUser(any())).thenAnswer((_) async => {});

      final result = await repository.getCurrentUser();

      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.getCachedUser()).called(1);
      verify(() => mockRemoteDataSource.getCurrentUser()).called(1);
      verify(() => mockLocalDataSource.cacheUser(tUser)).called(1);
    });

    test('should return null when no user is logged in', () async {
      when(() => mockLocalDataSource.getCachedUser()).thenAnswer((_) async => null);
      when(() => mockRemoteDataSource.getCurrentUser()).thenAnswer((_) async => null);

      final result = await repository.getCurrentUser();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not fail'),
        (user) => expect(user, isNull),
      );
    });
  });

  group('storeBiometricSettings', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tBiometricType = 'fingerprint';

    test('should store biometric credentials and enable biometric', () async {
      when(() => mockLocalDataSource.cacheBiometricCredentials(any()))
          .thenAnswer((_) async => {});
      when(() => mockLocalDataSource.setBiometricEnabled(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.storeUserEmail(any())).thenAnswer((_) async => {});

      final result = await repository.storeBiometricSettings(
        email: tEmail,
        password: tPassword,
        biometricType: tBiometricType,
      );

      expect(result.isRight(), true);
      verify(() => mockLocalDataSource.cacheBiometricCredentials(any())).called(1);
      verify(() => mockLocalDataSource.setBiometricEnabled(true)).called(1);
      verify(() => mockLocalDataSource.storeUserEmail(tEmail)).called(1);
    });
  });

  group('getBiometricCredentials', () {
    final tCredentials = BiometricCredentialsEntity(
      email: 'test@example.com',
      encryptedPassword: 'encrypted_password',
      biometricType: BiometricType.fingerprint,
      storedAt: DateTime(2024, 1, 1),
    );

    test('should return biometric credentials when they exist', () async {
      when(() => mockLocalDataSource.getBiometricCredentials())
          .thenAnswer((_) async => tCredentials);

      final result = await repository.getBiometricCredentials();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not fail'),
        (credentials) => expect(credentials, tCredentials),
      );
    });

    test('should return null when no credentials are stored', () async {
      when(() => mockLocalDataSource.getBiometricCredentials()).thenAnswer((_) async => null);

      final result = await repository.getBiometricCredentials();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not fail'),
        (credentials) => expect(credentials, isNull),
      );
    });
  });

  group('isBiometricEnabled', () {
    test('should return true when biometric is enabled', () async {
      when(() => mockLocalDataSource.isBiometricEnabled()).thenAnswer((_) async => true);

      final result = await repository.isBiometricEnabled();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not fail'),
        (enabled) => expect(enabled, true),
      );
    });

    test('should return false when biometric is disabled', () async {
      when(() => mockLocalDataSource.isBiometricEnabled()).thenAnswer((_) async => false);

      final result = await repository.isBiometricEnabled();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should not fail'),
        (enabled) => expect(enabled, false),
      );
    });
  });

  group('getUserSettings', () {
    const tUserId = 'user123';
    final tSettings = UserSettingsEntity(
      userId: tUserId,
      biometricEnabled: true,
      biometricType: BiometricType.fingerprint,
      sessionTimeoutMinutes: 30,
      autoLockTimeoutSeconds: 120,
    );

    test('should fetch and cache user settings', () async {
      when(() => mockRemoteDataSource.getUserSettings(any()))
          .thenAnswer((_) async => tSettings);
      when(() => mockLocalDataSource.cacheUserSettings(any())).thenAnswer((_) async => {});

      final result = await repository.getUserSettings(tUserId);

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.getUserSettings(tUserId)).called(1);
      verify(() => mockLocalDataSource.cacheUserSettings(tSettings)).called(1);
    });

    test('should handle Firestore errors gracefully', () async {
      final exception = FirebaseException(plugin: 'firestore', code: 'unavailable');
      when(() => mockRemoteDataSource.getUserSettings(any())).thenThrow(exception);

      final result = await repository.getUserSettings(tUserId);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<AuthNetworkFailure>()),
        (r) => fail('Should not succeed'),
      );
    });
  });

  group('updateUserSettings', () {
    final tSettings = UserSettingsEntity(
      userId: 'user123',
      biometricEnabled: true,
      biometricType: BiometricType.face,
      sessionTimeoutMinutes: 60,
      autoLockTimeoutSeconds: 180,
    );

    test('should update settings remotely and cache them', () async {
      when(() => mockRemoteDataSource.updateUserSettings(any())).thenAnswer((_) async => {});
      when(() => mockLocalDataSource.cacheUserSettings(any())).thenAnswer((_) async => {});

      final result = await repository.updateUserSettings(tSettings);

      expect(result.isRight(), true);
      verify(() => mockRemoteDataSource.updateUserSettings(tSettings)).called(1);
      verify(() => mockLocalDataSource.cacheUserSettings(tSettings)).called(1);
    });
  });
}
