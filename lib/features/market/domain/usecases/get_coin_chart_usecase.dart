import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/market/domain/entities/chart_point.dart';
import 'package:team_18_final_project/features/market/domain/repositories/market_repository.dart';

class GetCoinChartUseCase {
  final MarketRepository _repository;

  GetCoinChartUseCase(this._repository);

  Future<Either<Failure, List<ChartPoint>>> call({
    required String coinId,
    required String days,
  }) {
    return _repository.getCoinChart(coinId: coinId, days: days);
  }
}
