import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failures.dart';

/// Result of a security check
class SecurityCheckResult {
  final bool isSecure;
  final String message;
  final List<String> warnings;

  const SecurityCheckResult({
    required this.isSecure,
    required this.message,
    this.warnings = const [],
  });
}

/// Interface for device security detection operations
abstract class IRootDetectionService {
  /// Checks if the device is rooted (Android) or jailbroken (iOS)
  Future<Either<Failure, bool>> isDeviceRooted();

  /// Checks if the app is running on an emulator
  Future<Either<Failure, bool>> isOnEmulator();

  /// Checks if the device has mock location enabled
  Future<Either<Failure, bool>> isMockLocationEnabled();

  /// Checks if developer mode is enabled
  Future<Either<Failure, bool>> isDeveloperModeEnabled();

  /// Performs a comprehensive security check
  Future<Either<Failure, SecurityCheckResult>> performSecurityCheck();

  /// Checks if the device is considered secure
  Future<Either<Failure, bool>> isDeviceSecure();
}
