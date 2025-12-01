import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/core/networking/api_error_handler.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_remote_data_source.dart';
import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_overview.dart';
import 'package:team_18_final_project/features/portfolio/domain/repositories/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioRemoteDataSource remote;
  final PortfolioLocalDataSource local;
  PortfolioOverview? _cache;

  PortfolioRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<Either<Failure, PortfolioOverview>> fetchPortfolio() async {
    final seeds = local.getInitialHoldings();
    try {
      final prices = await remote.fetchPrices(seeds.map((e) => e.id).toList());

      final holdings = seeds.map((seed) {
        final priceModel = prices[seed.id];
        final price = priceModel?.usd ?? 0;
        final change = priceModel?.usd24hChange ?? 0;
        return PortfolioHolding(
          id: seed.id,
          name: seed.name,
          symbol: seed.symbol,
          amount: seed.amount,
          priceUsd: price,
          changePercent24h: change,
          icon: seed.icon,
          iconColor: seed.iconColor,
        );
      }).toList();

      final overview = PortfolioOverview(holdings: holdings);
      _cache = overview;
      return Right(overview);
    } catch (error) {
      final message = ApiErrorHandler.handleError(error);
      // Fallback to last known good data if available
      if (_cache != null) {
        return Right(_cache!);
      }
      return Left(ServerFailure(message: message));
    }
  }
}
