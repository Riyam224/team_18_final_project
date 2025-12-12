import 'package:fl_chart/fl_chart.dart';

class CoinChartModel {
  final List<FlSpot> prices; 

  CoinChartModel({required this.prices});

  factory CoinChartModel.fromJson(Map<String, dynamic> json) {
    final List pricesRaw = json['prices'] ?? [];
    
    final List<FlSpot> spots = pricesRaw.map((point) {
      final double timestampInHours = (point[0] as num).toDouble() / 3600000;
      final double price = (point[1] as num).toDouble();
      return FlSpot(timestampInHours, price);
    }).toList();

    return CoinChartModel(prices: spots);
  }
}