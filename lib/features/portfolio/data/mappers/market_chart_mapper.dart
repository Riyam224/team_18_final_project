import 'package:team_18_final_project/features/portfolio/data/models/market_chart_model.dart';
import 'package:team_18_final_project/features/portfolio/domain/entities/market_chart.dart';

class MarketChartMapper {
  static MarketChart toEntity(MarketChartModel model) {
    return MarketChart(
      prices: model.prices,
      marketCaps: model.marketCaps,
      totalVolumes: model.totalVolumes,
    );
  }

  static MarketChartModel toModel(MarketChart entity) {
    return MarketChartModel(
      prices: entity.prices,
      marketCaps: entity.marketCaps,
      totalVolumes: entity.totalVolumes,
    );
  }
}
