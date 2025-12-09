import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/core/config/security_config.dart';

/// Enum for biometric types
enum BiometricType {
  none,
  fingerprint,
  face,
}

/// Pure domain entity representing user settings
class UserSettingsEntity extends Equatable {
  final String userId;
  final bool biometricEnabled;
  final BiometricType biometricType;
  final int sessionTimeoutMinutes;
  final int autoLockTimeoutSeconds;
  final String? avatarUrl;
  final DateTime? settingsUpdatedAt;

  const UserSettingsEntity({
    required this.userId,
    this.biometricEnabled = false,
    this.biometricType = BiometricType.none,
    this.sessionTimeoutMinutes =
        SecurityConfig.defaultSessionTimeoutMinutesUserSetting,
    this.autoLockTimeoutSeconds =
        SecurityConfig.defaultAutoLockSecondsUserSetting,
    this.avatarUrl,
    this.settingsUpdatedAt,
  });

  /// Creates a copy of this entity with the given fields replaced with new values
  UserSettingsEntity copyWith({
    String? userId,
    bool? biometricEnabled,
    BiometricType? biometricType,
    int? sessionTimeoutMinutes,
    int? autoLockTimeoutSeconds,
    String? avatarUrl,
    DateTime? settingsUpdatedAt,
  }) {
    return UserSettingsEntity(
      userId: userId ?? this.userId,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricType: biometricType ?? this.biometricType,
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      autoLockTimeoutSeconds:
          autoLockTimeoutSeconds ?? this.autoLockTimeoutSeconds,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      settingsUpdatedAt: settingsUpdatedAt ?? this.settingsUpdatedAt,
    );
  }

  /// Gets the session timeout as a Duration
  Duration get sessionTimeout => Duration(minutes: sessionTimeoutMinutes);

  /// Gets the auto lock timeout as a Duration
  Duration get autoLockTimeout => Duration(seconds: autoLockTimeoutSeconds);

  @override
  List<Object?> get props => [
        userId,
        biometricEnabled,
        biometricType,
        sessionTimeoutMinutes,
        autoLockTimeoutSeconds,
        avatarUrl,
        settingsUpdatedAt,
      ];

  @override
  bool get stringify => true;
}
