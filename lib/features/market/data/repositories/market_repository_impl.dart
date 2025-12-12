import 'package:dartz/dartz.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/core/networking/api_error_handler.dart';
import 'package:team_18_final_project/features/market/data/data_sources/market_api_service.dart';
import 'package:team_18_final_project/features/market/domain/entities/coin_details.dart';
import 'package:team_18_final_project/features/market/domain/entities/market_coin.dart';
import 'package:team_18_final_project/features/market/domain/entities/search_coin.dart';
import 'package:team_18_final_project/features/market/domain/repositories/market_repository.dart';

/// Implementation of MarketRepository using MarketApiService
/// Handles API calls, error handling, and data transformation from models to entities
class MarketRepositoryImpl implements MarketRepository {
  final MarketApiService _apiService;

  /// Cache for market coins by page to reduce API calls
  final Map<int, List<MarketCoinEntity>> _marketCoinsCache = {};
  final Map<int, DateTime> _cacheTimestamps = {};
  DateTime? _lastRequestTime;

  /// Cache duration for market data (5 minutes to reduce API calls)
  static const _cacheDuration = Duration(minutes: 5);

  /// Debounce duration to prevent rapid successive API calls (500ms)
  static const _debounceDuration = Duration(milliseconds: 500);

  MarketRepositoryImpl(this._apiService);

  /// Applies debouncing to prevent rapid successive API requests
  Future<void> _applyRequestDebounce() async {
    if (_lastRequestTime == null) {
      _lastRequestTime = DateTime.now();
      return;
    }

    final elapsed = DateTime.now().difference(_lastRequestTime!);
    if (elapsed < _debounceDuration) {
      await Future.delayed(_debounceDuration - elapsed);
    }

    _lastRequestTime = DateTime.now();
  }

  /// Checks if cached data is still valid
  bool _isCacheValid(int page) {
    final timestamp = _cacheTimestamps[page];
    if (timestamp == null) return false;

    final now = DateTime.now();
    return now.difference(timestamp) < _cacheDuration;
  }

  @override
  Future<Either<Failure, List<MarketCoinEntity>>> getMarketCoins({
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      // Return cached data if valid
      if (_isCacheValid(page) && _marketCoinsCache.containsKey(page)) {
        return Right(_marketCoinsCache[page]!);
      }

      // Apply debouncing
      await _applyRequestDebounce();

      // Fetch from API
      final response = await _apiService.getMarketCoins(
        page: page,
        perPage: perPage,
      );

      // Convert models to entities
      final entities = response.map((model) => model.toEntity()).toList();

      // Cache the result
      _marketCoinsCache[page] = entities;
      _cacheTimestamps[page] = DateTime.now();

      return Right(entities);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<SearchCoinEntity>>> searchCoins(
      String query) async {
    try {
      // Don't search for empty queries
      if (query.trim().isEmpty) {
        return const Right([]);
      }

      // Apply debouncing
      await _applyRequestDebounce();

      // Fetch from API
      final response = await _apiService.searchCoins(query: query);

      // Convert models to entities
      final entities = response.coins.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, CoinDetailsEntity>> getCoinDetails(
      String coinId) async {
    try {
      // Apply debouncing
      await _applyRequestDebounce();

      // Fetch from API
      final response = await _apiService.getCoinDetails(id: coinId);

      // Convert model to entity
      final entity = response.toEntity();

      return Right(entity);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<MarketCoinEntity>>> getMarketCoinsByIds(
      List<String> coinIds) async {
    try {
      // Return empty list if no IDs provided
      if (coinIds.isEmpty) {
        return const Right([]);
      }

      // Apply debouncing
      await _applyRequestDebounce();

      // Convert list of IDs to comma-separated string
      final idsString = coinIds.join(',');

      // Fetch from API
      final response = await _apiService.getMarketCoinsByIds(ids: idsString);

      // Convert models to entities
      final entities = response.map((model) => model.toEntity()).toList();

      return Right(entities);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  /// Clears all cached market data
  void clearCache() {
    _marketCoinsCache.clear();
    _cacheTimestamps.clear();
  }

  /// Clears cache for a specific page
  void clearPageCache(int page) {
    _marketCoinsCache.remove(page);
    _cacheTimestamps.remove(page);
  }
}
