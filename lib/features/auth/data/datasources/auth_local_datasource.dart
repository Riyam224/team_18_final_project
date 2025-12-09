import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/biometric_credentials_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheSession(AuthSessionEntity session);

  Future<AuthSessionEntity?> getLastSession();

  Future<void> clearSession();

  Future<void> cacheBiometricCredentials(
      BiometricCredentialsEntity credentials);

  Future<BiometricCredentialsEntity?> getBiometricCredentials();

  Future<void> clearBiometricCredentials();

  Future<void> storeUserEmail(String email);

  Future<void> cacheUser(UserEntity user);

  Future<UserEntity?> getCachedUser();

  Future<void> cacheUserSettings(UserSettingsEntity settings);

  Future<UserSettingsEntity?> getCachedUserSettings();

  Future<void> clearAllCache();

  Future<void> clearUserDataOnly();

  Future<bool> isBiometricEnabled();

  Future<void> setBiometricEnabled(bool enabled);

  Future<String?> getUserId();

  Future<void> storeUserId(String userId);

  Future<void> clearUserId();

  Future<String?> getUserFirstName();

  Future<void> storeUserFirstName(String firstName);

  Future<void> storeUserLastName(String lastName);

  Future<void> storeUserPhone(String phone);
}
