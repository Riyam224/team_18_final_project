// Imports Dio HTTP client for making network requests
import 'package:dio/dio.dart';
// Imports Retrofit annotations for declarative REST API definition
import 'package:retrofit/retrofit.dart';
// Imports API endpoint constants
import 'package:team_18_final_project/core/networking/endpoints.dart';
// Imports data models for deserializing API responses
import 'package:team_18_final_project/features/home/data/models/global_data_model.dart';
import 'package:team_18_final_project/features/home/data/models/top_gainer_model.dart';
import 'package:team_18_final_project/features/home/data/models/trending_coin_model.dart';

// Links to the generated file containing the implementation
part 'home_api_service.g.dart';

/// API service for fetching home screen data from CoinGecko API
/// Uses Retrofit to generate HTTP client code at build time
/// Provides methods for global market data, trending coins, and top gainers
@RestApi()
abstract class HomeApiService {
  /// Factory constructor to create an instance of the generated _HomeApiService
  /// @param dio - Configured Dio client for making HTTP requests
  /// @param baseUrl - Optional base URL override (uses Dio's baseUrl by default)
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  /// Fetches global cryptocurrency market statistics
  /// GET request to /global endpoint
  /// @return GlobalDataModel containing market overview data (total market cap, volume, etc.)
  @GET(Endpoints.global)
  Future<GlobalDataModel> getGlobalData();

  /// Fetches currently trending cryptocurrencies on CoinGecko
  /// GET request to /search/trending endpoint
  /// @return TrendingCoinsModel containing list of trending coins based on search volume
  @GET(Endpoints.trendingCoinsList)
  Future<TrendingCoinsModel> getTrendingCoins();

  /// Fetches top gaining cryptocurrencies by 24h price change
  /// GET request to /coins/markets endpoint with specific parameters
  /// @return List of TopGainerModel sorted by market cap and filtered for top performers
  @GET(Endpoints.topGainers)
  Future<List<TopGainerModel>> getTopGainers();
}
