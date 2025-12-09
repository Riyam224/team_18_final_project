import 'package:team_18_final_project/core/config/firebase_config.dart';

class UserSettings {
  final bool biometricEnabled;
  final String? biometricType;
  final int sessionTimeoutMinutes;
  final int autoLockTimeoutMinutes;
  final String? avatarUrl;

  const UserSettings({
    required this.biometricEnabled,
    required this.biometricType,
    required this.sessionTimeoutMinutes,
    required this.autoLockTimeoutMinutes,
    this.avatarUrl,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      biometricEnabled:
          (map[FirebaseConfig.biometricEnabledField] ?? false) as bool,
      biometricType: map[FirebaseConfig.biometricTypeField] as String?,
      sessionTimeoutMinutes:
          (map[FirebaseConfig.sessionTimeoutField] ?? 30) as int,
      autoLockTimeoutMinutes:
          ((map[FirebaseConfig.autoLockTimeoutField] ?? 120) as int) ~/ 60,
      avatarUrl: map[FirebaseConfig.avatarUrlField] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        FirebaseConfig.biometricEnabledField: biometricEnabled,
        FirebaseConfig.biometricTypeField: biometricType,
        FirebaseConfig.sessionTimeoutField: sessionTimeoutMinutes,
        FirebaseConfig.autoLockTimeoutField: autoLockTimeoutMinutes * 60,
        FirebaseConfig.avatarUrlField: avatarUrl,
      };

  UserSettings copyWith({
    bool? biometricEnabled,
    String? biometricType,
    int? sessionTimeoutMinutes,
    int? autoLockTimeoutMinutes,
    String? avatarUrl,
  }) {
    return UserSettings(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricType: biometricType ?? this.biometricType,
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      autoLockTimeoutMinutes:
          autoLockTimeoutMinutes ?? this.autoLockTimeoutMinutes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
