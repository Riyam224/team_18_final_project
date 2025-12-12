import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/market/domain/entities/market_coin.dart';
import 'package:team_18_final_project/features/market/domain/repositories/market_repository.dart';

/// Use case for fetching market coins with pagination
/// Implements the Single Responsibility Principle - one use case, one action
/// Acts as an intermediary between the presentation layer (Cubit) and the repository
/// Encapsulates business logic for retrieving paginated market coin data
class GetMarketCoinsUseCase {
  /// Repository instance for accessing market data
  final MarketRepository repository;

  /// Constructor requiring the repository dependency
  GetMarketCoinsUseCase(this.repository);

  /// Executes the use case to fetch list of market coins with pagination
  /// @param page - Page number (starts at 1)
  /// @param perPage - Number of results per page (default: 50)
  /// Call operator allows using the class instance as a function
  /// Returns `Either<Failure, List<MarketCoinEntity>>` for functional error handling
  Future<Either<Failure, List<MarketCoinEntity>>> call({
    int page = 1,
    int perPage = 50,
  }) async {
    return await repository.getMarketCoins(
      page: page,
      perPage: perPage,
    );
  }
}
