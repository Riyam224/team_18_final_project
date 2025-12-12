import 'package:team_18_final_project/features/market/data/models/coin_chart_model.dart';

class CoinDetailsModel {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercentage24h;
  final String description;
  final Map<String, double> marketStats;
  
  CoinChartModel? chartData; 

  set updateChartData(CoinChartModel? newChartData) {
    chartData = newChartData;
  }


  CoinDetailsModel({
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
}
