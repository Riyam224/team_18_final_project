import 'package:equatable/equatable.dart';

/// Domain entity representing user registration data
/// Contains only the data needed for registration without infrastructure concerns
class RegisterUserEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final bool biometricEnabled;

  const RegisterUserEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.biometricEnabled,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        password,
        biometricEnabled,
      ];

  @override
  bool get stringify => true;
}
