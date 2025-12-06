import 'package:team_18_final_project/features/auth/data/models/auth_session.dart';
import 'package:team_18_final_project/features/auth/domain/entities/auth_session_entity.dart';

/// Mapper class to convert between AuthSession (data) and AuthSessionEntity (domain)
class SessionMapper {
  const SessionMapper._();

  /// Converts AuthSession model to AuthSessionEntity
  static AuthSessionEntity fromModel(AuthSession model, {DateTime? startedAt}) {
    return AuthSessionEntity(
      userId: model.userId,
      token: model.token,
      startedAt: startedAt ?? DateTime.now(),
    );
  }

  /// Converts AuthSessionEntity to AuthSession model
  static AuthSession toModel(AuthSessionEntity entity) {
    return AuthSession(
      userId: entity.userId,
      token: entity.token,
    );
  }

  /// Converts AuthSessionEntity to Map for storage
  static Map<String, dynamic> toMap(AuthSessionEntity entity) {
    return {
      'userId': entity.userId,
      'token': entity.token,
      'refreshToken': entity.refreshToken,
      'expiresAt': entity.expiresAt?.toIso8601String(),
      'startedAt': entity.startedAt.toIso8601String(),
    };
  }

  /// Converts Map to AuthSessionEntity
  static AuthSessionEntity fromMap(Map<String, dynamic> map) {
    return AuthSessionEntity(
      userId: map['userId'] as String,
      token: map['token'] as String,
      refreshToken: map['refreshToken'] as String?,
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'] as String)
          : null,
      startedAt: map['startedAt'] != null
          ? DateTime.parse(map['startedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Converts AuthSessionEntity to JSON string
  static String toJson(AuthSessionEntity entity) {
    return '${entity.userId}|${entity.token}|${entity.refreshToken ?? ''}|${entity.expiresAt?.toIso8601String() ?? ''}|${entity.startedAt.toIso8601String()}';
  }

  /// Converts JSON string to AuthSessionEntity
  static AuthSessionEntity? fromJson(String json) {
    try {
      final parts = json.split('|');
      if (parts.length < 5) return null;

      return AuthSessionEntity(
        userId: parts[0],
        token: parts[1],
        refreshToken: parts[2].isNotEmpty ? parts[2] : null,
        expiresAt: parts[3].isNotEmpty ? DateTime.parse(parts[3]) : null,
        startedAt: DateTime.parse(parts[4]),
      );
    } catch (e) {
      return null;
    }
  }
}
