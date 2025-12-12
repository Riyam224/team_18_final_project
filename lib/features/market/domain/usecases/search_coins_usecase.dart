import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/market/domain/entities/search_coin.dart';
import 'package:team_18_final_project/features/market/domain/repositories/market_repository.dart';

/// Use case for searching cryptocurrencies by keyword
/// Implements the Single Responsibility Principle - one use case, one action
/// Acts as an intermediary between the presentation layer (Cubit) and the repository
/// Encapsulates business logic for searching coins
class SearchCoinsUseCase {
  /// Repository instance for accessing market search data
  final MarketRepository repository;

  /// Constructor requiring the repository dependency
  SearchCoinsUseCase(this.repository);

  /// Executes the use case to search for coins by keyword
  /// @param query - Search keyword (coin name, symbol, or id)
  /// Call operator allows using the class instance as a function
  /// Returns `Either<Failure, List<SearchCoinEntity>>` for functional error handling
  Future<Either<Failure, List<SearchCoinEntity>>> call(String query) async {
    return await repository.searchCoins(query);
  }
}
