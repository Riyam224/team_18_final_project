import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:team_18_final_project/core/networking/dio_client.dart';
import 'package:team_18_final_project/features/home/data/data_sources/home_api_service.dart';
import 'package:team_18_final_project/features/home/data/repositories/home_repository_impl.dart';
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_market_overview_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_portfolio_balance_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_trending_coins_usecase.dart';
import 'package:team_18_final_project/features/home/presentation/cubit/home_cubit.dart';
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
  await _setupHome();
  await _setupAuth();
}

Future<void> _setupCore() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
}

Future<void> _setupHome() async {
  // Data sources
  sl.registerLazySingleton<HomeApiService>(
    () => HomeApiService(sl<Dio>()),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeApiService>()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMarketOverviewUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetTrendingCoinsUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetTopGainersUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetPortfolioBalanceUseCase(sl<HomeRepository>()));

  // Cubit
  sl.registerFactory(
    () => HomeCubit(
      getMarketOverviewUseCase: sl<GetMarketOverviewUseCase>(),
      getTrendingCoinsUseCase: sl<GetTrendingCoinsUseCase>(),
      getTopGainersUseCase: sl<GetTopGainersUseCase>(),
      getPortfolioBalanceUseCase: sl<GetPortfolioBalanceUseCase>(),
    ),
  );
}

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
