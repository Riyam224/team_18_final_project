import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/config/security_config.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import '../repositories/auth_repository.dart';
import '../entities/auth_session_entity.dart';
import '../failures/auth_failure.dart';

class BiometricLoginUseCase {
  final AuthRepository repository;
  final IBiometricService biometricService;

  BiometricLoginUseCase(this.repository, this.biometricService);

  Future<Either<AuthFailure, AuthSessionEntity>> call() async {
    // Authenticate with biometric
    final authResult = await biometricService.authenticate(
      localizedReason: SecurityConfig.defaultBiometricReason,
    );

    return authResult.fold(
      (biometricFailure) => Left(
        GenericAuthFailure(
          message: 'Biometric authentication failed: ${biometricFailure.message}',
          code: 'biometric-auth-failed',
        ),
      ),
      (_) async {
        // Get stored credentials from repository
        final emailResult = await repository.getStoredEmail();
        final passwordResult = await repository.getStoredPassword();

        // Handle email result
        final email = emailResult.fold(
          (failure) => null,
          (value) => value,
        );

        // Handle password result
        final password = passwordResult.fold(
          (failure) => null,
          (value) => value,
        );

        if (email == null || password == null || email.isEmpty || password.isEmpty) {
          return const Left(
            GenericAuthFailure(
              message: 'No stored credentials found for biometric login',
              code: 'no-stored-credentials',
            ),
          );
        }

        // Perform login with stored credentials
        return await repository.login(email, password);
      },
    );
  }
}
