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

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
  await _setupHome();
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
