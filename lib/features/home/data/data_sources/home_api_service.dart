import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:team_18_final_project/core/networking/endpoints.dart';
import 'package:team_18_final_project/features/home/data/models/global_data_model.dart';
import 'package:team_18_final_project/features/home/data/models/top_gainer_model.dart';
import 'package:team_18_final_project/features/home/data/models/trending_coin_model.dart';

part 'home_api_service.g.dart';

@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  @GET(Endpoints.global)
  Future<GlobalDataModel> getGlobalData();

  @GET(Endpoints.trendingCoinsList)
  Future<TrendingCoinsModel> getTrendingCoins();

  @GET(Endpoints.topGainers)
  Future<List<TopGainerModel>> getTopGainers();
}
