import 'package:get_it/get_it.dart';
import 'package:team_18_final_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/store_biometric_settings_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/store_user_credentials_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/biometric_login_usecase.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
  await _setupAuth();
}

Future<void> _setupCore() async {}

Future<void> _setupAuth() async {
  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Usecases
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => StoreUserCredentialsUseCase(sl()));
  sl.registerLazySingleton(() => StoreBiometricSettingsUseCase(sl()));
  sl.registerLazySingleton(() => BiometricLoginUseCase(sl()));

  // Cubits
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        storeCredentials: sl(),
        biometricLoginUseCase: sl(),
        repository: sl(),
      ));
  sl.registerFactory(() => BiometricSetupCubit(sl()));
  sl.registerFactory(() => BiometricVerifyCubit(
        biometricLoginUseCase: sl(),
        storeCredentials: sl(),
        repository: sl(),
      ));
}
