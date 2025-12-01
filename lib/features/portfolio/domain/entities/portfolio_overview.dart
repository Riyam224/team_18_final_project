import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';

class PortfolioOverview extends Equatable {
  final List<PortfolioHolding> holdings;

  const PortfolioOverview({
    required this.holdings,
  });

  double get totalValue =>
      holdings.fold(0, (sum, holding) => sum + holding.valueUsd);

  double get totalChangeUsd =>
      holdings.fold(0, (sum, holding) => sum + holding.changeUsd);

  double get totalChangePercent =>
      totalValue == 0 ? 0 : (totalChangeUsd / (totalValue - totalChangeUsd)) * 100;

  @override
  List<Object?> get props => [holdings];
}
