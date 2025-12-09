import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import '../../../data/models/user_model.dart';
import '../../../domain/entities/register_user_entity.dart';
import '../../../domain/failures/auth_failure.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/biometric_login_usecase.dart';
import '../../../domain/usecases/login_user_usecase.dart';
import '../../../domain/usecases/register_user_usecase.dart';
import '../../../domain/usecases/store_user_credentials_usecase.dart';
import 'auth_state.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUserUseCase loginUseCase;
  final RegisterUserUseCase registerUseCase;
  final StoreUserCredentialsUseCase storeCredentials;
  final BiometricLoginUseCase biometricLoginUseCase;
  final AuthRepository repository;
  final ISessionManager sessionManager;
  final IBiometricService biometricService;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.storeCredentials,
    required this.biometricLoginUseCase,
    required this.repository,
    required this.sessionManager,
    required this.biometricService,
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

        await _persistBiometricCredentials(email, password);

        final firstNameResult = await repository.getUserFirstName();
        final existingFirstName = firstNameResult.fold((_) => null, (v) => v);

        if (existingFirstName == null || existingFirstName.isEmpty) {
          final firstName = _extractFirstNameFromEmail(email);

          final loginUser = RegisterUserEntity(
            firstName: firstName,
            lastName: '',
            email: email,
            phone: '',
            password: password,
            biometricEnabled: false,
          );

          await repository.storeUserData(loginUser);
        }

        final enabled = (await repository.isBiometricEnabled())
            .fold((_) => false, (v) => v);

        final type =
            (await repository.getBiometricType()).fold((_) => null, (v) => v);

        emit(AuthLoginSuccess(
          biometricEnabled: enabled,
          biometricType: type,
        ));
      },
    );
  }

  Future<void> register(UserModel userModel) async {
    emit(AuthLoading());

    try {
      final user = RegisterUserEntity(
        firstName: userModel.firstName,
        lastName: userModel.lastName,
        email: userModel.email,
        phone: userModel.phone,
        password: userModel.password,
        biometricEnabled: userModel.biometricEnabled,
      );

      final result = await registerUseCase(user);

      await result.fold(
        (failure) async => emit(AuthError(_mapFailureToMessage(failure))),
        (session) async {
          await storeCredentials(
            userId: session.userId,
            token: session.token,
          );

          await repository.storeUserData(user);

          await _persistBiometricCredentials(user.email, user.password);

          await _autoEnableBiometricIfAvailable(
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

        final storedEmail =
            (await repository.getStoredEmail()).fold((_) => null, (v) => v);

        final storedPassword =
            (await repository.getStoredPassword()).fold((_) => null, (v) => v);

        if (storedEmail != null && storedPassword != null) {
          await _persistBiometricCredentials(storedEmail, storedPassword);
        }

        final enabled = (await repository.isBiometricEnabled())
            .fold((_) => false, (v) => v);
        final type =
            (await repository.getBiometricType()).fold((_) => null, (v) => v);

        emit(AuthLoginSuccess(
          biometricEnabled: enabled,
          biometricType: type,
        ));
      },
    );
  }

  String _extractFirstNameFromEmail(String email) {
    final username = email.split('@').first;
    return username.isNotEmpty
        ? username[0].toUpperCase() + username.substring(1)
        : 'User';
  }

  Future<void> _autoEnableBiometricIfAvailable({
    required String email,
    required String password,
  }) async {
    final available =
        (await biometricService.isAvailable()).fold((_) => false, (v) => v);
    final enrolled =
        (await biometricService.isEnrolled()).fold((_) => false, (v) => v);

    if (!available || !enrolled) return;

    final typesResult = await biometricService.getAvailableBiometrics();
    final typeString = typesResult.fold(
      (_) => 'none',
      (types) {
        if (types.contains(AvailableBiometricType.face)) return 'face';
        if (types.contains(AvailableBiometricType.fingerprint))
          return 'fingerprint';
        return 'none';
      },
    );

    if (typeString != 'none') {
      await repository.storeBiometricSettings(
        email: email,
        password: password,
        biometricType: typeString,
      );
    }
  }

  Future<void> _persistBiometricCredentials(
      String email, String password) async {
    if (email.isEmpty || password.isEmpty) return;

    await repository.storeCredentialsForBiometric(
      email: email,
      password: password,
    );

    await repository.storeUserEmail(email);
  }

  String _mapFailureToMessage(AuthFailure failure) {
    if (failure is UserNotFoundFailure) {
      return AppStrings.authNoAccountFound;
    } else if (failure is InvalidCredentialsFailure) {
      return AppStrings.authInvalidCredentials;
    } else if (failure is EmailAlreadyExistsFailure) {
      return AppStrings.authEmailExists;
    } else if (failure is WeakPasswordFailure) {
      return failure.message ?? AppStrings.authWeakPassword;
    } else if (failure is InvalidEmailFailure) {
      return failure.message ?? AppStrings.authInvalidEmail;
    } else if (failure is AuthNetworkFailure) {
      return AppStrings.authNetworkError;
    } else if (failure is TooManyRequestsFailure) {
      return AppStrings.authTooManyRequests;
    } else if (failure is AccountDisabledFailure) {
      return AppStrings.authAccountDisabled;
    }
    return failure.message;
  }
}
