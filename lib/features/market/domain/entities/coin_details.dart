import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/market/domain/entities/chart_point.dart';

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

  /// Additional descriptive text about the coin
  final String description;

  /// Key market statistics displayed in the UI
  final Map<String, double> marketStats;

  /// Historical price points for the selected period (x = timestamp hours, y = price)
  final List<ChartPoint> chartPoints;

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
    required this.description,
    required this.marketStats,
    required this.chartPoints,
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
        description,
        marketStats,
      chartPoints,
      ];

  CoinDetailsEntity copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    int? marketCapRank,
    double? marketCap,
    double? totalVolume,
    double? priceChangePercentage24h,
    double? priceChange24h,
    double? circulatingSupply,
    double? totalSupply,
    double? ath,
    double? atl,
    String? description,
    Map<String, double>? marketStats,
    List<ChartPoint>? chartPoints,
  }) {
    return CoinDetailsEntity(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      marketCap: marketCap ?? this.marketCap,
      totalVolume: totalVolume ?? this.totalVolume,
      priceChangePercentage24h:
          priceChangePercentage24h ?? this.priceChangePercentage24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      totalSupply: totalSupply ?? this.totalSupply,
      ath: ath ?? this.ath,
      atl: atl ?? this.atl,
      description: description ?? this.description,
      marketStats: marketStats ?? this.marketStats,
      chartPoints: chartPoints ?? this.chartPoints,
    );
  }
}
