// Imports Either type for functional error handling
import 'package:dartz/dartz.dart';
// Imports Failure class for error representation
import 'package:team_18_final_project/core/error/failure.dart';
// Imports TopGainerEntity
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
// Imports repository interface
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

/// Use case for fetching top gaining cryptocurrencies by 24h price change
/// Implements the Single Responsibility Principle - one use case, one action
/// Acts as an intermediary between the presentation layer (Cubit) and the repository
/// Encapsulates business logic for retrieving top gainers data
class GetTopGainersUseCase {
  /// Repository instance for accessing cryptocurrency market data
  final HomeRepository repository;

  /// Constructor requiring the repository dependency
  GetTopGainersUseCase(this.repository);

  /// Executes the use case to fetch list of top gaining cryptocurrencies
  /// Call operator allows using the class instance as a function
  /// Returns `Either<Failure, List<TopGainerEntity>>` for functional error handling
  Future<Either<Failure, List<TopGainerEntity>>> call() async {
    return await repository.getTopGainers();
  }
}
