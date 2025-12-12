import 'package:equatable/equatable.dart';

/// Domain entity representing detailed information about a cryptocurrency
/// Used for buy/sell screens and detailed coin views
class CoinDetailsEntity extends Equatable {
  /// Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  final String id;

  /// Trading symbol/ticker in uppercase (e.g., 'BTC', 'ETH')
  final String symbol;

  /// Full name of the cryptocurrency (e.g., 'Bitcoin', 'Ethereum')
  final String name;

  /// URL to the cryptocurrency's logo/icon image
  final String? image;

  /// Current market price in USD
  final double currentPrice;

  /// Market cap rank (1 for highest market cap)
  final int? marketCapRank;

  /// Total market capitalization in USD
  final double? marketCap;

  /// Total trading volume in 24 hours
  final double? totalVolume;

  /// Price change in 24 hours (percentage)
  final double? priceChangePercentage24h;

  /// Price change in 24 hours (absolute value)
  final double? priceChange24h;

  /// Circulating supply
  final double? circulatingSupply;

  /// Total supply
  final double? totalSupply;

  /// All time high price
  final double? ath;

  /// All time low price
  final double? atl;

  const CoinDetailsEntity({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    required this.currentPrice,
    this.marketCapRank,
    this.marketCap,
    this.totalVolume,
    this.priceChangePercentage24h,
    this.priceChange24h,
    this.circulatingSupply,
    this.totalSupply,
    this.ath,
    this.atl,
  });

  @override
  List<Object?> get props => [
        id,
        symbol,
        name,
        image,
        currentPrice,
        marketCapRank,
        marketCap,
        totalVolume,
        priceChangePercentage24h,
        priceChange24h,
        circulatingSupply,
        totalSupply,
        ath,
        atl,
      ];
}
