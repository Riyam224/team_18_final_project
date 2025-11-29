import 'dart:convert';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:team_18_final_project/features/auth/data/mappers/session_mapper.dart';
import 'package:team_18_final_project/features/auth/data/mappers/settings_mapper.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/biometric_credentials_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_entity.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

/// Implementation of AuthLocalDataSource using secure storage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final ISecureStorage _secureStorage;

  AuthLocalDataSourceImpl({
    required ISecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<void> cacheSession(AuthSessionEntity session) async {
    final sessionJson = SessionMapper.toJson(session);
    await _secureStorage.write(
      key: StorageKeysConfig.sessionId,
      value: sessionJson,
    );

    // Also cache user ID separately for quick access
    await _secureStorage.write(
      key: StorageKeysConfig.userId,
      value: session.userId,
    );

    // Cache token
    await _secureStorage.write(
      key: StorageKeysConfig.authToken,
      value: session.token,
    );
  }

  @override
  Future<AuthSessionEntity?> getLastSession() async {
    final result = await _secureStorage.read(
      key: StorageKeysConfig.sessionId,
    );

    return result.fold(
      (failure) => null,
      (sessionJson) {
        if (sessionJson == null) return null;
        return SessionMapper.fromJson(sessionJson);
      },
    );
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.delete(key: StorageKeysConfig.sessionId);
    await _secureStorage.delete(key: StorageKeysConfig.authToken);
    await _secureStorage.delete(key: StorageKeysConfig.sessionActive);
    await _secureStorage.delete(key: StorageKeysConfig.lastActivityTime);
  }

  @override
  Future<void> cacheBiometricCredentials(
    BiometricCredentialsEntity credentials,
  ) async {
    await _secureStorage.write(
      key: StorageKeysConfig.biometricEmail,
      value: credentials.email,
    );

    await _secureStorage.write(
      key: StorageKeysConfig.biometricPassword,
      value: credentials.encryptedPassword,
    );

    await _secureStorage.write(
      key: StorageKeysConfig.biometricType,
      value: SettingsMapper.biometricTypeToString(credentials.biometricType),
    );

    await _secureStorage.write(
      key: StorageKeysConfig.biometricCredentialsStored,
      value: 'true',
    );
  }

  @override
  Future<BiometricCredentialsEntity?> getBiometricCredentials() async {
    final emailResult = await _secureStorage.read(
      key: StorageKeysConfig.biometricEmail,
    );
    final passwordResult = await _secureStorage.read(
      key: StorageKeysConfig.biometricPassword,
    );
    final typeResult = await _secureStorage.read(
      key: StorageKeysConfig.biometricType,
    );

    // Check if all required fields are present
    final email = emailResult.fold((l) => null, (r) => r);
    final password = passwordResult.fold((l) => null, (r) => r);
    final typeStr = typeResult.fold((l) => null, (r) => r);

    if (email == null || password == null || typeStr == null) {
      return null;
    }

    return BiometricCredentialsEntity(
      email: email,
      encryptedPassword: password,
      biometricType: SettingsMapper.biometricTypeFromString(typeStr),
      storedAt: DateTime.now(), // We don't store this, so use current time
    );
  }

  @override
  Future<void> clearBiometricCredentials() async {
    await _secureStorage.delete(key: StorageKeysConfig.biometricEmail);
    await _secureStorage.delete(key: StorageKeysConfig.biometricPassword);
    await _secureStorage.delete(key: StorageKeysConfig.biometricType);
    await _secureStorage.delete(key: StorageKeysConfig.biometricCredentialsStored);
    await _secureStorage.delete(key: StorageKeysConfig.biometricEnabled);
  }

  @override
  Future<void> cacheUser(UserEntity user) async {
    final userMap = {
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName,
      'phoneNumber': user.phoneNumber,
      'photoUrl': user.photoUrl,
      'isEmailVerified': user.isEmailVerified,
      'createdAt': user.createdAt?.toIso8601String(),
      'updatedAt': user.updatedAt?.toIso8601String(),
    };

    await _secureStorage.write(
      key: '${StorageKeysConfig.userId}_data',
      value: jsonEncode(userMap),
    );

    // Cache individual fields for quick access
    await _secureStorage.write(
      key: StorageKeysConfig.userId,
      value: user.id,
    );

    await _secureStorage.write(
      key: StorageKeysConfig.userEmail,
      value: user.email,
    );

    if (user.displayName != null) {
      await _secureStorage.write(
        key: StorageKeysConfig.userDisplayName,
        value: user.displayName!,
      );
    }
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final result = await _secureStorage.read(
      key: '${StorageKeysConfig.userId}_data',
    );

    return result.fold(
      (failure) => null,
      (userJson) {
        if (userJson == null) return null;

        try {
          final userMap = jsonDecode(userJson) as Map<String, dynamic>;
          return UserEntity(
            id: userMap['id'] as String,
            email: userMap['email'] as String,
            displayName: userMap['displayName'] as String?,
            phoneNumber: userMap['phoneNumber'] as String?,
            photoUrl: userMap['photoUrl'] as String?,
            isEmailVerified: userMap['isEmailVerified'] as bool? ?? false,
            createdAt: userMap['createdAt'] != null
                ? DateTime.parse(userMap['createdAt'] as String)
                : null,
            updatedAt: userMap['updatedAt'] != null
                ? DateTime.parse(userMap['updatedAt'] as String)
                : null,
          );
        } catch (e) {
          return null;
        }
      },
    );
  }

  @override
  Future<void> cacheUserSettings(UserSettingsEntity settings) async {
    final settingsMap = {
      'userId': settings.userId,
      'biometricEnabled': settings.biometricEnabled,
      'biometricType': SettingsMapper.biometricTypeToString(settings.biometricType),
      'sessionTimeoutMinutes': settings.sessionTimeoutMinutes,
      'autoLockTimeoutSeconds': settings.autoLockTimeoutSeconds,
      'avatarUrl': settings.avatarUrl,
      'settingsUpdatedAt': settings.settingsUpdatedAt?.toIso8601String(),
    };

    await _secureStorage.write(
      key: '${StorageKeysConfig.userId}_settings',
      value: jsonEncode(settingsMap),
    );

    // Cache individual settings for quick access
    await _secureStorage.write(
      key: StorageKeysConfig.biometricEnabled,
      value: settings.biometricEnabled.toString(),
    );

    await _secureStorage.write(
      key: StorageKeysConfig.sessionTimeoutMinutes,
      value: settings.sessionTimeoutMinutes.toString(),
    );

    await _secureStorage.write(
      key: StorageKeysConfig.autoLockTimeoutSeconds,
      value: settings.autoLockTimeoutSeconds.toString(),
    );
  }

  @override
  Future<UserSettingsEntity?> getCachedUserSettings() async {
    final result = await _secureStorage.read(
      key: '${StorageKeysConfig.userId}_settings',
    );

    return result.fold(
      (failure) => null,
      (settingsJson) {
        if (settingsJson == null) return null;

        try {
          final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
          return UserSettingsEntity(
            userId: settingsMap['userId'] as String,
            biometricEnabled: settingsMap['biometricEnabled'] as bool? ?? false,
            biometricType: SettingsMapper.biometricTypeFromString(
              settingsMap['biometricType'] as String?,
            ),
            sessionTimeoutMinutes: settingsMap['sessionTimeoutMinutes'] as int? ?? 30,
            autoLockTimeoutSeconds: settingsMap['autoLockTimeoutSeconds'] as int? ?? 120,
            avatarUrl: settingsMap['avatarUrl'] as String?,
            settingsUpdatedAt: settingsMap['settingsUpdatedAt'] != null
                ? DateTime.parse(settingsMap['settingsUpdatedAt'] as String)
                : null,
          );
        } catch (e) {
          return null;
        }
      },
    );
  }

  @override
  Future<void> clearAllCache() async {
    await clearSession();
    await clearBiometricCredentials();
    await _secureStorage.delete(key: '${StorageKeysConfig.userId}_data');
    await _secureStorage.delete(key: '${StorageKeysConfig.userId}_settings');
    await _secureStorage.delete(key: StorageKeysConfig.userId);
    await _secureStorage.delete(key: StorageKeysConfig.userEmail);
    await _secureStorage.delete(key: StorageKeysConfig.userDisplayName);
    await _secureStorage.delete(key: StorageKeysConfig.userPhotoUrl);
    await _secureStorage.delete(key: StorageKeysConfig.userPhoneNumber);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final result = await _secureStorage.read(
      key: StorageKeysConfig.biometricEnabled,
    );

    return result.fold(
      (failure) => false,
      (value) => value == 'true',
    );
  }

  @override
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: StorageKeysConfig.biometricEnabled,
      value: enabled.toString(),
    );
  }

  @override
  Future<String?> getUserId() async {
    final result = await _secureStorage.read(
      key: StorageKeysConfig.userId,
    );

    return result.fold(
      (failure) => null,
      (userId) => userId,
    );
  }

  @override
  Future<void> storeUserId(String userId) async {
    await _secureStorage.write(
      key: StorageKeysConfig.userId,
      value: userId,
    );
  }

  @override
  Future<void> clearUserId() async {
    await _secureStorage.delete(key: StorageKeysConfig.userId);
  }

  @override
  Future<String?> getUserFirstName() async {
    final result = await _secureStorage.read(key: 'user_first_name');
    return result.fold((failure) => null, (value) => value);
  }

  @override
  Future<void> storeUserFirstName(String firstName) async {
    await _secureStorage.write(key: 'user_first_name', value: firstName);
  }

  @override
  Future<void> storeUserLastName(String lastName) async {
    await _secureStorage.write(key: 'user_last_name', value: lastName);
  }

  @override
  Future<void> storeUserPhone(String phone) async {
    await _secureStorage.write(
      key: StorageKeysConfig.userPhoneNumber,
      value: phone,
    );
  }
}
