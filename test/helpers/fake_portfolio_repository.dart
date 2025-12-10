import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'test_portfolio_data.dart';

/// Simple fake repository for tests.
class FakePortfolioRepository implements PortfolioRepository {
  FakePortfolioRepository({
    Either<Failure, PortfolioOverview>? initialResponse,
  }) : _response = initialResponse ?? Right(TestPortfolioData.overview());

  Either<Failure, PortfolioOverview> _response;
  int callCount = 0;
  int? lastDays;

  void setResponse(Either<Failure, PortfolioOverview> response) {
    _response = response;
  }

  @override
  Future<Either<Failure, PortfolioOverview>> fetchPortfolio({int? days}) async {
    callCount++;
    lastDays = days;
    return _response;
  }
}
