import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:team_18_final_project/core/networking/dio_client.dart';
import 'package:team_18_final_project/core/security/implementations/app_lock_service_impl.dart';
import 'package:team_18_final_project/core/security/implementations/audit_log_service_impl.dart';
import 'package:team_18_final_project/core/security/implementations/blur_service_impl.dart';
import 'package:team_18_final_project/core/security/implementations/encryption_service_impl.dart';
import 'package:team_18_final_project/core/security/implementations/flutter_secure_storage_impl.dart';
import 'package:team_18_final_project/core/security/implementations/local_auth_biometric_impl.dart';
import 'package:team_18_final_project/core/security/implementations/root_detection_service_impl.dart';
import 'package:team_18_final_project/core/security/implementations/screenshot_prevention_service_impl.dart';
import 'package:team_18_final_project/core/security/implementations/session_manager_impl.dart';
import 'package:team_18_final_project/core/security/interfaces/i_app_lock_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_audit_log_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_biometric_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_blur_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_encryption_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_root_detection_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_screenshot_prevention_service.dart';
import 'package:team_18_final_project/core/security/interfaces/i_secure_storage.dart';
import 'package:team_18_final_project/core/security/interfaces/i_session_manager.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_local_datasource_impl.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:team_18_final_project/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:team_18_final_project/features/auth/data/datasources/firebase_user_service.dart';
import 'package:team_18_final_project/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/biometric_login_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/register_user_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/store_biometric_settings_usecase.dart';
import 'package:team_18_final_project/features/auth/domain/usecases/store_user_credentials_usecase.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_setup_cubit/biometric_setup_cubit.dart';
import 'package:team_18_final_project/features/auth/presentation/cubits/biometric_verify_cubit/biometric_verify_cubit.dart';
import 'package:team_18_final_project/features/home/data/data_sources/home_api_service.dart';
import 'package:team_18_final_project/features/home/data/repositories/home_repository_impl.dart';
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_market_overview_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_portfolio_balance_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_trending_coins_usecase.dart';
import 'package:team_18_final_project/features/home/presentation/cubit/home_cubit.dart';
import 'package:team_18_final_project/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:team_18_final_project/features/transactions/data/datasources/encrypted_transaction_data_source.dart';
import 'package:team_18_final_project/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:team_18_final_project/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:team_18_final_project/features/transactions/domain/usecases/add_transaction_usecase.dart';
import 'package:team_18_final_project/features/transactions/domain/usecases/clear_transactions_usecase.dart';
import 'package:team_18_final_project/features/transactions/domain/usecases/get_transactions_usecase.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
  await _setupSecurity();
  await _setupAuth();
  await _setupHome();
  await _setupTransactions();
}

Future<void> _setupCore() async {
  // Dio
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
}

Future<void> _setupSecurity() async {
  // Core Security Services (Clean Architecture)

  // 1. Secure Storage (Foundation - must be first)
  sl.registerLazySingleton<ISecureStorage>(
    () => FlutterSecureStorageImpl(),
  );

  // 2. Encryption Service
  sl.registerLazySingleton<IEncryptionService>(
    () => EncryptionServiceImpl(secureStorage: sl<ISecureStorage>()),
  );

  // 2. Biometric Service
  sl.registerLazySingleton<IBiometricService>(
    () => LocalAuthBiometricImpl(),
  );

  // 3. Session Manager
  sl.registerLazySingleton<ISessionManager>(
    () => SessionManagerImpl(
      secureStorage: sl<ISecureStorage>(),
      encryptionService: sl<IEncryptionService>(),
    ),
  );

  // 4. App Lock Service
  sl.registerLazySingleton<IAppLockService>(
    () => AppLockServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );

  // 5. Audit Log Service
  sl.registerLazySingleton<IAuditLogService>(
    () => AuditLogServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );

  // 6. Screenshot Prevention Service
  sl.registerLazySingleton<IScreenshotPreventionService>(
    () => ScreenshotPreventionServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );

  // 7. Root Detection Service
  sl.registerLazySingleton<IRootDetectionService>(
    () => RootDetectionServiceImpl(),
  );

  // 8. Blur Service
  sl.registerLazySingleton<IBlurService>(
    () => BlurServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );
}

Future<void> _setupAuth() async {
  // Data Sources (Clean Architecture)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl<ISecureStorage>(),
      encryptionService: sl<IEncryptionService>(),
    ),
  );

  // Legacy services (for backward compatibility - will be removed)
  sl.registerLazySingleton<FirebaseUserService>(
    () => FirebaseUserService(
      secureStorage: sl<ISecureStorage>(),
    ),
  );

  // Repository (Clean Architecture)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => StoreUserCredentialsUseCase(sl()));
  sl.registerLazySingleton(() => StoreBiometricSettingsUseCase(sl()));
  sl.registerLazySingleton(() => BiometricLoginUseCase(sl(), sl<IBiometricService>()));

  // Cubits
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      storeCredentials: sl(),
      biometricLoginUseCase: sl(),
      repository: sl(),
      sessionManager: sl<ISessionManager>(),
    ),
  );

  sl.registerFactory(
    () => BiometricSetupCubit(
      storeSettings: sl(),
      secureStorage: sl<ISecureStorage>(),
    ),
  );

  sl.registerFactory(
    () => BiometricVerifyCubit(
      biometricLoginUseCase: sl(),
      storeCredentials: sl(),
      repository: sl(),
      appLockService: sl<IAppLockService>(),
      sessionManager: sl<ISessionManager>(),
    ),
  );

  sl.registerFactory(() => ProfileCubit(sl()));
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

Future<void> _setupTransactions() async {
  sl.registerLazySingleton<EncryptedTransactionDataSource>(
    () => EncryptedTransactionDataSource(
      secureStorage: sl<ISecureStorage>(),
      encryptionService: sl<IEncryptionService>(),
    ),
  );

  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => AddTransactionUseCase(sl()));
  sl.registerLazySingleton(() => ClearTransactionsUseCase(sl()));
}
