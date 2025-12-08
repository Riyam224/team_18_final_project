import 'package:team_18_final_project/core/config/firebase_config.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/features/auth/data/models/user_settings.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

/// Mapper class to convert between UserSettings (data) and UserSettingsEntity (domain)
class SettingsMapper {
  const SettingsMapper._();

  /// Converts BiometricType enum to string
  static String biometricTypeToString(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'fingerprint';
      case BiometricType.face:
        return 'face';
      case BiometricType.none:
        return 'none';
    }
  }

  /// Converts string to BiometricType enum
  static BiometricType biometricTypeFromString(String? type) {
    switch (type?.toLowerCase()) {
      case 'fingerprint':
        return BiometricType.fingerprint;
      case 'face':
        return BiometricType.face;
      default:
        return BiometricType.none;
    }
  }

  /// Converts UserSettings model to UserSettingsEntity
  static UserSettingsEntity fromModel(UserSettings model, String userId) {
    return UserSettingsEntity(
      userId: userId,
      biometricEnabled: model.biometricEnabled,
      biometricType: biometricTypeFromString(model.biometricType),
      sessionTimeoutMinutes: model.sessionTimeoutMinutes,
      autoLockTimeoutSeconds: model.autoLockTimeoutMinutes * 60, // Convert minutes to seconds
      avatarUrl: model.avatarPath,
    );
  }

  /// Converts UserSettingsEntity to UserSettings model
  static UserSettings toModel(UserSettingsEntity entity) {
    return UserSettings(
      biometricEnabled: entity.biometricEnabled,
      biometricType: biometricTypeToString(entity.biometricType),
      sessionTimeoutMinutes: entity.sessionTimeoutMinutes,
      autoLockTimeoutMinutes: entity.autoLockTimeoutSeconds ~/ 60, // Convert seconds to minutes
      avatarPath: entity.avatarUrl,
    );
  }

  /// Converts UserSettingsEntity to Firestore Map
  static Map<String, dynamic> toFirestore(UserSettingsEntity entity) {
    return {
      FirebaseConfig.biometricEnabledField: entity.biometricEnabled,
      FirebaseConfig.biometricTypeField: biometricTypeToString(entity.biometricType),
      FirebaseConfig.sessionTimeoutField: entity.sessionTimeoutMinutes,
      FirebaseConfig.autoLockTimeoutField: entity.autoLockTimeoutSeconds,
      FirebaseConfig.avatarUrlField: entity.avatarUrl,
      FirebaseConfig.settingsUpdatedAtField: DateTime.now().toIso8601String(),
    };
  }

  /// Converts Firestore Map to UserSettingsEntity
  static UserSettingsEntity fromFirestore(String userId, Map<String, dynamic> data) {
    return UserSettingsEntity(
      userId: userId,
      biometricEnabled: data[FirebaseConfig.biometricEnabledField] as bool? ?? false,
      biometricType: biometricTypeFromString(
        data[FirebaseConfig.biometricTypeField] as String?,
      ),
      sessionTimeoutMinutes: data[FirebaseConfig.sessionTimeoutField] as int? ??
          SecurityConfig.defaultSessionTimeoutMinutesUserSetting,
      autoLockTimeoutSeconds: data[FirebaseConfig.autoLockTimeoutField] as int? ??
          SecurityConfig.defaultAutoLockSecondsUserSetting,
      avatarUrl: data[FirebaseConfig.avatarUrlField] as String?,
      settingsUpdatedAt: data[FirebaseConfig.settingsUpdatedAtField] != null
          ? DateTime.parse(data[FirebaseConfig.settingsUpdatedAtField] as String)
          : null,
    );
  }
}
