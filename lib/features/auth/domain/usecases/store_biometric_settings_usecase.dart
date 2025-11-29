import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../failures/biometric_failure.dart';

class StoreBiometricSettingsUseCase {
  final AuthRepository repository;

  StoreBiometricSettingsUseCase(this.repository);

  Future<Either<BiometricFailure, void>> call({
    required String email,
    required String password,
    required String biometricType,
  }) {
    return repository.storeBiometricSettings(
      email: email,
      password: password,
      biometricType: biometricType,
    );
  }
}
