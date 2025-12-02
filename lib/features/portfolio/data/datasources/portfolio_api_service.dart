import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:team_18_final_project/core/networking/api_base_url.dart';
import 'package:team_18_final_project/features/portfolio/data/models/simple_price_model.dart';
import 'package:team_18_final_project/features/portfolio/data/models/market_chart_model.dart';

part 'portfolio_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class PortfolioApiService {
  factory PortfolioApiService(Dio dio, {String baseUrl}) = _PortfolioApiService;

  @GET('/simple/price')
  Future<Map<String, SimplePriceModel>> getSimplePrice({
    @Query('ids') required String ids,
    @Query('vs_currencies') String vsCurrencies = 'usd',
    @Query('include_24hr_change') bool include24hChange = true,
  });

  @GET('/coins/{id}/market_chart')
  Future<MarketChartModel> getMarketChart({
    @Path('id') required String coinId,
    @Query('vs_currency') String vsCurrency = 'usd',
    @Query('days') required int days,
  });
}
