import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/store_biometric_settings_usecase.dart';
import 'biometric_setup_state.dart';

class BiometricSetupCubit extends Cubit<BiometricSetupState> {
  final StoreBiometricSettingsUseCase storeSettings;

  BiometricSetupCubit(this.storeSettings)
      : super(BiometricSetupInitial());

  Future<void> saveBiometric(String type) async {
    emit(BiometricSetupSaving());

    try {
      await storeSettings(
        enabled: true,
        type: type,
      );

      emit(BiometricSetupSuccess());
    } catch (e) {
      emit(BiometricSetupError(e.toString()));
    }
  }
}
