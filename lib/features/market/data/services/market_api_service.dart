import 'package:dio/dio.dart';
import 'package:team_18_final_project/core/networking/api_error_handler.dart'; 
import 'package:team_18_final_project/core/networking/endpoints.dart'; 

class MarketApiService {
  final Dio _dio;

  MarketApiService(this._dio);

  Future<Map<String, dynamic>> getCoinDetails(String coinId) async {
    try {
      final endpoint = Endpoints.coin(coinId);
      final response = await _dio.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ApiErrorHandler.handleError(e));
    }
  }

  Future<Map<String, dynamic>> getMarketChart(String coinId, String days) async {
    try {
      final endpoint = Endpoints.marketChart(coinId, days);
      final response = await _dio.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ApiErrorHandler.handleError(e));
    }
  }
}