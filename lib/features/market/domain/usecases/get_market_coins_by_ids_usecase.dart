import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/market/domain/entities/market_coin.dart';
import 'package:team_18_final_project/features/market/domain/repositories/market_repository.dart';

/// Use case for fetching market data for specific coins by their IDs
/// Implements the Single Responsibility Principle - one use case, one action
/// Acts as an intermediary between the presentation layer (Cubit) and the repository
/// Encapsulates business logic for retrieving market data for specified coins
class GetMarketCoinsByIdsUseCase {
  /// Repository instance for accessing market data
  final MarketRepository repository;

  /// Constructor requiring the repository dependency
  GetMarketCoinsByIdsUseCase(this.repository);

  /// Executes the use case to fetch market data for specific coins
  /// @param coinIds - List of coin identifiers
  /// Call operator allows using the class instance as a function
  /// Returns `Either<Failure, List<MarketCoinEntity>>` for functional error handling
  Future<Either<Failure, List<MarketCoinEntity>>> call(
      List<String> coinIds) async {
    return await repository.getMarketCoinsByIds(coinIds);
  }
}
