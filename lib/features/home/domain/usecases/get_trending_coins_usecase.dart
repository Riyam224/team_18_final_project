// Imports Either type for functional error handling
import 'package:dartz/dartz.dart';
// Imports Failure class for error representation
import 'package:team_18_final_project/core/error/failure.dart';
// Imports TrendingCoinEntity
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';
// Imports repository interface
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

/// Use case for fetching trending cryptocurrencies based on search volume and popularity
/// Implements the Single Responsibility Principle - one use case, one action
/// Acts as an intermediary between the presentation layer (Cubit) and the repository
/// Encapsulates business logic for retrieving trending coins data
class GetTrendingCoinsUseCase {
  /// Repository instance for accessing cryptocurrency trending data
  final HomeRepository repository;

  /// Constructor requiring the repository dependency
  GetTrendingCoinsUseCase(this.repository);

  /// Executes the use case to fetch list of trending cryptocurrencies
  /// Call operator allows using the class instance as a function
  /// Returns `Either<Failure, List<TrendingCoinEntity>>` for functional error handling
  Future<Either<Failure, List<TrendingCoinEntity>>> call() async {
    return await repository.getTrendingCoins();
  }
}
