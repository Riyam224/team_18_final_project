// Imports Either type for functional error handling
import 'package:dartz/dartz.dart';
// Imports Failure class for error representation
import 'package:team_18_final_project/core/error/failure.dart';
// Imports MarketOverview entity
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
// Imports repository interface
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

/// Use case for fetching global cryptocurrency market overview statistics
/// Implements the Single Responsibility Principle - one use case, one action
/// Acts as an intermediary between the presentation layer (Cubit) and the repository
/// Encapsulates business logic for retrieving market overview data
class GetMarketOverviewUseCase {
  /// Repository instance for accessing market data
  final HomeRepository repository;

  /// Constructor requiring the repository dependency
  GetMarketOverviewUseCase(this.repository);

  /// Executes the use case to fetch market overview
  /// Call operator allows using the class instance as a function
  /// Returns `Either<Failure, MarketOverview>` for functional error handling
  Future<Either<Failure, MarketOverview>> call() async {
    return await repository.getMarketOverview();
  }
}
