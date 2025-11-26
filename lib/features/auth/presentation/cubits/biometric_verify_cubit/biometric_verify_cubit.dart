import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/security/app_lock_service.dart';
import 'package:team_18_final_project/core/security/local_auth_service.dart';
import '../../../domain/usecases/biometric_login_usecase.dart';
import '../../../domain/usecases/store_user_credentials_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'biometric_verify_state.dart';

class BiometricVerifyCubit extends Cubit<BiometricVerifyState> {
  final BiometricLoginUseCase biometricLoginUseCase;
  final StoreUserCredentialsUseCase storeCredentials;
  final AuthRepository repository;

  BiometricVerifyCubit({
    required this.biometricLoginUseCase,
    required this.storeCredentials,
    required this.repository,
  }) : super(BiometricVerifyInitial());

  Future<void> verify() async {
    emit(BiometricVerifyLoading());

    try {
      // Update activity timestamp BEFORE authentication to prevent app lock during biometric
      await AppLockService.updateActivity();

      final authenticated = await LocalAuthService.authenticate();

      if (!authenticated) {
        emit(BiometricVerifyFailed("Biometric authentication failed"));
        return;
      }

      String biometricType = 'unknown';
      try {
        biometricType = await repository.getBiometricType() ?? 'unknown';
      } catch (e) {
        debugPrint('Unable to read biometric type: $e');
      }

      // Emit success immediately so the UI can react even if persistence fails later
      emit(BiometricVerifySuccess(biometricType: biometricType));

      await _persistLoginAfterSuccess();
    } catch (e) {
      emit(BiometricVerifyFailed(e.toString()));
    }
  }

  Future<void> _persistLoginAfterSuccess() async {
    try {
      final token = await biometricLoginUseCase();

      await storeCredentials(
        userId: "biometric-user-id",
        token: token,
      );
    } catch (e) {
      // Do not block the success state; just log for debugging
      debugPrint('Biometric login persistence failed: $e');
    }
  }
}
