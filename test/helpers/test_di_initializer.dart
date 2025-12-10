import 'package:team_18_final_project/core/di/di.dart' as di;
import 'package:team_18_final_project/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:team_18_final_project/features/portfolio/domain/usecases/get_portfolio_overview_usecase.dart';
import 'package:team_18_final_project/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'fake_portfolio_repository.dart';

/// Shared DI initializer for tests to keep setup consistent.
Future<void> setupTestDi({
  PortfolioRepository? portfolioRepository,
}) async {
  await di.sl.reset();

  di.sl.registerLazySingleton<PortfolioRepository>(
    () => portfolioRepository ?? FakePortfolioRepository(),
  );

  di.sl.registerFactory<GetPortfolioOverviewUseCase>(
    () => GetPortfolioOverviewUseCase(repository: di.sl()),
  );

  di.sl.registerFactory<PortfolioCubit>(
    () => PortfolioCubit(getPortfolioOverview: di.sl()),
  );
}
