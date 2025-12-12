import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/market/domain/entities/coin_details.dart';
import 'package:team_18_final_project/features/market/domain/repositories/market_repository.dart';

/// Use case for fetching detailed information about a specific cryptocurrency
/// Encapsulates business logic for retrieving coin details
class GetCoinDetailsUseCase {
  final MarketRepository _repository;

  GetCoinDetailsUseCase(this._repository);

  /// Executes the use case to fetch coin details
  /// @param coinId - Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  /// @return Either containing Failure (left) or CoinDetailsEntity (right)
  Future<Either<Failure, CoinDetailsEntity>> call(String coinId) async {
    return await _repository.getCoinDetails(coinId);
  }
}
