import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/biometric_credentials_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

/// Local data source for authentication caching
/// Handles all secure storage operations for auth data
abstract class AuthLocalDataSource {
  /// Caches the current session
  Future<void> cacheSession(AuthSessionEntity session);

  /// Gets the last cached session
  /// Returns null if no session is cached
  Future<AuthSessionEntity?> getLastSession();

  /// Clears the cached session
  Future<void> clearSession();

  /// Caches biometric credentials
  Future<void> cacheBiometricCredentials(BiometricCredentialsEntity credentials);

  /// Gets cached biometric credentials
  /// Returns null if no credentials are cached
  Future<BiometricCredentialsEntity?> getBiometricCredentials();

  /// Clears biometric credentials
  Future<void> clearBiometricCredentials();

  /// Caches user data
  Future<void> cacheUser(UserEntity user);

  /// Gets cached user data
  /// Returns null if no user is cached
  Future<UserEntity?> getCachedUser();

  /// Caches user settings
  Future<void> cacheUserSettings(UserSettingsEntity settings);

  /// Gets cached user settings
  /// Returns null if no settings are cached
  Future<UserSettingsEntity?> getCachedUserSettings();

  /// Clears all cached auth data
  Future<void> clearAllCache();

  /// Checks if biometric is enabled
  Future<bool> isBiometricEnabled();

  /// Sets biometric enabled status
  Future<void> setBiometricEnabled(bool enabled);

  /// Gets the stored user ID
  Future<String?> getUserId();

  /// Stores the user ID
  Future<void> storeUserId(String userId);

  /// Clears the stored user ID
  Future<void> clearUserId();

  /// Gets user first name from storage
  Future<String?> getUserFirstName();

  /// Stores user first name
  Future<void> storeUserFirstName(String firstName);

  /// Stores user last name
  Future<void> storeUserLastName(String lastName);

  /// Stores user phone
  Future<void> storeUserPhone(String phone);
}
