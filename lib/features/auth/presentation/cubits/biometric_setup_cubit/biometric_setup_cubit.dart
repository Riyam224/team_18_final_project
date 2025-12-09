import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../domain/usecases/store_biometric_settings_usecase.dart';
import '../../../domain/failures/biometric_failure.dart';
import 'biometric_setup_state.dart';

class BiometricSetupCubit extends Cubit<BiometricSetupState> {
  final StoreBiometricSettingsUseCase storeSettings;
  final AuthLocalDataSource _localDataSource;

  BiometricSetupCubit({
    required this.storeSettings,
    required AuthLocalDataSource localDataSource,
  })  : _localDataSource = localDataSource,
        super(BiometricSetupInitial());

  Future<void> saveBiometric({
    String? email,
    String? password,
    required String type,
  }) async {
    emit(BiometricSetupSaving());

    final credentials = await _localDataSource.getBiometricCredentials();

    final resolvedEmail = email ?? credentials?.email;
    final resolvedPassword = password ?? credentials?.encryptedPassword;

    if (resolvedEmail == null ||
        resolvedEmail.isEmpty ||
        resolvedPassword == null ||
        resolvedPassword.isEmpty) {
      emit(BiometricSetupError(
          'No stored credentials found for biometric setup. Please log in first.'));
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
