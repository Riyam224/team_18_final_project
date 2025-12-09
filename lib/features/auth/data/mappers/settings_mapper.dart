import 'package:team_18_final_project/core/config/firebase_config.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/features/auth/data/models/user_settings.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

class SettingsMapper {
  const SettingsMapper._();

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

  static UserSettingsEntity fromModel(UserSettings model, String userId) {
    return UserSettingsEntity(
      userId: userId,
      biometricEnabled: model.biometricEnabled,
      biometricType: biometricTypeFromString(model.biometricType),
      sessionTimeoutMinutes: model.sessionTimeoutMinutes,
      autoLockTimeoutSeconds: model.autoLockTimeoutMinutes * 60,
      avatarUrl: model.avatarUrl,
    );
  }

  static UserSettings toModel(UserSettingsEntity entity) {
    return UserSettings(
      biometricEnabled: entity.biometricEnabled,
      biometricType: biometricTypeToString(entity.biometricType),
      sessionTimeoutMinutes: entity.sessionTimeoutMinutes,
      autoLockTimeoutMinutes: entity.autoLockTimeoutSeconds ~/ 60,
      avatarUrl: entity.avatarUrl,
    );
  }

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
