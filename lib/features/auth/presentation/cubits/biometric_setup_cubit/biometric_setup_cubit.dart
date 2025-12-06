import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/config/storage_keys_config.dart';
import '../../../domain/usecases/store_biometric_settings_usecase.dart';
import '../../../domain/failures/biometric_failure.dart';
import 'biometric_setup_state.dart';

class BiometricSetupCubit extends Cubit<BiometricSetupState> {
  final StoreBiometricSettingsUseCase storeSettings;
  final ISecureStorage _secureStorage;

  BiometricSetupCubit({
    required this.storeSettings,
    required ISecureStorage secureStorage,
  })  : _secureStorage = secureStorage,
        super(BiometricSetupInitial());

  Future<void> saveBiometric({
    String? email,
    String? password,
    required String type,
  }) async {
    emit(BiometricSetupSaving());

    // Get stored credentials using ISecureStorage
    final resolvedEmail = email ??
      await _secureStorage.read(key: StorageKeysConfig.biometricEmail).then(
        (result) => result.fold((_) => null, (value) => value),
      );

    final resolvedPassword = password ??
      await _secureStorage.read(key: StorageKeysConfig.biometricPassword).then(
        (result) => result.fold((_) => null, (value) => value),
      );

    // Validate that we have credentials
    if (resolvedEmail == null || resolvedEmail.isEmpty ||
        resolvedPassword == null || resolvedPassword.isEmpty) {
      emit(BiometricSetupError('No stored credentials found for biometric setup.'));
      return;
    }

    final result = await storeSettings(
      email: resolvedEmail,
      password: resolvedPassword,
      biometricType: type,
    );

    result.fold(
      (failure) => emit(BiometricSetupError(_mapFailureToMessage(failure))),
      (_) => emit(BiometricSetupSuccess()),
    );
  }

  String _mapFailureToMessage(BiometricFailure failure) {
    if (failure is BiometricNotAvailableFailure) {
      return 'Biometric authentication is not available on this device.';
    } else if (failure is BiometricNotEnrolledFailure) {
      return 'No biometric credentials are enrolled. Please set up biometrics in your device settings.';
    } else if (failure is BiometricAuthFailedFailure) {
      return 'Biometric authentication failed. Please try again.';
    } else if (failure is BiometricCredentialsNotStoredFailure) {
      return 'Failed to store biometric credentials securely.';
    }
    return failure.message;
  }
}
