import 'package:dartz/dartz.dart';

import 'package:team_18_final_project/core/config/app_constants.dart';
import 'package:team_18_final_project/core/error/failure.dart';
import 'package:team_18_final_project/core/networking/api_error_handler.dart';
import 'package:team_18_final_project/features/home/data/data_sources/home_api_service.dart';
import 'package:team_18_final_project/features/home/domain/entities/market_overview.dart';
import 'package:team_18_final_project/features/home/domain/entities/portfolio_balance.dart';
import 'package:team_18_final_project/features/home/domain/entities/top_gainer.dart';
import 'package:team_18_final_project/features/home/domain/entities/trending_coin.dart';
import 'package:team_18_final_project/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService _apiService;

  HomeRepositoryImpl(this._apiService);

  // Cache for global data to avoid duplicate calls
  dynamic _cachedGlobalData;
  DateTime? _cacheTimestamp;

  /// Fetches global data with caching to prevent duplicate API calls
  Future<dynamic> _getGlobalDataCached() async {
    final now = DateTime.now();

    // Return cached data if it's still valid
    if (_cachedGlobalData != null &&
        _cacheTimestamp != null &&
        now.difference(_cacheTimestamp!) < AppConstants.marketDataCacheDuration) {
      return _cachedGlobalData;
    }

    // Fetch fresh data
    final response = await _apiService.getGlobalData();
    _cachedGlobalData = response.data;
    _cacheTimestamp = now;

    return _cachedGlobalData;
  }

  @override
  Future<Either<Failure, MarketOverview>> getMarketOverview() async {
    try {
      final data = await _getGlobalDataCached();

      // Format market cap
      final marketCapUsd = data.totalMarketCap['usd'] ?? 0;
      final marketCapFormatted = _formatCurrency(marketCapUsd);

      // Format volume
      final volumeUsd = data.totalVolume['usd'] ?? 0;
      final volumeFormatted = _formatCurrency(volumeUsd);

      // Get BTC dominance
      final btcDominance = data.marketCapPercentage['btc'] ?? 0;
      final btcDominanceFormatted = '${btcDominance.toStringAsFixed(1)}%';

      final marketOverview = MarketOverview(
        marketCap: marketCapFormatted,
        volume24h: volumeFormatted,
        btcDominance: btcDominanceFormatted,
        activeCoins: data.activeCryptocurrencies,
        marketCapChangePercentage: data.marketCapChangePercentage24hUsd,
      );

      return Right(marketOverview);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<TrendingCoinEntity>>> getTrendingCoins() async {
    try {
      final response = await _apiService.getTrendingCoins();

      final trendingCoins = response.coins.map((coinItem) {
        final coin = coinItem.item;

        // Handle price change percentage safely
        double priceChangeUsd = 0.0;
        if (coin.data.priceChangePercentage24h != null) {
          final usdValue = coin.data.priceChangePercentage24h!['usd'];
          if (usdValue != null) {
            priceChangeUsd =
                (usdValue is int) ? usdValue.toDouble() : usdValue as double;
          }
        }

        // Handle price - convert to string if it's a number
        String priceStr;
        if (coin.data.price is String) {
          priceStr = coin.data.price as String;
        } else if (coin.data.price is num) {
          priceStr = '\$${(coin.data.price as num).toStringAsFixed(2)}';
        } else {
          priceStr = '\$0.00';
        }

        return TrendingCoinEntity(
          id: coin.id,
          name: coin.name,
          symbol: coin.symbol.toUpperCase(),
          imageUrl: coin.large,
          price: priceStr,
          priceChangePercentage24h: priceChangeUsd,
        );
      }).toList();

      return Right(trendingCoins);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<TopGainerEntity>>> getTopGainers() async {
    try {
      final response = await _apiService.getTopGainers();

      // Filter and sort by price change percentage
      final gainers = response
          .where((coin) =>
              coin.priceChangePercentage24h != null &&
              coin.priceChangePercentage24h! > 0)
          .toList()
        ..sort((a, b) => (b.priceChangePercentage24h ?? 0)
            .compareTo(a.priceChangePercentage24h ?? 0));

      // Take top 10
      final topGainers = gainers.take(10).map((coin) {
        return TopGainerEntity(
          id: coin.id,
          name: coin.name,
          symbol: coin.symbol.toUpperCase(),
          imageUrl: coin.image,
          currentPrice: coin.currentPrice,
          priceChangePercentage24h: coin.priceChangePercentage24h ?? 0,
        );
      }).toList();

      return Right(topGainers);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  @override
  Future<Either<Failure, PortfolioBalance>> getPortfolioBalance() async {
    try {
      final data = await _getGlobalDataCached();

      // Simulate portfolio balance based on market data
      // In a real app, this would come from user's actual portfolio
      final marketCapChangePercentage = data.marketCapChangePercentage24hUsd;

      // Simulated portfolio value (this would be real user data in production)
      const double baseBalance = AppConstants.defaultDemoBalance;

      // Calculate weekly change based on market performance
      // Using market cap change as a proxy for portfolio performance
      final weeklyChange =
          marketCapChangePercentage * AppConstants.weeklyChangeMultiplier;

      final portfolioBalance = PortfolioBalance(
        totalBalance: baseBalance,
        weeklyChangePercentage: weeklyChange,
      );

      return Right(portfolioBalance);
    } catch (e) {
      final errorMessage = ApiErrorHandler.handleError(e);
      return Left(ServerFailure(message: errorMessage));
    }
  }

  String _formatCurrency(double value) {
    if (value >= 1000000000000) {
      return '\$${(value / 1000000000000).toStringAsFixed(1)}T';
    } else if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else {
      return '\$${value.toStringAsFixed(0)}';
    }
  }
}
