import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';

abstract class HomeRepository {
  Future<Either<Failure, MarketOverview>> getMarketOverview();
  Future<Either<Failure, List<TrendingCoinEntity>>> getTrendingCoins();
  Future<Either<Failure, List<TopGainerEntity>>> getTopGainers();
  Future<Either<Failure, PortfolioBalance>> getPortfolioBalance();
}
