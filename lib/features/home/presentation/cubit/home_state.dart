import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MarketOverview marketOverview;
  final List<TrendingCoinEntity> trendingCoins;
  final List<TopGainerEntity> topGainers;
  final PortfolioBalance portfolioBalance;

  const HomeLoaded({
    required this.marketOverview,
    required this.trendingCoins,
    required this.topGainers,
    required this.portfolioBalance,
  });

  @override
  List<Object?> get props =>
      [marketOverview, trendingCoins, topGainers, portfolioBalance];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
