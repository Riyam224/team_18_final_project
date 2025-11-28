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

      // Check if we already have user data stored
      final existingFirstName = await repository.getUserFirstName();

      // If no user data exists (first time login), extract name from email
      if (existingFirstName == null || existingFirstName.isEmpty) {
        // Extract username from email (before @)
        final username = email.split('@').first;
        // Capitalize first letter
        final firstName = username.isNotEmpty
            ? username[0].toUpperCase() + username.substring(1)
            : 'User';

        // Store minimal user data from login
        final loginUser = UserModel(
          firstName: firstName,
          lastName: '',
          email: email,
          phone: '',
          password: password,
          biometricEnabled: false,
        );
        await repository.storeUserData(loginUser);
      }

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

      // Store user data
      await repository.storeUserData(user);

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
