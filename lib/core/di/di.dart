import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';

import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';
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
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_api_service.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_remote_data_source.dart';
import 'package:team_18_final_project/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:team_18_final_project/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';

final sl = GetIt.instance;

enum AppEnvironment { prod, test }

class SecurityOverrides {
  final ISecureStorage Function() secureStorage;
  final IEncryptionService Function(ISecureStorage secureStorage) encryption;
  final IBiometricService Function() biometric;
  final ISessionManager Function(
          ISecureStorage secureStorage, IEncryptionService encryptionService)
      sessionManager;
  final IAppLockService Function(ISecureStorage secureStorage) appLock;
  final IAuditLogService Function(ISecureStorage secureStorage) auditLog;
  final IScreenshotPreventionService Function(ISecureStorage secureStorage)
      screenshot;
  final IRootDetectionService Function() rootDetection;
  final IBlurService Function(ISecureStorage secureStorage) blur;

  const SecurityOverrides({
    required this.secureStorage,
    required this.encryption,
    required this.biometric,
    required this.sessionManager,
    required this.appLock,
    required this.auditLog,
    required this.screenshot,
    required this.rootDetection,
    required this.blur,
  });
}





Future<void> setupDependencies({
  AppEnvironment env = AppEnvironment.prod,
  SecurityOverrides? securityOverrides,
}) async {
  await _setupCore();
  await _setupSecurity(env, securityOverrides);
  await _setupAuth();
  await _setupHome();
  await _setupPortfolio();
  await _setupTransactions();
  await _settings();
}

Future<void> resetDependencies({
  AppEnvironment env = AppEnvironment.prod,
  SecurityOverrides? securityOverrides,
}) async {
  await sl.reset();
  await setupDependencies(
    env: env,
    securityOverrides: securityOverrides,
  );
}

Future<void> _setupCore() async {
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
}

Future<void> _setupSecurity(
  AppEnvironment env,
  SecurityOverrides? overrides,
) async {
  if (env == AppEnvironment.test) {
    if (overrides == null) {
      throw ArgumentError(
        'SecurityOverrides must be provided when using AppEnvironment.test',
      );
    }
    _registerSecurityTest(overrides);
    return;
  }
  _registerSecurityProd();
}

Future<void> _setupAuth() async {
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

  sl.registerLazySingleton<FirebaseUserService>(
    () => FirebaseUserService(
      secureStorage: sl<ISecureStorage>(),
      firebaseStorage: FirebaseStorage.instance,
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton(() => LoginUserUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUserUseCase(sl()));
  sl.registerLazySingleton(() => StoreUserCredentialsUseCase(sl()));
  sl.registerLazySingleton(() => StoreBiometricSettingsUseCase(sl()));
  sl.registerLazySingleton(
      () => BiometricLoginUseCase(sl(), sl<IBiometricService>()));

  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      storeCredentials: sl(),
      biometricLoginUseCase: sl(),
      repository: sl(),
      sessionManager: sl<ISessionManager>(),
      biometricService: sl<IBiometricService>(),
    ),
  );

  sl.registerFactory(
    () => BiometricSetupCubit(
      storeSettings: sl(),
      localDataSource: sl<AuthLocalDataSource>(),
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
  sl.registerLazySingleton<HomeApiService>(
    () => HomeApiService(sl<Dio>()),
  );

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(sl<HomeApiService>()),
  );

  sl.registerLazySingleton(
      () => GetMarketOverviewUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetTrendingCoinsUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetTopGainersUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(
      () => GetPortfolioBalanceUseCase(sl<HomeRepository>()));

  sl.registerFactory(
    () => HomeCubit(
      getMarketOverviewUseCase: sl<GetMarketOverviewUseCase>(),
      getTrendingCoinsUseCase: sl<GetTrendingCoinsUseCase>(),
      getTopGainersUseCase: sl<GetTopGainersUseCase>(),
      getPortfolioBalanceUseCase: sl<GetPortfolioBalanceUseCase>(),
    ),
  );
}

Future<void> _setupPortfolio() async {
  sl.registerLazySingleton<PortfolioApiService>(
    () => PortfolioApiService(sl<Dio>()),
  );

  sl.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSource(),
  );

  sl.registerLazySingleton<PortfolioRemoteDataSource>(
    () => PortfolioRemoteDataSource(api: sl<PortfolioApiService>()),
  );

  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(
      remote: sl<PortfolioRemoteDataSource>(),
      local: sl<PortfolioLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetPortfolioOverviewUseCase>(
    () => GetPortfolioOverviewUseCase(repository: sl<PortfolioRepository>()),
  );

  sl.registerFactory<PortfolioCubit>(
    () =>
        PortfolioCubit(getPortfolioOverview: sl<GetPortfolioOverviewUseCase>()),
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


Future<void> _settings() async {
  // settings
  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(),
);

  sl.registerLazySingleton<LanguageCubit>(
    () => LanguageCubit());

}


void _registerSecurityProd() {
  sl.registerLazySingleton<ISecureStorage>(() => FlutterSecureStorageImpl());
  sl.registerLazySingleton<IEncryptionService>(
    () => EncryptionServiceImpl(secureStorage: sl<ISecureStorage>()),
  );
  sl.registerLazySingleton<IBiometricService>(() => LocalAuthBiometricImpl());
  sl.registerLazySingleton<ISessionManager>(
    () => SessionManagerImpl(
      secureStorage: sl<ISecureStorage>(),
      encryptionService: sl<IEncryptionService>(),
    ),
  );
  sl.registerLazySingleton<IAppLockService>(
    () => AppLockServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );
  sl.registerLazySingleton<IAuditLogService>(
    () => AuditLogServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );
  sl.registerLazySingleton<IScreenshotPreventionService>(
    () => ScreenshotPreventionServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );
  sl.registerLazySingleton<IRootDetectionService>(
    () => RootDetectionServiceImpl(),
  );
  sl.registerLazySingleton<IBlurService>(
    () => BlurServiceImpl(
      secureStorage: sl<ISecureStorage>(),
    ),
  );
}

void _registerSecurityTest(SecurityOverrides overrides) {
  final secure = overrides.secureStorage();
  final encryption = overrides.encryption(secure);

  sl.registerLazySingleton<ISecureStorage>(() => secure);
  sl.registerLazySingleton<IEncryptionService>(() => encryption);
  sl.registerLazySingleton<IBiometricService>(overrides.biometric);
  sl.registerLazySingleton<ISessionManager>(
    () => overrides.sessionManager(secure, encryption),
  );
  sl.registerLazySingleton<IAppLockService>(
    () => overrides.appLock(secure),
  );
  sl.registerLazySingleton<IAuditLogService>(
    () => overrides.auditLog(secure),
  );
  sl.registerLazySingleton<IScreenshotPreventionService>(
    () => overrides.screenshot(secure),
  );
  sl.registerLazySingleton<IRootDetectionService>(
    overrides.rootDetection,
  );
  sl.registerLazySingleton<IBlurService>(
    () => overrides.blur(secure),
  );
}
