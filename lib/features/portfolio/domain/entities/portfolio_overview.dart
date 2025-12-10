import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/portfolio_holding.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';

class PortfolioOverview extends Equatable {
  final List<PortfolioHolding> holdings;

  const PortfolioOverview({
    required this.holdings,
  });

  double get totalValue => holdings.fold(
        AppPortfolioConstants.zeroValue.toDouble(),
        (sum, holding) => sum + holding.valueUsd,
      );

  double get totalChangeUsd => holdings.fold(
        AppPortfolioConstants.zeroValue.toDouble(),
        (sum, holding) => sum + holding.changeUsd,
      );

  double get totalChangePercent {
    if (totalValue == AppPortfolioConstants.zeroValue) {
      return AppPortfolioConstants.zeroValue.toDouble();
    }
    final previousValue = totalValue - totalChangeUsd;
    if (previousValue == AppPortfolioConstants.zeroValue) {
      return AppPortfolioConstants.zeroValue.toDouble();
    }
    return (totalChangeUsd / previousValue) *
        AppPortfolioConstants.percentageMultiplier;
  }

  @override
  List<Object?> get props => [holdings];
}
