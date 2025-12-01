import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/repositories/portfolio_repository.dart';

class GetPortfolioOverviewUseCase {
  final PortfolioRepository repository;

  GetPortfolioOverviewUseCase({required this.repository});

  Future<Either<Failure, PortfolioOverview>> call() {
    return repository.fetchPortfolio();
  }
}
