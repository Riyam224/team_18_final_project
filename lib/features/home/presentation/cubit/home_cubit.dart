import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_market_overview_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_portfolio_balance_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_trending_coins_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetMarketOverviewUseCase getMarketOverviewUseCase;
  final GetTrendingCoinsUseCase getTrendingCoinsUseCase;
  final GetTopGainersUseCase getTopGainersUseCase;
  final GetPortfolioBalanceUseCase getPortfolioBalanceUseCase;

  HomeCubit({
    required this.getMarketOverviewUseCase,
    required this.getTrendingCoinsUseCase,
    required this.getTopGainersUseCase,
    required this.getPortfolioBalanceUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    // Execute API calls in parallel for better performance
    // marketOverview and portfolioBalance share cached global data
    // trendingCoins and topGainers are independent calls
    final results = await Future.wait([
      getMarketOverviewUseCase(),
      getTrendingCoinsUseCase(),
      getTopGainersUseCase(),
      getPortfolioBalanceUseCase(),
    ]);

    // Extract and properly type the results
    final marketOverviewResult = results[0] as dynamic;
    final trendingCoinsResult = results[1] as dynamic;
    final topGainersResult = results[2] as dynamic;
    final portfolioBalanceResult = results[3] as dynamic;

    // Check if any failed
    marketOverviewResult.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (marketOverview) {
        trendingCoinsResult.fold(
          (failure) => emit(HomeError(message: failure.message)),
          (trendingCoins) {
            topGainersResult.fold(
              (failure) => emit(HomeError(message: failure.message)),
              (topGainers) {
                portfolioBalanceResult.fold(
                  (failure) => emit(HomeError(message: failure.message)),
                  (portfolioBalance) {
                    emit(HomeLoaded(
                      marketOverview: marketOverview,
                      trendingCoins: trendingCoins,
                      topGainers: topGainers,
                      portfolioBalance: portfolioBalance,
                    ));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
