import 'package:team_18_final_project/core/error/failures.dart';

/// Base class for authentication failures
abstract class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// User not found failure
class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure({
    super.message = 'User not found. Please check your credentials.',
    super.code = 'user-not-found',
    super.details,
  });
}

/// Invalid credentials failure
class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid email or password.',
    super.code = 'invalid-credentials',
    super.details,
  });
}

/// Email already exists failure
class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure({
    super.message = 'An account with this email already exists.',
    super.code = 'email-already-in-use',
    super.details,
  });
}

/// Weak password failure
class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure({
    super.message = 'Password is too weak. Please use a stronger password.',
    super.code = 'weak-password',
    super.details,
  });
}

/// Invalid email failure
class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure({
    super.message = 'Invalid email address format.',
    super.code = 'invalid-email',
    super.details,
  });
}

/// Account disabled failure
class AccountDisabledFailure extends AuthFailure {
  const AccountDisabledFailure({
    super.message = 'This account has been disabled.',
    super.code = 'user-disabled',
    super.details,
  });
}

/// Too many requests failure
class TooManyRequestsFailure extends AuthFailure {
  const TooManyRequestsFailure({
    super.message = 'Too many failed attempts. Please try again later.',
    super.code = 'too-many-requests',
    super.details,
  });
}

/// Operation not allowed failure
class OperationNotAllowedFailure extends AuthFailure {
  const OperationNotAllowedFailure({
    super.message = 'This operation is not allowed.',
    super.code = 'operation-not-allowed',
    super.details,
  });
}

/// Network request failure
class AuthNetworkFailure extends AuthFailure {
  const AuthNetworkFailure({
    super.message = 'Network error. Please check your internet connection.',
    super.code = 'network-request-failed',
    super.details,
  });
}

/// Invalid verification code failure
class InvalidVerificationCodeFailure extends AuthFailure {
  const InvalidVerificationCodeFailure({
    super.message = 'Invalid verification code.',
    super.code = 'invalid-verification-code',
    super.details,
  });
}

/// Invalid verification ID failure
class InvalidVerificationIdFailure extends AuthFailure {
  const InvalidVerificationIdFailure({
    super.message = 'Invalid verification ID.',
    super.code = 'invalid-verification-id',
    super.details,
  });
}

/// Requires recent login failure
class RequiresRecentLoginFailure extends AuthFailure {
  const RequiresRecentLoginFailure({
    super.message =
        'This operation requires recent authentication. Please log in again.',
    super.code = 'requires-recent-login',
    super.details,
  });
}

/// Generic auth failure for unknown errors
class GenericAuthFailure extends AuthFailure {
  const GenericAuthFailure({
    super.message = 'An authentication error occurred.',
    super.code,
    super.details,
  });
}
