import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/biometric_credentials_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/register_user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_profile_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';
import 'package:team_18_final_project/features/auth/domain/failures/auth_failure.dart';
import 'package:team_18_final_project/features/auth/domain/failures/biometric_failure.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, AuthSessionEntity>> login(
    String email,
    String password,
  );

  Future<Either<AuthFailure, AuthSessionEntity>> register(
    RegisterUserEntity user,
  );

  Future<Either<AuthFailure, void>> signOut();

  Future<Either<AuthFailure, UserEntity?>> getCurrentUser();

  Future<Either<AuthFailure, void>> storeUserCredentials({
    required String userId,
    required String token,
  });

  Future<Either<BiometricFailure, void>> storeBiometricSettings({
    required String email,
    required String password,
    required String biometricType,
  });

  Future<Either<BiometricFailure, void>> storeCredentialsForBiometric({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, void>> storeUserEmail(String email);

  Future<Either<BiometricFailure, BiometricCredentialsEntity?>>
      getBiometricCredentials();

  Future<Either<AuthFailure, bool>> isBiometricEnabled();

  Future<Either<AuthFailure, String?>> getBiometricType();

  Future<Either<AuthFailure, UserProfileEntity>> getUserProfile(String userId);

  Future<Either<AuthFailure, void>> updateUserProfile(
      UserProfileEntity profile);

  Future<Either<AuthFailure, UserSettingsEntity>> getUserSettings(
      String userId);

  Future<Either<AuthFailure, void>> updateUserSettings(
    UserSettingsEntity settings,
  );

  Future<Either<AuthFailure, String?>> getStoredEmail();

  Future<Either<AuthFailure, String?>> getStoredPassword();

  Future<Either<AuthFailure, String?>> getUserFirstName();

  Future<Either<AuthFailure, void>> storeUserData(RegisterUserEntity user);
}
