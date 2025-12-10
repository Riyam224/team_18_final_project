import 'package:flutter/foundation.dart';
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
  bool _isLoading = false;

  HomeCubit({
    required this.getMarketOverviewUseCase,
    required this.getTrendingCoinsUseCase,
    required this.getTopGainersUseCase,
    required this.getPortfolioBalanceUseCase,
  }) : super(HomeInitial()) {
    debugPrint('[HomeCubit] created');
  }

  Future<void> loadHomeData() async {
    if (_isLoading) {
      debugPrint('[HomeCubit] loadHomeData skipped - already loading');
      return;
    }
    _isLoading = true;
    debugPrint('[HomeCubit] loadHomeData start');
    emit(HomeLoading());

    try {
      final marketOverviewResult = await getMarketOverviewUseCase();
      if (isClosed) return;

      await Future.delayed(const Duration(milliseconds: 300));
      final trendingCoinsResult = await getTrendingCoinsUseCase();
      if (isClosed) return;

      await Future.delayed(const Duration(milliseconds: 300));
      final topGainersResult = await getTopGainersUseCase();
      if (isClosed) return;

      await Future.delayed(const Duration(milliseconds: 300));
      final portfolioBalanceResult = await getPortfolioBalanceUseCase();
      if (isClosed) return;

      final marketOverviewFailure =
          marketOverviewResult.fold((f) => f, (_) => null);
      if (marketOverviewFailure != null) {
        if (!isClosed) emit(HomeError(message: marketOverviewFailure.message));
        return;
      }

      final trendingCoinsFailure =
          trendingCoinsResult.fold((f) => f, (_) => null);
      if (trendingCoinsFailure != null) {
        if (!isClosed) emit(HomeError(message: trendingCoinsFailure.message));
        return;
      }

      final topGainersFailure = topGainersResult.fold((f) => f, (_) => null);
      if (topGainersFailure != null) {
        if (!isClosed) emit(HomeError(message: topGainersFailure.message));
        return;
      }

      final portfolioBalanceFailure =
          portfolioBalanceResult.fold((f) => f, (_) => null);
      if (portfolioBalanceFailure != null) {
        if (!isClosed)
          emit(HomeError(message: portfolioBalanceFailure.message));
        return;
      }

      final marketOverview =
          marketOverviewResult.fold((_) => null, (data) => data);
      final trendingCoins =
          trendingCoinsResult.fold((_) => null, (data) => data);
      final topGainers = topGainersResult.fold((_) => null, (data) => data);
      final portfolioBalance =
          portfolioBalanceResult.fold((_) => null, (data) => data);

      if (!isClosed) {
        emit(HomeLoaded(
          marketOverview: marketOverview!,
          trendingCoins: trendingCoins!,
          topGainers: topGainers!,
          portfolioBalance: portfolioBalance!,
        ));
      }
      debugPrint('[HomeCubit] loadHomeData success');
    } catch (e) {
      if (!isClosed) {
        emit(HomeError(message: 'An unexpected error occurred: $e'));
      }
      debugPrint('[HomeCubit] loadHomeData error: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
