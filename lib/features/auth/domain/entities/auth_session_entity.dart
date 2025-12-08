import 'package:equatable/equatable.dart';

/// Pure domain entity representing an authentication session
class AuthSessionEntity extends Equatable {
  final String userId;
  final String token;
  final String? refreshToken;
  final DateTime? expiresAt;
  final DateTime startedAt;

  const AuthSessionEntity({
    required this.userId,
    required this.token,
    this.refreshToken,
    this.expiresAt,
    required this.startedAt,
  });

  /// Creates a copy of this entity with the given fields replaced with new values
  AuthSessionEntity copyWith({
    String? userId,
    String? token,
    String? refreshToken,
    DateTime? expiresAt,
    DateTime? startedAt,
  }) {
    return AuthSessionEntity(
      userId: userId ?? this.userId,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  /// Checks if the session is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Checks if the session is valid
  bool get isValid => !isExpired && token.isNotEmpty;

  @override
  List<Object?> get props => [
        userId,
        token,
        refreshToken,
        expiresAt,
        startedAt,
      ];

  @override
  bool get stringify => true;
}
