// Imports Either type for functional error handling
import 'package:dartz/dartz.dart';
// Imports Failure class for error representation
import 'package:team_18_final_project/core/error/failure.dart';
// Imports PortfolioBalance entity
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
// Imports repository interface
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

/// Use case for fetching user's portfolio balance and performance metrics
/// Implements the Single Responsibility Principle - one use case, one action
/// Acts as an intermediary between the presentation layer (Cubit) and the repository
/// Encapsulates business logic for retrieving portfolio data
class GetPortfolioBalanceUseCase {
  /// Repository instance for accessing portfolio data
  final HomeRepository repository;

  /// Constructor requiring the repository dependency
  GetPortfolioBalanceUseCase(this.repository);

  /// Executes the use case to fetch portfolio balance
  /// Call operator allows using the class instance as a function
  /// Returns `Either<Failure, PortfolioBalance>` for functional error handling
  Future<Either<Failure, PortfolioBalance>> call() async {
    return await repository.getPortfolioBalance();
  }
}
