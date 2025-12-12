import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/market/domain/entities/coin_details.dart';
import 'package:team_18_final_project/features/market/domain/entities/market_coin.dart';
import 'package:team_18_final_project/features/market/domain/entities/search_coin.dart';

/// Abstract repository contract for market data operations
/// Follows the Repository Pattern to abstract data sources from business logic
/// Returns `Either<Failure, Data>` for functional error handling without throwing exceptions
abstract class MarketRepository {
  /// Fetches list of cryptocurrencies in the market with pagination
  /// @param page - Page number (starts at 1)
  /// @param perPage - Number of results per page
  /// Returns `Either` containing Failure (left) or list of MarketCoinEntity (right)
  Future<Either<Failure, List<MarketCoinEntity>>> getMarketCoins({
    int page = 1,
    int perPage = 50,
  });

  /// Searches for cryptocurrencies by keyword
  /// @param query - Search keyword (coin name, symbol, or id)
  /// Returns `Either` containing Failure (left) or list of SearchCoinEntity (right)
  Future<Either<Failure, List<SearchCoinEntity>>> searchCoins(String query);

  /// Fetches detailed information about a specific cryptocurrency
  /// @param coinId - Coin identifier (e.g., 'bitcoin', 'ethereum')
  /// Returns `Either` containing Failure (left) or CoinDetailsEntity (right)
  Future<Either<Failure, CoinDetailsEntity>> getCoinDetails(String coinId);

  /// Fetches market data for specific coins by their IDs
  /// @param coinIds - List of coin identifiers
  /// Returns `Either` containing Failure (left) or list of MarketCoinEntity (right)
  Future<Either<Failure, List<MarketCoinEntity>>> getMarketCoinsByIds(
      List<String> coinIds);
}
