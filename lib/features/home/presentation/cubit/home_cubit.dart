import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_market_overview_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_portfolio_balance_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_trending_coins_usecase.dart';
import 'home_state.dart';

/// Manages home screen state by coordinating multiple use cases
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

  /// Loads all home screen data by executing use cases in parallel
  Future<void> loadHomeData() async {
    emit(HomeLoading());

    try {
      final results = await Future.wait([
        getMarketOverviewUseCase(),
        getTrendingCoinsUseCase(),
        getTopGainersUseCase(),
        getPortfolioBalanceUseCase(),
      ]);

      if (isClosed) return;

      final marketOverviewResult = results[0] as dynamic;
      final trendingCoinsResult = results[1] as dynamic;
      final topGainersResult = results[2] as dynamic;
      final portfolioBalanceResult = results[3] as dynamic;

      // Extract failures or values from each result
      final marketOverviewFailure = marketOverviewResult.fold((f) => f, (_) => null);
      if (marketOverviewFailure != null) {
        if (!isClosed) emit(HomeError(message: marketOverviewFailure.message));
        return;
      }

      final trendingCoinsFailure = trendingCoinsResult.fold((f) => f, (_) => null);
      if (trendingCoinsFailure != null) {
        if (!isClosed) emit(HomeError(message: trendingCoinsFailure.message));
        return;
      }

      final topGainersFailure = topGainersResult.fold((f) => f, (_) => null);
      if (topGainersFailure != null) {
        if (!isClosed) emit(HomeError(message: topGainersFailure.message));
        return;
      }

      final portfolioBalanceFailure = portfolioBalanceResult.fold((f) => f, (_) => null);
      if (portfolioBalanceFailure != null) {
        if (!isClosed) emit(HomeError(message: portfolioBalanceFailure.message));
        return;
      }

      // All succeeded - extract the actual data
      final marketOverview = marketOverviewResult.fold((_) => null, (data) => data);
      final trendingCoins = trendingCoinsResult.fold((_) => null, (data) => data);
      final topGainers = topGainersResult.fold((_) => null, (data) => data);
      final portfolioBalance = portfolioBalanceResult.fold((_) => null, (data) => data);

      if (!isClosed) {
        emit(HomeLoaded(
          marketOverview: marketOverview!,
          trendingCoins: trendingCoins!,
          topGainers: topGainers!,
          portfolioBalance: portfolioBalance!,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(HomeError(message: 'An unexpected error occurred: $e'));
      }
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
