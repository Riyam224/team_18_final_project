import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

class GetPortfolioBalanceUseCase {
  final HomeRepository repository;

  GetPortfolioBalanceUseCase(this.repository);

  Future<Either<Failure, PortfolioBalance>> call() async {
    return await repository.getPortfolioBalance();
  }
}
