// Imports Equatable for value equality comparison (compares values, not references)
import 'package:equatable/equatable.dart';

/// Domain entity representing a cryptocurrency that has gained significant value in 24h
/// Extends Equatable to enable value-based equality comparison for state management
/// This is a pure business logic object with no knowledge of data sources or UI
class TopGainerEntity extends Equatable {
  /// Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  final String id;

  /// Full name of the cryptocurrency (e.g., 'Bitcoin', 'Ethereum')
  final String name;

  /// Trading symbol/ticker in uppercase (e.g., 'BTC', 'ETH')
  final String symbol;

  /// URL to the cryptocurrency's logo/icon image
  final String imageUrl;

  /// Current trading price in USD (raw double value)
  final double currentPrice;

  /// Percentage change in price over the last 24 hours
  /// This is the key metric for identifying "top gainers"
  /// Positive values indicate price increase
  final double priceChangePercentage24h;

  /// Constructor requiring all essential top gainer data
  const TopGainerEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercentage24h,
  });

  /// Equatable props for value comparison
  /// Two TopGainerEntity objects are equal if all these properties match
  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        imageUrl,
        currentPrice,
        priceChangePercentage24h,
      ];
}
