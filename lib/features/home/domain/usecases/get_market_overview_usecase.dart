import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

class GetMarketOverviewUseCase {
  final HomeRepository repository;

  GetMarketOverviewUseCase(this.repository);

  Future<Either<Failure, MarketOverview>> call() async {
    return await repository.getMarketOverview();
  }
}
