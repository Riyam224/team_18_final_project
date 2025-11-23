// Imports Equatable for value equality comparison (compares values, not references)
import 'package:equatable/equatable.dart';

/// Domain entity representing global cryptocurrency market overview statistics
/// Extends Equatable to enable value-based equality comparison for state management
/// This is a pure business logic object with no knowledge of data sources or UI
class MarketOverview extends Equatable {
  /// Total market capitalization formatted as human-readable string (e.g., "$2.1T")
  final String marketCap;

  /// 24-hour trading volume formatted as human-readable string (e.g., "$98.5B")
  final String volume24h;

  /// Bitcoin's dominance percentage formatted as string (e.g., "52.3%")
  final String btcDominance;

  /// Number of active cryptocurrencies being tracked
  final int activeCoins;

  /// Percentage change in total market cap over 24 hours (raw double value)
  /// Positive = market growth, Negative = market decline
  final double marketCapChangePercentage;

  /// Constructor requiring all market overview fields
  const MarketOverview({
    required this.marketCap,
    required this.volume24h,
    required this.btcDominance,
    required this.activeCoins,
    required this.marketCapChangePercentage,
  });

  /// Equatable props for value comparison
  /// Two MarketOverview objects are equal if all these properties match
  @override
  List<Object?> get props => [
        marketCap,
        volume24h,
        btcDominance,
        activeCoins,
        marketCapChangePercentage,
      ];
}
