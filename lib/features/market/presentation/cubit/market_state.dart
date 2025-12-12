import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/features/market/domain/entities/market_coin.dart';


abstract class MarketState extends Equatable {
  const MarketState();

  /// Empty props for base state (overridden by subclasses)
  @override
  List<Object?> get props => [];
}

/// Initial state when the market screen is first created
/// No data has been loaded yet
class MarketInitial extends MarketState {}

/// Loading state while fetching market data from API
/// UI should display loading indicators during this state
class MarketLoading extends MarketState {}

/// Success state containing loaded market coins
/// UI rebuilds to display the fetched data when this state is emitted
class MarketLoaded extends MarketState {
  /// List of market coins for the current page
  final List<MarketCoinEntity> coins;

  /// Current page number
  final int currentPage;

  /// Indicates if more pages are available
  final bool hasMorePages;

  /// Indicates if loading more data (pagination)
  final bool isLoadingMore;

  /// Current search sub-state (initial/loading/loaded/error)
  final SearchState searchState;

  /// Constructor requiring market data
  const MarketLoaded({
    required this.coins,
    required this.currentPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
    this.searchState = const SearchInitial(),
  });

  /// Equatable props for state comparison
  /// State is considered changed if any of these values differ
  @override
  List<Object?> get props =>
      [coins, currentPage, hasMorePages, isLoadingMore, searchState];

  /// Creates a copy of this state with updated values
  MarketLoaded copyWith({
    List<MarketCoinEntity>? coins,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
    SearchState? searchState,
  }) {
    return MarketLoaded(
      coins: coins ?? this.coins,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchState: searchState ?? this.searchState,
    );
  }
}

/// Error state when data fetching fails
/// Contains error message to display to the user
class MarketError extends MarketState {
  /// Human-readable error message describing what went wrong
  final String message;

  const MarketError({required this.message});

  /// Equatable props - state changes if error message is different
  @override
  List<Object?> get props => [message];
}

/// Search state - represents the current state of search functionality
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Initial search state - no search performed yet
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Search in progress
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Search completed successfully with results
class SearchLoaded extends SearchState {
  /// List of search results with full market data
  final List<MarketCoinEntity> searchResults;

  /// The query that was searched
  final String query;

  const SearchLoaded({
    required this.searchResults,
    required this.query,
  });

  @override
  List<Object?> get props => [searchResults, query];
}

/// Search failed with error
class SearchError extends SearchState {
  /// Human-readable error message
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
