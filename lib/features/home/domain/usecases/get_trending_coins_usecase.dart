import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

class GetTrendingCoinsUseCase {
  final HomeRepository repository;

  GetTrendingCoinsUseCase(this.repository);

  Future<Either<Failure, List<TrendingCoinEntity>>> call() async {
    return await repository.getTrendingCoins();
  }
}
