import 'package:team_18_final_project/features/market/data/models/coin_details_model.dart';
import 'package:team_18_final_project/features/market/data/services/market_api_service.dart';
import 'package:team_18_final_project/features/market/data/models/coin_chart_model.dart';

class MarketRepository {
  final MarketApiService _apiService;

  MarketRepository(this._apiService);

  Future<CoinDetailsModel> fetchCoinDetails(String coinId) async {
    final rawData = await _apiService.getCoinDetails(coinId);
    return CoinDetailsModel.fromJson(rawData); 
  }

  Future<CoinChartModel> fetchMarketChart(String coinId, String days) async {
    final rawData = await _apiService.getMarketChart(coinId, days);
    return CoinChartModel.fromJson(rawData);
  }
}