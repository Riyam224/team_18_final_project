import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import '../../../domain/usecases/biometric_login_usecase.dart';
import '../../../domain/usecases/store_user_credentials_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'biometric_verify_state.dart';

class BiometricVerifyCubit extends Cubit<BiometricVerifyState> {
  final BiometricLoginUseCase biometricLoginUseCase;
  final StoreUserCredentialsUseCase storeCredentials;
  final AuthRepository repository;
  final IAppLockService _appLockService;
  final ISessionManager _sessionManager;
  bool _hasStarted = false;

  BiometricVerifyCubit({
    required this.biometricLoginUseCase,
    required this.storeCredentials,
    required this.repository,
    required IAppLockService appLockService,
    required ISessionManager sessionManager,
  })  : _appLockService = appLockService,
        _sessionManager = sessionManager,
        super(BiometricVerifyInitial());

  Future<void> verify() async {
    if (_hasStarted) {
      debugPrint(
          'BiometricVerifyCubit.verify already started, skipping duplicate call');
      return;
    }
    if (isClosed) return;
    _hasStarted = true;
    debugPrint('BiometricVerifyCubit.verify CALLED');

    if (isClosed) return;
    emit(BiometricVerifyLoading());

    // Update activity timestamp BEFORE authentication to prevent app lock during biometric
    await _appLockService.updateActivity();

    // Perform actual biometric login
    final result = await biometricLoginUseCase();

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(BiometricVerifyFailed(failure.message));
      },
      (session) async {
        // Store credentials and start session
        await storeCredentials(
          userId: session.userId,
          token: session.token,
        );

        // Start session using injected session manager
        await _sessionManager.startSession(
          userId: session.userId,
          token: session.token,
        );

        // Unlock the app immediately after successful authentication
        await _appLockService.unlock();

        // Update activity timestamp to prevent auto-lock
        await _appLockService.updateActivity();

        // Get biometric type
        String biometricType = 'unknown';
        final typeResult = await repository.getBiometricType();
        biometricType = typeResult.fold(
          (failure) {
            debugPrint('Unable to read biometric type: ${failure.message}');
            return 'unknown';
          },
          (value) => value ?? 'unknown',
        );

        if (isClosed) return;
        emit(BiometricVerifySuccess(biometricType: biometricType));
      },
    );
  }
}
