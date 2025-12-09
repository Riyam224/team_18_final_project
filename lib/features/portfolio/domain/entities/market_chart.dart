import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';

class MarketChart extends Equatable {
  final List<List<num>> prices;
  final List<List<num>> marketCaps;
  final List<List<num>> totalVolumes;

  const MarketChart({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });

  double? get averagePrice {
    if (prices.isEmpty) return null;
    final sum = prices.fold<double>(
      AppPortfolioConstants.zeroValue.toDouble(),
      (sum, entry) =>
          sum + entry[AppPortfolioConstants.priceDataIndex].toDouble(),
    );
    return sum / prices.length;
  }

  double? get latestPrice {
    if (prices.isEmpty) return null;
    return prices.last[AppPortfolioConstants.priceDataIndex].toDouble();
  }

  double? get earliestPrice {
    if (prices.isEmpty) return null;
    return prices.first[AppPortfolioConstants.priceDataIndex].toDouble();
  }

  double? get priceChangePercent {
    final latest = latestPrice;
    final earliest = earliestPrice;

    if (latest == null ||
        earliest == null ||
        earliest == AppPortfolioConstants.zeroValue) {
      return null;
    }
    return ((latest - earliest) / earliest) *
        AppPortfolioConstants.percentageMultiplier;
  }

  @override
  List<Object?> get props => [prices, marketCaps, totalVolumes];
}
