import 'package:equatable/equatable.dart';

/// Domain entity representing a cryptocurrency in search results
/// Extends Equatable to enable value-based equality comparison for state management
/// This is a pure business logic object with no knowledge of data sources or UI
class SearchCoinEntity extends Equatable {
  /// Unique identifier for the cryptocurrency (e.g., 'bitcoin', 'ethereum')
  final String id;

  /// Full name of the cryptocurrency (e.g., 'Bitcoin', 'Ethereum')
  final String name;

  /// Trading symbol/ticker in uppercase (e.g., 'BTC', 'ETH')
  final String symbol;

  /// Market cap rank (1 for highest market cap)
  final int? marketCapRank;

  /// URL to the cryptocurrency's logo/icon image (thumb size)
  final String? thumb;

  /// URL to the cryptocurrency's logo/icon image (small size)
  final String? small;

  /// URL to the cryptocurrency's logo/icon image (large size)
  final String? large;

  /// Constructor requiring essential search coin data
  const SearchCoinEntity({
    required this.id,
    required this.name,
    required this.symbol,
    this.marketCapRank,
    this.thumb,
    this.small,
    this.large,
  });

  /// Equatable props for value comparison
  /// Two SearchCoinEntity objects are equal if all these properties match
  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        marketCapRank,
        thumb,
        small,
        large,
      ];
}
