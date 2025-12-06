// Imports Either type for functional error handling (Right = success, Left = failure)
import 'package:dartz/dartz.dart';
// Imports base Failure class for error representation
import 'package:team_18_final_project/core/error/failure.dart';
// Imports domain entities representing business logic objects
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';

/// Abstract repository contract for home screen data operations
/// Follows the Repository Pattern to abstract data sources from business logic
/// Returns `Either<Failure, Data>` for functional error handling without throwing exceptions
abstract class HomeRepository {
  /// Fetches global market overview statistics
  /// Returns `Either` containing Failure (left) or MarketOverview entity (right)
  Future<Either<Failure, MarketOverview>> getMarketOverview();

  /// Fetches list of trending cryptocurrencies
  /// Returns `Either` containing Failure (left) or list of TrendingCoinEntity (right)
  Future<Either<Failure, List<TrendingCoinEntity>>> getTrendingCoins();

  /// Fetches list of top gaining cryptocurrencies by 24h price change
  /// Returns `Either` containing Failure (left) or list of TopGainerEntity (right)
  Future<Either<Failure, List<TopGainerEntity>>> getTopGainers();

  /// Fetches user's portfolio balance and performance
  /// Returns `Either` containing Failure (left) or PortfolioBalance entity (right)
  Future<Either<Failure, PortfolioBalance>> getPortfolioBalance();
}
