abstract class BiometricSetupState {}

class BiometricSetupInitial extends BiometricSetupState {}

class BiometricSetupSaving extends BiometricSetupState {}

class BiometricSetupSuccess extends BiometricSetupState {}

class BiometricSetupError extends BiometricSetupState {
  final String message;
  BiometricSetupError(this.message);
}
