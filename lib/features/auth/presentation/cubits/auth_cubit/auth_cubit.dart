import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_user_usecase.dart';
import '../../../domain/usecases/register_user_usecase.dart';
import '../../../domain/usecases/store_user_credentials_usecase.dart';
import '../../../domain/usecases/biometric_login_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';
import 'auth_state.dart';
import 'package:team_18_final_project/core/security/session_manager.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUserUseCase loginUseCase;
  final RegisterUserUseCase registerUseCase;
  final StoreUserCredentialsUseCase storeCredentials;
  final BiometricLoginUseCase biometricLoginUseCase;
  final AuthRepository repository;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.storeCredentials,
    required this.biometricLoginUseCase,
    required this.repository,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final token = await loginUseCase(email, password);

      await storeCredentials(
        userId: "mock-user-id",
        token: token,
      );
      await SessionManager.startSession();

      // Store credentials for biometric login
      await repository.storeCredentialsForBiometric(
        email: email,
        password: password,
      );

      final enabled = await repository.isBiometricEnabled();
      final type = await repository.getBiometricType();

      emit(AuthLoginSuccess(
        biometricEnabled: enabled,
        biometricType: type,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(UserModel user) async {
    emit(AuthLoading());

    try {
      final userId = await registerUseCase(user);

      await storeCredentials(
        userId: userId,
        token: "register_token_123",
      );
      await SessionManager.startSession();

      emit(AuthRegisterSuccess(userId));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginWithBiometric() async {
    emit(AuthLoading());

    try {
      final token = await biometricLoginUseCase();

      await storeCredentials(
        userId: "biometric-user-id",
        token: token,
      );
      await SessionManager.startSession();

      final enabled = await repository.isBiometricEnabled();
      final type = await repository.getBiometricType();

      emit(AuthLoginSuccess(
        biometricEnabled: enabled,
        biometricType: type,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
