import 'package:team_18_final_project/features/portfolio/data/datasources/portfolio_api_service.dart';
import 'package:team_18_final_project/features/portfolio/data/models/simple_price_model.dart';
import 'package:team_18_final_project/features/portfolio/data/models/market_chart_model.dart';

class PortfolioRemoteDataSource {
  final PortfolioApiService api;

  PortfolioRemoteDataSource({required this.api});

  Future<Map<String, SimplePriceModel>> fetchPrices(List<String> ids) async {
    final idsParam = ids.join(',');
    return api.getSimplePrice(ids: idsParam);
  }

  Future<MarketChartModel> fetchMarketChart(String coinId, int days) async {
    return api.getMarketChart(coinId: coinId, days: days);
  }
}
