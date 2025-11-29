import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:team_18_final_project/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:team_18_final_project/features/auth/data/mappers/settings_mapper.dart';
import 'package:team_18_final_project/features/auth/data/models/user_model.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/biometric_credentials_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_profile_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/failures/biometric_failure.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/validation/email_validator.dart';
import 'package:team_18_final_project/features/auth/domain/validation/password_validator.dart';

/// Clean Architecture implementation of AuthRepository
/// Coordinates between remote (Firebase) and local (secure storage) data sources
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<AuthFailure, AuthSessionEntity>> login(
    String email,
    String password,
  ) async {
    try {
      // Validate inputs
      final emailValidation = EmailValidator.validate(email);
      if (!emailValidation.isValid) {
        return Left(InvalidEmailFailure(message: emailValidation.error!));
      }

      final passwordValidation = PasswordValidator.validateMinimum(password);
      if (!passwordValidation.isValid) {
        return const Left(InvalidCredentialsFailure());
      }

      // Sign in with Firebase
      final user = await _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create session entity
      final session = AuthSessionEntity(
        userId: user.id,
        token: user.id, // In production, use actual JWT token
        startedAt: DateTime.now(),
      );

      // Cache session and user data locally
      await _localDataSource.cacheSession(session);
      await _localDataSource.cacheUser(user);

      return Right(session);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AuthSessionEntity>> register(
    UserModel userModel,
  ) async {
    try {
      // Validate inputs
      final emailValidation = EmailValidator.validate(userModel.email);
      if (!emailValidation.isValid) {
        return Left(InvalidEmailFailure(message: emailValidation.error!));
      }

      final passwordValidation = PasswordValidator.validate(userModel.password);
      if (!passwordValidation.isValid) {
        return Left(
          WeakPasswordFailure(message: passwordValidation.error!),
        );
      }

      // Register with Firebase
      final displayName = '${userModel.firstName} ${userModel.lastName}'.trim();
      final user = await _remoteDataSource.registerWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
        displayName: displayName.isNotEmpty ? displayName : null,
        phoneNumber: userModel.phone.isNotEmpty ? userModel.phone : null,
      );

      // Create session entity
      final session = AuthSessionEntity(
        userId: user.id,
        token: user.id,
        startedAt: DateTime.now(),
      );

      // Cache session and user data locally
      await _localDataSource.cacheSession(session);
      await _localDataSource.cacheUser(user);

      // Cache user settings with biometric preference
      final settings = UserSettingsEntity(
        userId: user.id,
        biometricEnabled: userModel.biometricEnabled,
      );
      await _localDataSource.cacheUserSettings(settings);

      return Right(session);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> storeUserCredentials({
    required String userId,
    required String token,
  }) async {
    try {
      final session = AuthSessionEntity(
        userId: userId,
        token: token,
        startedAt: DateTime.now(),
      );

      await _localDataSource.cacheSession(session);
      return const Right(null);
    } catch (e) {
      return Left(
        GenericAuthFailure(
          message: 'Failed to store credentials',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<BiometricFailure, void>> storeBiometricSettings({
    required String email,
    required String password,
    required String biometricType,
  }) async {
    try {
      final type = SettingsMapper.biometricTypeFromString(biometricType);

      final credentials = BiometricCredentialsEntity(
        email: email,
        encryptedPassword: password, // Should be encrypted in production
        biometricType: type,
        storedAt: DateTime.now(),
      );

      await _localDataSource.cacheBiometricCredentials(credentials);
      await _localDataSource.setBiometricEnabled(true);

      return const Right(null);
    } catch (e) {
      return Left(
        GenericBiometricFailure(
          message: 'Failed to store biometric settings',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<AuthFailure, UserProfileEntity>> getUserProfile(
    String userId,
  ) async {
    try {
      final profile = await _remoteDataSource.getUserProfile(userId);
      return Right(profile);
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> updateUserProfile(
    UserProfileEntity profile,
  ) async {
    try {
      await _remoteDataSource.updateUserProfile(profile);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserSettingsEntity>> getUserSettings(
    String userId,
  ) async {
    try {
      final settings = await _remoteDataSource.getUserSettings(userId);
      await _localDataSource.cacheUserSettings(settings);
      return Right(settings);
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> updateUserSettings(
    UserSettingsEntity settings,
  ) async {
    try {
      await _remoteDataSource.updateUserSettings(settings);
      await _localDataSource.cacheUserSettings(settings);
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, UserEntity?>> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // Get from Firebase
      final user = await _remoteDataSource.getCurrentUser();
      if (user != null) {
        await _localDataSource.cacheUser(user);
      }
      return Right(user);
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      await _localDataSource.clearAllCache();
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<BiometricFailure, void>> storeCredentialsForBiometric({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = BiometricCredentialsEntity(
        email: email,
        encryptedPassword: password, // Should be encrypted in production
        biometricType: BiometricType.none,
        storedAt: DateTime.now(),
      );

      await _localDataSource.cacheBiometricCredentials(credentials);
      return const Right(null);
    } catch (e) {
      return Left(
        GenericBiometricFailure(
          message: 'Failed to store credentials for biometric',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<BiometricFailure, BiometricCredentialsEntity?>>
      getBiometricCredentials() async {
    try {
      final credentials = await _localDataSource.getBiometricCredentials();
      return Right(credentials);
    } catch (e) {
      return Left(
        GenericBiometricFailure(
          message: 'Failed to get biometric credentials',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<AuthFailure, bool>> isBiometricEnabled() async {
    try {
      final enabled = await _localDataSource.isBiometricEnabled();
      return Right(enabled);
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, String?>> getBiometricType() async {
    try {
      final credentials = await _localDataSource.getBiometricCredentials();
      if (credentials == null) {
        return const Right(null);
      }
      final typeString =
          SettingsMapper.biometricTypeToString(credentials.biometricType);
      return Right(typeString);
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  // Legacy methods for backward compatibility
  @override
  Future<Either<AuthFailure, String?>> getStoredEmail() async {
    try {
      final credentials = await _localDataSource.getBiometricCredentials();
      return Right(credentials?.email);
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, String?>> getStoredPassword() async {
    try {
      final credentials = await _localDataSource.getBiometricCredentials();
      return Right(credentials?.encryptedPassword);
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, String?>> getUserFirstName() async {
    try {
      final user = await _localDataSource.getCachedUser();
      if (user == null || user.displayName == null) {
        final stored = await _localDataSource.getUserFirstName();
        return Right(stored);
      }
      // Extract first name from display name
      final firstName = user.displayName!.split(' ').first;
      return Right(firstName);
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> storeUserData(UserModel userModel) async {
    try {
      final displayName = '${userModel.firstName} ${userModel.lastName}'.trim();
      final user = UserEntity(
        id: '', // Will be set after authentication
        email: userModel.email,
        displayName: displayName.isNotEmpty ? displayName : null,
        phoneNumber: userModel.phone.isNotEmpty ? userModel.phone : null,
      );

      await _localDataSource.cacheUser(user);
      // Also persist basic profile fields to secure storage for UI reads
      await _localDataSource.storeUserFirstName(userModel.firstName);
      await _localDataSource.storeUserLastName(userModel.lastName);
      await _localDataSource.storeUserPhone(userModel.phone);
      return const Right(null);
    } catch (e) {
      return Left(GenericAuthFailure(details: e.toString()));
    }
  }

  /// Maps FirebaseAuthException to AuthFailure
  AuthFailure _mapFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const UserNotFoundFailure();
      case 'wrong-password':
      case 'invalid-credential':
        return const InvalidCredentialsFailure();
      case 'email-already-in-use':
        return const EmailAlreadyExistsFailure();
      case 'weak-password':
        return const WeakPasswordFailure();
      case 'invalid-email':
        return const InvalidEmailFailure();
      case 'user-disabled':
        return const AccountDisabledFailure();
      case 'too-many-requests':
        return const TooManyRequestsFailure();
      case 'operation-not-allowed':
        return const OperationNotAllowedFailure();
      case 'network-request-failed':
        return const AuthNetworkFailure();
      case 'requires-recent-login':
        return const RequiresRecentLoginFailure();
      case 'invalid-verification-code':
        return const InvalidVerificationCodeFailure();
      case 'invalid-verification-id':
        return const InvalidVerificationIdFailure();
      default:
        return GenericAuthFailure(
          code: e.code,
          details: e.message ?? 'An authentication error occurred',
        );
    }
  }

  /// Maps FirebaseException to AuthFailure
  AuthFailure _mapFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'not-found':
        return GenericAuthFailure(
          code: e.code,
          message: 'Data not found',
          details: e.message,
        );
      case 'permission-denied':
        return GenericAuthFailure(
          code: e.code,
          message: 'Permission denied',
          details: e.message,
        );
      case 'unavailable':
        return const AuthNetworkFailure();
      default:
        return GenericAuthFailure(
          code: e.code,
          details: e.message ?? 'A Firebase error occurred',
        );
    }
  }
}
