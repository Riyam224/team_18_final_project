import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';

abstract class PortfolioRepository {
  /// Fetches portfolio data
  /// [days] - Number of days to look back for historical data (null = current day)
  Future<Either<Failure, PortfolioOverview>> fetchPortfolio({int? days});
}
