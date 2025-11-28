import '../repositories/auth_repository.dart';

class StoreBiometricSettingsUseCase {
  final AuthRepository repository;

  StoreBiometricSettingsUseCase(this.repository);

  Future<void> call({
    required bool enabled,
    required String type,
  }) {
    return repository.storeBiometricSettings(
      enabled: enabled,
      type: type,
    );
  }
}
