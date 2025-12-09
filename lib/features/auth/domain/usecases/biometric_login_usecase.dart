import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/core/config/validation_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_session_entity.dart';
import '../failures/auth_failure.dart';

class BiometricLoginUseCase {
  final AuthRepository repository;
  final IBiometricService biometricService;

  BiometricLoginUseCase(this.repository, this.biometricService);

  Future<Either<AuthFailure, AuthSessionEntity>> call() async {
    final authResult = await biometricService.authenticate(
      localizedReason: SecurityConfig.defaultBiometricReason,
    );

    return authResult.fold(
      (biometricFailure) => Left(
        GenericAuthFailure(
          message:
              'Biometric authentication failed: ${biometricFailure.message}',
          code: 'biometric-auth-failed',
        ),
      ),
      (_) async {
        final emailResult = await repository.getStoredEmail();
        final passwordResult = await repository.getStoredPassword();

        final email = emailResult.fold(
          (failure) => null,
          (value) => value,
        );

        final password = passwordResult.fold(
          (failure) => null,
          (value) => value,
        );

        if (email == null || email.isEmpty) {
          return const Left(
            GenericAuthFailure(
              message:
                  'No email found in biometric storage. Please log in with email and password to refresh biometric login.',
              code: 'no-stored-email',
            ),
          );
        }

        if (password == null || password.isEmpty) {
          return const Left(
            GenericAuthFailure(
              message:
                  'No password found in biometric storage. Please log in with email and password to refresh biometric login.',
              code: 'no-stored-password',
            ),
          );
        }

        final cleanedEmail = email.trim();
        final cleanedPassword = password.trim();

        if (!ValidationConfig.emailRegex.hasMatch(cleanedEmail)) {
          return Left(
            GenericAuthFailure(
              message:
                  'Stored email format is invalid: "$cleanedEmail". Please log in with email and password to refresh biometric login.',
              code: 'invalid-biometric-email',
            ),
          );
        }

        return await repository.login(cleanedEmail, cleanedPassword);
      },
    );
  }
}
