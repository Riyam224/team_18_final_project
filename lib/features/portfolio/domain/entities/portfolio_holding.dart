import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';

class PortfolioHolding extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final double amount;
  final double priceUsd;
  final double changePercent24h;

  const PortfolioHolding({
    required this.id,
    required this.name,
    required this.symbol,
    required this.amount,
    required this.priceUsd,
    required this.changePercent24h,
  });

  double get valueUsd => amount * priceUsd;

  double get changeUsd =>
      valueUsd * (changePercent24h / AppPortfolioConstants.percentageMultiplier);

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        amount,
        priceUsd,
        changePercent24h,
      ];
}
