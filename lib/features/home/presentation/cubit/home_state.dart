// Imports Equatable for value equality comparison in state management
import 'package:equatable/equatable.dart';
// Imports domain entities representing home screen data
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';

/// Abstract base class for all home screen states
/// Extends Equatable to enable state comparison for efficient UI rebuilds
/// Cubit emits different states to represent the current status of home data
abstract class HomeState extends Equatable {
  const HomeState();

  /// Empty props for base state (overridden by subclasses)
  @override
  List<Object?> get props => [];
}

/// Initial state when the home screen is first created
/// No data has been loaded yet
class HomeInitial extends HomeState {}

/// Loading state while fetching home screen data from APIs
/// UI should display loading indicators during this state
class HomeLoading extends HomeState {}

/// Success state containing all loaded home screen data
/// UI rebuilds to display the fetched data when this state is emitted
class HomeLoaded extends HomeState {
  /// Global market overview statistics (market cap, volume, BTC dominance)
  final MarketOverview marketOverview;

  /// List of currently trending cryptocurrencies
  final List<TrendingCoinEntity> trendingCoins;

  /// List of top gaining cryptocurrencies by 24h price change
  final List<TopGainerEntity> topGainers;

  /// User's portfolio balance and performance metrics
  final PortfolioBalance portfolioBalance;

  /// Constructor requiring all home screen data
  const HomeLoaded({
    required this.marketOverview,
    required this.trendingCoins,
    required this.topGainers,
    required this.portfolioBalance,
  });

  /// Equatable props for state comparison
  /// State is considered changed if any of these values differ
  @override
  List<Object?> get props =>
      [marketOverview, trendingCoins, topGainers, portfolioBalance];
}

/// Error state when data fetching fails
/// Contains error message to display to the user
class HomeError extends HomeState {
  /// Human-readable error message describing what went wrong
  final String message;

  const HomeError({required this.message});

  /// Equatable props - state changes if error message is different
  @override
  List<Object?> get props => [message];
}
