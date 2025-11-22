import 'package:equatable/equatable.dart';

class MarketOverview extends Equatable {
  final String marketCap;
  final String volume24h;
  final String btcDominance;
  final int activeCoins;
  final double marketCapChangePercentage;

  const MarketOverview({
    required this.marketCap,
    required this.volume24h,
    required this.btcDominance,
    required this.activeCoins,
    required this.marketCapChangePercentage,
  });

  @override
  List<Object?> get props => [
        marketCap,
        volume24h,
        btcDominance,
        activeCoins,
        marketCapChangePercentage,
      ];
}
