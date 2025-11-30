import 'package:dartz/dartz.dart';
import 'package:local_auth/local_auth.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/features/auth/domain/failures/biometric_failure.dart';

/// Implementation of IBiometricService using local_auth package
class LocalAuthBiometricImpl implements IBiometricService {
  final LocalAuthentication _localAuth;

  LocalAuthBiometricImpl({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  @override
  Future<Either<BiometricFailure, bool>> isAvailable() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      // On some Android devices `canCheckBiometrics` returns false when nothing
      // is enrolled even though the device is capable. We treat the device as
      // available if it supports biometrics and let enrollment checks handle
      // the rest.
      return Right(isDeviceSupported || canCheckBiometrics);
    } catch (e) {
      return Left(
        GenericBiometricFailure(
          message: 'Failed to check biometric availability.',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<BiometricFailure, List<AvailableBiometricType>>>
      getAvailableBiometrics() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      final types = <AvailableBiometricType>[];

      for (final biometric in availableBiometrics) {
        switch (biometric) {
          case BiometricType.fingerprint:
            types.add(AvailableBiometricType.fingerprint);
            break;
          case BiometricType.face:
            types.add(AvailableBiometricType.face);
            break;
          case BiometricType.iris:
            types.add(AvailableBiometricType.iris);
            break;
          case BiometricType.strong:
          case BiometricType.weak:
            // Android reports "strong"/"weak" instead of a concrete type.
            // Treat both as fingerprint-capable so we don't incorrectly assume
            // no biometrics are enrolled on Android devices.
            types.add(AvailableBiometricType.fingerprint);
            break;
        }
      }

      if (types.isEmpty) {
        types.add(AvailableBiometricType.none);
      }

      return Right(types);
    } catch (e) {
      return Left(
        GenericBiometricFailure(
          message: 'Failed to get available biometrics.',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<BiometricFailure, bool>> authenticate({
    required String localizedReason,
  }) async {
    try {
      // Check if biometrics are available
      final availabilityResult = await isAvailable();
      if (availabilityResult.isLeft()) {
        return availabilityResult.fold(
          (failure) => Left(failure),
          (_) => const Left(BiometricNotAvailableFailure()),
        );
      }

      final isAvailableValue = availabilityResult.getOrElse(() => false);
      if (!isAvailableValue) {
        return const Left(BiometricNotAvailableFailure());
      }

      // Check if biometrics are enrolled
      final enrolledResult = await isEnrolled();
      if (enrolledResult.isLeft()) {
        return enrolledResult.fold(
          (failure) => Left(failure),
          (_) => const Left(BiometricNotEnrolledFailure()),
        );
      }

      final isEnrolledValue = enrolledResult.getOrElse(() => false);
      if (!isEnrolledValue) {
        return const Left(BiometricNotEnrolledFailure());
      }

      // Attempt authentication
      final authenticated = await _localAuth.authenticate(
        localizedReason:
            localizedReason.isEmpty ? SecurityConfig.defaultBiometricReason : localizedReason,
        biometricOnly: true,
      );

      return Right(authenticated);
    } on Exception catch (e) {
      // Handle specific local_auth exceptions
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('passcode') ||
          errorMessage.contains('not enrolled')) {
        return const Left(BiometricNotEnrolledFailure());
      }

      if (errorMessage.contains('cancel')) {
        return const Left(BiometricAuthCanceledFailure());
      }

      if (errorMessage.contains('lockout') ||
          errorMessage.contains('too many')) {
        if (errorMessage.contains('permanent')) {
          return const Left(BiometricPermanentLockoutFailure());
        }
        return const Left(BiometricLockoutFailure());
      }

      return const Left(BiometricAuthFailedFailure());
    } catch (e) {
      return Left(
        GenericBiometricFailure(
          message: 'Biometric authentication failed.',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<BiometricFailure, bool>> isEnrolled() async {
    try {
      final availableBiometricsResult = await getAvailableBiometrics();
      return availableBiometricsResult.fold(
        (failure) => Left(failure),
        (types) {
          final hasEnrolled = types.isNotEmpty &&
              !types.contains(AvailableBiometricType.none);
          return Right(hasEnrolled);
        },
      );
    } catch (e) {
      return Left(
        GenericBiometricFailure(
          message: 'Failed to check if biometrics are enrolled.',
          details: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      // Silently fail if stop authentication fails
    }
  }
}
