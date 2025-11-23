// Imports flutter_bloc for Cubit state management
import 'package:flutter_bloc/flutter_bloc.dart';
// Imports use cases for fetching home screen data
import 'package:team_18_final_project/features/home/domain/usecases/get_market_overview_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_portfolio_balance_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:team_18_final_project/features/home/domain/usecases/get_trending_coins_usecase.dart';
// Imports home state definitions
import 'home_state.dart';

/// Cubit managing state and business logic for the home screen
/// Extends Cubit from flutter_bloc for simplified state management (vs full Bloc)
/// Coordinates multiple use cases and emits appropriate states to the UI
class HomeCubit extends Cubit<HomeState> {
  /// Use case for fetching market overview data
  final GetMarketOverviewUseCase getMarketOverviewUseCase;

  /// Use case for fetching trending coins
  final GetTrendingCoinsUseCase getTrendingCoinsUseCase;

  /// Use case for fetching top gainers
  final GetTopGainersUseCase getTopGainersUseCase;

  /// Use case for fetching portfolio balance
  final GetPortfolioBalanceUseCase getPortfolioBalanceUseCase;

  /// Constructor requiring all use case dependencies
  /// Initializes with HomeInitial state
  HomeCubit({
    required this.getMarketOverviewUseCase,
    required this.getTrendingCoinsUseCase,
    required this.getTopGainersUseCase,
    required this.getPortfolioBalanceUseCase,
  }) : super(HomeInitial());

  /// Loads all home screen data by executing use cases
  /// Emits HomeLoading, then either HomeLoaded or HomeError based on results
  Future<void> loadHomeData() async {
    // Emit loading state to show progress indicators
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

    // Extract and properly type the results from Future.wait
    final marketOverviewResult = results[0] as dynamic;
    final trendingCoinsResult = results[1] as dynamic;
    final topGainersResult = results[2] as dynamic;
    final portfolioBalanceResult = results[3] as dynamic;

    // Check results using fold pattern for Either<Failure, Data>
    // If any request fails, emit error state immediately
    // If all succeed, emit loaded state with all data
    marketOverviewResult.fold(
      (failure) => emit(HomeError(message: failure.message)), // Handle market overview failure
      (marketOverview) {
        trendingCoinsResult.fold(
          (failure) => emit(HomeError(message: failure.message)), // Handle trending coins failure
          (trendingCoins) {
            topGainersResult.fold(
              (failure) => emit(HomeError(message: failure.message)), // Handle top gainers failure
              (topGainers) {
                portfolioBalanceResult.fold(
                  (failure) => emit(HomeError(message: failure.message)), // Handle portfolio failure
                  (portfolioBalance) {
                    // All requests succeeded - emit loaded state with all data
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

  /// Refreshes home screen data (typically triggered by pull-to-refresh)
  /// Delegates to loadHomeData to fetch fresh data from APIs
  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
}
