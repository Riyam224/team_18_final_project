import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:team_18_final_project/core/constants/api_constants.dart';
import 'package:team_18_final_project/features/portfolio/data/models/simple_price_model.dart';
import 'package:team_18_final_project/features/portfolio/data/models/market_chart_model.dart';

part 'portfolio_api_service.g.dart';

@RestApi(baseUrl: ApiBaseUrl.coingecko)
abstract class PortfolioApiService {
  factory PortfolioApiService(Dio dio, {String baseUrl}) = _PortfolioApiService;

  @GET(ApiEndpoints.simplePrice)
  Future<Map<String, SimplePriceModel>> getSimplePrice({
    @Query(ApiQueryParams.ids) required String ids,
    @Query(ApiQueryParams.vsCurrencies) String vsCurrencies = ApiDefaults.currency,
    @Query(ApiQueryParams.include24hrChange) bool include24hChange = ApiDefaults.include24hrChange,
  });

  @GET(ApiEndpoints.marketChart)
  Future<MarketChartModel> getMarketChart({
    @Path(ApiPathParams.id) required String coinId,
    @Query(ApiQueryParams.vsCurrency) String vsCurrency = ApiDefaults.currency,
    @Query(ApiQueryParams.days) required int days,
  });
}
