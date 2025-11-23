// Imports Equatable for value equality comparison (compares values, not references)
import 'package:equatable/equatable.dart';

/// Domain entity representing a trending cryptocurrency based on search volume and popularity
/// Extends Equatable to enable value-based equality comparison for state management
/// This is a pure business logic object with no knowledge of data sources or UI
class TrendingCoinEntity extends Equatable {
  /// Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  final String id;

  /// Full name of the cryptocurrency (e.g., 'Bitcoin', 'Ethereum')
  final String name;

  /// Trading symbol/ticker in uppercase (e.g., 'BTC', 'ETH')
  final String symbol;

  /// URL to the cryptocurrency's logo/icon image
  final String imageUrl;

  /// Current price formatted as a string (e.g., "$45,123.45")
  /// Stored as string to handle various API response formats
  final String price;

  /// Percentage change in price over the last 24 hours
  /// Positive = price increase, Negative = price decrease
  final double priceChangePercentage24h;

  /// Constructor requiring all essential trending coin data
  const TrendingCoinEntity({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.priceChangePercentage24h,
  });

  /// Equatable props for value comparison
  /// Two TrendingCoinEntity objects are equal if all these properties match
  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        imageUrl,
        price,
        priceChangePercentage24h,
      ];
}
