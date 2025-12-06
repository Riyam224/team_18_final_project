import 'package:dartz/dartz.dart';
import 'package:safe_device/safe_device.dart';
import 'package:team_18_final_project/core/error/failures.dart';
import 'package:team_18_final_project/core/security/interfaces/i_root_detection_service.dart';

/// Implementation of IRootDetectionService
class RootDetectionServiceImpl implements IRootDetectionService {
  @override
  Future<Either<Failure, bool>> isDeviceRooted() async {
    try {
      final isJailBroken = await SafeDevice.isJailBroken;
      return Right(isJailBroken);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to check if device is rooted',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isOnEmulator() async {
    try {
      final isRealDevice = await SafeDevice.isRealDevice;
      return Right(!isRealDevice);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to check if device is emulator',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isMockLocationEnabled() async {
    try {
      // Note: This feature may not be available in all versions of safe_device
      // Returning false as safe default
      return const Right(false);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to check mock location',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isDeveloperModeEnabled() async {
    try {
      final isDevelopmentMode = await SafeDevice.isDevelopmentModeEnable;
      return Right(isDevelopmentMode);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to check developer mode',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SecurityCheckResult>> performSecurityCheck() async {
    try {
      final isRooted = await SafeDevice.isJailBroken;
      final isRealDevice = await SafeDevice.isRealDevice;
      final isDevelopmentMode = await SafeDevice.isDevelopmentModeEnable;
      final isOnExternalStorage = await SafeDevice.isOnExternalStorage;

      final warnings = <String>[];

      if (isRooted) {
        warnings.add('Device is rooted or jailbroken');
      }

      if (!isRealDevice) {
        warnings.add('Running on emulator/simulator');
      }

      if (isDevelopmentMode) {
        warnings.add('Developer mode is enabled');
      }

      if (isOnExternalStorage) {
        warnings.add('App is installed on external storage');
      }

      final isSecure = !isRooted && isRealDevice;

      final message = isSecure
          ? 'Device security check passed'
          : warnings.isNotEmpty
              ? warnings.first
              : 'Device security check failed';

      return Right(
        SecurityCheckResult(
          isSecure: isSecure,
          message: message,
          warnings: warnings,
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to perform security check',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isDeviceSecure() async {
    try {
      final result = await performSecurityCheck();

      return result.fold(
        (failure) => Left(failure),
        (checkResult) => Right(checkResult.isSecure),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Failed to check device security',
          details: e.toString(),
        ),
      );
    }
  }
}
