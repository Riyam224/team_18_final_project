abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final bool biometricEnabled;
  final String? biometricType;

  AuthLoginSuccess({
    required this.biometricEnabled,
    this.biometricType,
  });
}

class AuthRegisterSuccess extends AuthState {
  final String userId;

  AuthRegisterSuccess(this.userId);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
