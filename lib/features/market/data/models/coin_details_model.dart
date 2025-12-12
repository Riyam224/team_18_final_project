import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/market/domain/entities/chart_point.dart';
import 'package:team_18_final_project/features/market/domain/entities/coin_details.dart';
import 'package:team_18_final_project/features/market/data/models/coin_chart_model.dart';

class CoinDetailsModel extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;
  final String description;
  final Map<String, double> marketStats;
  final CoinChartModel? chartData;

  const CoinDetailsModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.description,
    required this.marketStats,
    this.chartData,
  });

  /// Create a copy of this model with updated chart data
  CoinDetailsModel copyWith({
    String? id,
    String? symbol,
    String? name,
    String? imageUrl,
    double? currentPrice,
    double? priceChangePercentage24h,
    String? description,
    Map<String, double>? marketStats,
    CoinChartModel? chartData,
  }) {
    return CoinDetailsModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      description: description ?? this.description,
      marketStats: marketStats ?? this.marketStats,
      chartData: chartData ?? this.chartData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        name,
        imageUrl,
        currentPrice,
        priceChangePercentage24h,
        description,
        marketStats,
        chartData,
      ];

  factory CoinDetailsModel.fromJson(Map<String, dynamic> json) {
    return CoinDetailsModel(
        id: json['id'] as String? ?? 'N/A',
        symbol: json['symbol'] as String? ?? 'N/A',
        name: json['name'] as String? ?? 'Unknown Coin',
        imageUrl: (json['image'] is Map) 
            ? json['image']['large'] ?? json['image']['small'] ?? '' 
            : '',
        currentPrice: (json['market_data']?['current_price']?['usd'] as num?)?.toDouble() ?? 0.0,
        priceChangePercentage24h: (json['market_data']?['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
        description: json['description']?['en'] ?? 'No description available.',
        marketStats: {
          'Market Cap': (json['market_data']?['market_cap']?['usd'] as num?)?.toDouble() ?? 0.0,
          'Volume 24h': (json['market_data']?['total_volume']?['usd'] as num?)?.toDouble() ?? 0.0,
          'Available Supply': (json['market_data']?['circulating_supply'] as num?)?.toDouble() ?? 0.0,
          'Max Supply': (json['market_data']?['max_supply'] as num?)?.toDouble() ?? 0.0,
        }
    );
  }

  CoinDetailsEntity toEntity({List<ChartPoint> chartPoints = const []}) {
    return CoinDetailsEntity(
      id: id,
      symbol: symbol,
      name: name,
      image: imageUrl,
      currentPrice: currentPrice,
      marketCapRank: null,
      marketCap: marketStats['Market Cap'],
      totalVolume: marketStats['Volume 24h'],
      priceChangePercentage24h: priceChangePercentage24h,
      priceChange24h: null,
      circulatingSupply: marketStats['Available Supply'],
      totalSupply: marketStats['Max Supply'],
      ath: null,
      atl: null,
      description: description,
      marketStats: marketStats,
      chartPoints: chartPoints,
    );
  }
}
