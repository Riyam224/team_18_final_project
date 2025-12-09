class SimplePriceModel {
  final double usd;
  final double usd24hChange;

  const SimplePriceModel({
    required this.usd,
    required this.usd24hChange,
  });

  factory SimplePriceModel.fromJson(Map<String, dynamic> json) {
    return SimplePriceModel(
      usd: (json['usd'] as num?)?.toDouble() ?? 0,
      usd24hChange: (json['usd_24h_change'] as num?)?.toDouble() ?? 0,
    );
  }
}
