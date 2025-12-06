class UserSettings {
  final bool biometricEnabled;
  final String? biometricType;
  final int sessionTimeoutMinutes;
  final int autoLockTimeoutMinutes;
  final String? avatarPath;

  const UserSettings({
    required this.biometricEnabled,
    required this.biometricType,
    required this.sessionTimeoutMinutes,
    required this.autoLockTimeoutMinutes,
    this.avatarPath,
  });

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      biometricEnabled: (map['biometricEnabled'] ?? false) as bool,
      biometricType: map['biometricType'] as String?,
      sessionTimeoutMinutes: (map['sessionTimeoutMinutes'] ?? 30) as int,
      autoLockTimeoutMinutes: (map['autoLockTimeoutMinutes'] ?? 2) as int,
      avatarPath: map['avatarPath'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'biometricEnabled': biometricEnabled,
        'biometricType': biometricType,
        'sessionTimeoutMinutes': sessionTimeoutMinutes,
        'autoLockTimeoutMinutes': autoLockTimeoutMinutes,
        'avatarPath': avatarPath,
      };
}
