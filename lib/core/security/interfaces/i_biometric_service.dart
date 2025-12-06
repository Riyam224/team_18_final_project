import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/features/auth/domain/failures/biometric_failure.dart';

/// Enum representing available biometric types
enum AvailableBiometricType {
  none,
  fingerprint,
  face,
  iris,
}

/// Interface for biometric authentication operations
abstract class IBiometricService {
  /// Checks if biometric authentication is available on the device
  Future<Either<BiometricFailure, bool>> isAvailable();

  /// Gets available biometric types on the device
  Future<Either<BiometricFailure, List<AvailableBiometricType>>>
      getAvailableBiometrics();

  /// Authenticates the user using biometrics
  /// [localizedReason] is the message shown to the user during authentication
  Future<Either<BiometricFailure, bool>> authenticate({
    required String localizedReason,
  });

  /// Checks if biometric credentials are enrolled on the device
  Future<Either<BiometricFailure, bool>> isEnrolled();

  /// Stops any ongoing authentication
  Future<void> stopAuthentication();
}
