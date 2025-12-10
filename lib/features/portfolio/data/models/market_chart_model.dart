import 'package:team_18_final_project/features/portfolio/presentation/portfolio_utils/app_portfolio_constants.dart';

class MarketChartModel {
  final List<List<num>> prices;
  final List<List<num>> marketCaps;
  final List<List<num>> totalVolumes;

  const MarketChartModel({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });

  factory MarketChartModel.fromJson(Map<String, dynamic> json) {
    List<List<num>> safeParse(dynamic data) {
      if (data is! List) return [];

      return data.whereType<List>().map((list) {
        final cleaned = list.whereType<num>().toList();

        if (cleaned.length < AppPortfolioConstants.minArrayLength) {
          return [
            AppPortfolioConstants.zeroValue,
            AppPortfolioConstants.zeroValue
          ];
        }

        return cleaned;
      }).toList();
    }

    return MarketChartModel(
      prices: safeParse(json['prices']),
      marketCaps: safeParse(json['market_caps']),
      totalVolumes: safeParse(json['total_volumes']),
    );
  }
}
