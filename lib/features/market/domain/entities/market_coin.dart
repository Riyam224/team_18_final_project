import 'package:equatable/equatable.dart';

/// Domain entity representing a cryptocurrency in the market list
/// Extends Equatable to enable value-based equality comparison for state management
/// This is a pure business logic object with no knowledge of data sources or UI
class MarketCoinEntity extends Equatable {
  /// Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  final String id;

  /// Trading symbol/ticker in uppercase (e.g., 'BTC', 'ETH')
  final String symbol;

  /// Full name of the cryptocurrency (e.g., 'Bitcoin', 'Ethereum')
  final String name;

  /// URL to the cryptocurrency's logo/icon image
  final String? image;

  /// Current price in USD
  final double? currentPrice;

  /// Market capitalization in USD
  final double? marketCap;

  /// Market cap rank (1 for highest market cap)
  final int? marketCapRank;

  /// Trading volume in the last 24 hours in USD
  final double? totalVolume;

  /// Highest price in the last 24 hours in USD
  final double? high24h;

  /// Lowest price in the last 24 hours in USD
  final double? low24h;

  /// Price change in USD in the last 24 hours
  final double? priceChange24h;

  /// Percentage change in price over the last 24 hours
  /// Positive = price increase, Negative = price decrease
  final double? priceChangePercentage24h;

  /// Market cap change in USD in the last 24 hours
  final double? marketCapChange24h;

  /// Percentage change in market cap over the last 24 hours
  final double? marketCapChangePercentage24h;

  /// Circulating supply of the cryptocurrency
  final double? circulatingSupply;

  /// Total supply of the cryptocurrency
  final double? totalSupply;

  /// Maximum supply cap of the cryptocurrency (null if unlimited)
  final double? maxSupply;

  /// All-time high price in USD
  final double? ath;

  /// Percentage change from all-time high
  final double? athChangePercentage;

  /// Date when all-time high was reached
  final DateTime? athDate;

  /// All-time low price in USD
  final double? atl;

  /// Percentage change from all-time low
  final double? atlChangePercentage;

  /// Date when all-time low was reached
  final DateTime? atlDate;

  /// Last updated timestamp
  final DateTime? lastUpdated;

  /// Constructor requiring essential market coin data
  const MarketCoinEntity({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.lastUpdated,
  });

  /// Equatable props for value comparison
  /// Two MarketCoinEntity objects are equal if all these properties match
  @override
  List<Object?> get props => [
        id,
        symbol,
        name,
        image,
        currentPrice,
        marketCap,
        marketCapRank,
        totalVolume,
        high24h,
        low24h,
        priceChange24h,
        priceChangePercentage24h,
        marketCapChange24h,
        marketCapChangePercentage24h,
        circulatingSupply,
        totalSupply,
        maxSupply,
        ath,
        athChangePercentage,
        athDate,
        atl,
        atlChangePercentage,
        atlDate,
        lastUpdated,
      ];
}
