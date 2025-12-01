import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:team_18_final_project/core/networking/dio_client.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_api_service.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_remote_data_source.dart';
import 'package:team_18_final_project/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:team_18_final_project/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  await _setupCore();
}

Future<void> _setupCore() async {
  // Networking
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());
  sl.registerLazySingleton<PortfolioApiService>(
    () => PortfolioApiService(sl<Dio>()),
  );
  sl.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSource(),
  );

  // Data sources
  sl.registerLazySingleton<PortfolioRemoteDataSource>(
    () => PortfolioRemoteDataSource(api: sl()),
  );

  // Repositories
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(
      remote: sl(),
      local: sl(),
    ),
  );

  // Use cases
  sl.registerFactory<GetPortfolioOverviewUseCase>(
    () => GetPortfolioOverviewUseCase(repository: sl()),
  );

  // Cubits
  sl.registerFactory<PortfolioCubit>(
    () => PortfolioCubit(getPortfolioOverview: sl()),
  );
}
