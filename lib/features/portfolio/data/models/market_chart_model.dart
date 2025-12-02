class MarketChartModel {
  final List<List<num>> prices;
  final List<List<num>>? marketCaps;
  final List<List<num>>? totalVolumes;

  const MarketChartModel({
    required this.prices,
    this.marketCaps,
    this.totalVolumes,
  });

  factory MarketChartModel.fromJson(Map<String, dynamic> json) {
    return MarketChartModel(
      prices: (json['prices'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).cast<num>())
              .toList() ??
          [],
      marketCaps: (json['market_caps'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).cast<num>())
          .toList(),
      totalVolumes: (json['total_volumes'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).cast<num>())
          .toList(),
    );
  }

  /// Get the average price from the historical data
  double get averagePrice {
    if (prices.isEmpty) return 0;
    final sum = prices.fold<double>(0, (sum, price) => sum + price[1].toDouble());
    return sum / prices.length;
  }

  /// Get the latest price from the chart
  double get latestPrice {
    if (prices.isEmpty) return 0;
    return prices.last[1].toDouble();
  }

  /// Get the earliest price from the chart
  double get earliestPrice {
    if (prices.isEmpty) return 0;
    return prices.first[1].toDouble();
  }

  /// Calculate price change percentage over the period
  double get priceChangePercent {
    if (prices.isEmpty || earliestPrice == 0) return 0;
    return ((latestPrice - earliestPrice) / earliestPrice) * 100;
  }
}
