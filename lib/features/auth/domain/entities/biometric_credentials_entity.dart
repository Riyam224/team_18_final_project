import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/auth/domain/entities/user_settings_entity.dart';

/// Pure domain entity representing stored biometric credentials
class BiometricCredentialsEntity extends Equatable {
  final String email;
  final String encryptedPassword;
  final BiometricType biometricType;
  final DateTime storedAt;

  const BiometricCredentialsEntity({
    required this.email,
    required this.encryptedPassword,
    required this.biometricType,
    required this.storedAt,
  });

  /// Creates a copy of this entity with the given fields replaced with new values
  BiometricCredentialsEntity copyWith({
    String? email,
    String? encryptedPassword,
    BiometricType? biometricType,
    DateTime? storedAt,
  }) {
    return BiometricCredentialsEntity(
      email: email ?? this.email,
      encryptedPassword: encryptedPassword ?? this.encryptedPassword,
      biometricType: biometricType ?? this.biometricType,
      storedAt: storedAt ?? this.storedAt,
    );
  }

  @override
  List<Object?> get props => [
        email,
        encryptedPassword,
        biometricType,
        storedAt,
      ];

  @override
  bool get stringify => true;
}
