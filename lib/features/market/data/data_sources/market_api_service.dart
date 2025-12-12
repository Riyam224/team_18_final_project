import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:team_18_final_project/core/constants/api_constants.dart';
import 'package:team_18_final_project/features/market/data/models/coin_details_model.dart';
import 'package:team_18_final_project/features/market/data/models/market_coin_model.dart';
import 'package:team_18_final_project/features/market/data/models/search_coin_model.dart';

part 'market_api_service.g.dart';

/// API service for fetching market data from CoinGecko API
/// Uses Retrofit to generate HTTP client code at build time
/// Provides methods for market coin list with pagination and search functionality
@RestApi()
abstract class MarketApiService {
  /// Factory constructor to create an instance of the generated _MarketApiService
  /// @param dio - Configured Dio client for making HTTP requests
  /// @param baseUrl - Optional base URL override (uses Dio's baseUrl by default)
  factory MarketApiService(Dio dio, {String baseUrl}) = _MarketApiService;

  /// Fetches cryptocurrency market list with pagination
  /// GET request to /coins/markets endpoint
  /// @param vsCurrency - Target currency for market data (default: 'usd')
  /// @param order - Sort order for results (default: 'market_cap_desc')
  /// @param perPage - Number of results per page (default: 50)
  /// @param page - Page number (starts at 1)
  /// @param sparkline - Include sparkline 7d data (default: false)
  /// @param priceChangePercentage - Include price change percentage for specific time periods
  /// @return List of MarketCoinModel sorted by specified order
  @GET('/coins/markets')
  Future<List<MarketCoinModel>> getMarketCoins({
    @Query(ApiQueryParams.vsCurrency) String vsCurrency = ApiDefaults.currency,
    @Query(ApiQueryParams.order) String order = ApiDefaults.orderByMarketCap,
    @Query(ApiQueryParams.perPage) int perPage = ApiDefaults.defaultPerPage,
    @Query(ApiQueryParams.page) int page = 1,
    @Query('sparkline') bool sparkline = false,
    @Query('price_change_percentage') String? priceChangePercentage,
  });

  /// Searches for cryptocurrencies by keyword
  /// GET request to /search endpoint
  /// @param query - Search keyword (coin name, symbol, or id)
  /// @return SearchResponseModel containing list of matching coins
  @GET('/search')
  Future<SearchResponseModel> searchCoins({
    @Query('query') required String query,
  });

  /// Fetches detailed information about a specific cryptocurrency
  /// GET request to /coins/{id} endpoint
  /// @param id - Coin identifier (e.g., 'bitcoin', 'ethereum')
  /// @return CoinDetailsModel with comprehensive coin information
  @GET('/coins/{id}')
  Future<CoinDetailsModel> getCoinDetails({
    @Path('id') required String id,
    @Query('localization') bool localization = false,
    @Query('tickers') bool tickers = false,
    @Query('market_data') bool marketData = true,
    @Query('community_data') bool communityData = false,
    @Query('developer_data') bool developerData = false,
    @Query('sparkline') bool sparkline = false,
  });

  /// Fetches cryptocurrency market data for specific coins by their IDs
  /// GET request to /coins/markets endpoint with IDs filter
  /// @param vsCurrency - Target currency for market data (default: 'usd')
  /// @param ids - Comma-separated list of coin IDs (e.g., 'bitcoin,ethereum')
  /// @param order - Sort order for results (default: 'market_cap_desc')
  /// @param sparkline - Include sparkline 7d data (default: false)
  /// @return List of MarketCoinModel for the specified coins
  @GET('/coins/markets')
  Future<List<MarketCoinModel>> getMarketCoinsByIds({
    @Query(ApiQueryParams.vsCurrency) String vsCurrency = ApiDefaults.currency,
    @Query('ids') required String ids,
    @Query(ApiQueryParams.order) String order = ApiDefaults.orderByMarketCap,
    @Query('sparkline') bool sparkline = false,
  });
}
