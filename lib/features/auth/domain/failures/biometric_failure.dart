import 'package:team_18_final_project/core/error/failures.dart';

/// Base class for biometric authentication failures
abstract class BiometricFailure extends Failure {
  const BiometricFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Biometric not available failure
class BiometricNotAvailableFailure extends BiometricFailure {
  const BiometricNotAvailableFailure({
    super.message = 'Biometric authentication is not available on this device.',
    super.code = 'biometric-not-available',
    super.details,
  });
}

/// Biometric not enrolled failure
class BiometricNotEnrolledFailure extends BiometricFailure {
  const BiometricNotEnrolledFailure({
    super.message =
        'No biometric credentials enrolled. Please set up biometric authentication in your device settings.',
    super.code = 'biometric-not-enrolled',
    super.details,
  });
}

/// Biometric authentication failed
class BiometricAuthFailedFailure extends BiometricFailure {
  const BiometricAuthFailedFailure({
    super.message = 'Biometric authentication failed. Please try again.',
    super.code = 'biometric-auth-failed',
    super.details,
  });
}

/// Biometric authentication canceled
class BiometricAuthCanceledFailure extends BiometricFailure {
  const BiometricAuthCanceledFailure({
    super.message = 'Biometric authentication was canceled.',
    super.code = 'biometric-auth-canceled',
    super.details,
  });
}

/// Biometric credentials not stored
class BiometricCredentialsNotStoredFailure extends BiometricFailure {
  const BiometricCredentialsNotStoredFailure({
    super.message =
        'No biometric credentials stored. Please set up biometric login first.',
    super.code = 'biometric-credentials-not-stored',
    super.details,
  });
}

/// Biometric lockout failure (too many attempts)
class BiometricLockoutFailure extends BiometricFailure {
  const BiometricLockoutFailure({
    super.message =
        'Too many failed biometric attempts. Please use your password to log in.',
    super.code = 'biometric-lockout',
    super.details,
  });
}

/// Biometric permanent lockout failure
class BiometricPermanentLockoutFailure extends BiometricFailure {
  const BiometricPermanentLockoutFailure({
    super.message =
        'Biometric authentication is locked. Please use your password.',
    super.code = 'biometric-permanent-lockout',
    super.details,
  });
}

/// Generic biometric failure
class GenericBiometricFailure extends BiometricFailure {
  const GenericBiometricFailure({
    super.message = 'A biometric error occurred.',
    super.code,
    super.details,
  });
}
