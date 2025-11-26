abstract class BiometricVerifyState {}

class BiometricVerifyInitial extends BiometricVerifyState {}

class BiometricVerifyLoading extends BiometricVerifyState {}

class BiometricVerifySuccess extends BiometricVerifyState {
  final String biometricType;
  BiometricVerifySuccess({required this.biometricType});
}

class BiometricVerifyFailed extends BiometricVerifyState {
  final String message;
  BiometricVerifyFailed(this.message);
}
