import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import '../../../domain/usecases/login_user_usecase.dart';
import '../../../domain/usecases/register_user_usecase.dart';
import '../../../domain/usecases/store_user_credentials_usecase.dart';
import '../../../domain/usecases/biometric_login_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/failures/auth_failure.dart';
import '../../../data/models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUserUseCase loginUseCase;
  final RegisterUserUseCase registerUseCase;
  final StoreUserCredentialsUseCase storeCredentials;
  final BiometricLoginUseCase biometricLoginUseCase;
  final AuthRepository repository;
  final ISessionManager sessionManager;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.storeCredentials,
    required this.biometricLoginUseCase,
    required this.repository,
    required this.sessionManager,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(email, password);

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (session) async {
        await storeCredentials(
          userId: session.userId,
          token: session.token,
        );
        await sessionManager.startSession(
          userId: session.userId,
          token: session.token,
        );

        // Store credentials for biometric login
        await repository.storeCredentialsForBiometric(
          email: email,
          password: password,
        );

        // Check if we already have user data stored
        final existingFirstNameResult = await repository.getUserFirstName();

        final existingFirstName = existingFirstNameResult.fold(
          (failure) => null,
          (value) => value,
        );

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

        final enabledResult = await repository.isBiometricEnabled();
        final typeResult = await repository.getBiometricType();

        final enabled =
            enabledResult.fold((failure) => false, (value) => value);
        final type = typeResult.fold((failure) => null, (value) => value);

        emit(AuthLoginSuccess(
          biometricEnabled: enabled,
          biometricType: type,
        ));
      },
    );
  }

  Future<void> register(UserModel user) async {
    emit(AuthLoading());

    try {
      final result = await registerUseCase(user);

      await result.fold(
        (failure) async => emit(AuthError(_mapFailureToMessage(failure))),
        (session) async {
          await storeCredentials(
            userId: session.userId,
            token: session.token,
          );

          // Store user data
          await repository.storeUserData(user);
          await repository.storeCredentialsForBiometric(
            email: user.email,
            password: user.password,
          );

          await sessionManager.startSession(
            userId: session.userId,
            token: session.token,
          );

          emit(AuthRegisterSuccess(session.userId));
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> loginWithBiometric() async {
    emit(AuthLoading());

    final result = await biometricLoginUseCase();

    result.fold(
      (failure) => emit(AuthError(_mapFailureToMessage(failure))),
      (session) async {
        await storeCredentials(
          userId: session.userId,
          token: session.token,
        );
        await sessionManager.startSession(
          userId: session.userId,
          token: session.token,
        );

        final enabledResult = await repository.isBiometricEnabled();
        final typeResult = await repository.getBiometricType();

        final enabled =
            enabledResult.fold((failure) => false, (value) => value);
        final type = typeResult.fold((failure) => null, (value) => value);

        emit(AuthLoginSuccess(
          biometricEnabled: enabled,
          biometricType: type,
        ));
      },
    );
  }

  String _mapFailureToMessage(AuthFailure failure) {
    if (failure is UserNotFoundFailure) {
      return 'No account found with this email. Please check your credentials.';
    } else if (failure is InvalidCredentialsFailure) {
      return 'Invalid email or password. Please try again.';
    } else if (failure is EmailAlreadyExistsFailure) {
      return 'An account with this email already exists.';
    } else if (failure is WeakPasswordFailure) {
      return 'Password is too weak. Please use a stronger password.';
    } else if (failure is InvalidEmailFailure) {
      return 'Please enter a valid email address.';
    } else if (failure is AuthNetworkFailure) {
      return 'Network error. Please check your connection.';
    } else if (failure is TooManyRequestsFailure) {
      return 'Too many attempts. Please try again later.';
    } else if (failure is AccountDisabledFailure) {
      return 'This account has been disabled.';
    }
    return failure.message;
  }
}
