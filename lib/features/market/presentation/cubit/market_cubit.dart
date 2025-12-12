import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_18_final_project/core/constants/api_constants.dart';
import 'package:team_18_final_project/features/market/domain/usecases/get_market_coins_usecase.dart';
import 'package:team_18_final_project/features/market/domain/usecases/get_market_coins_by_ids_usecase.dart';
import 'package:team_18_final_project/features/market/domain/usecases/search_coins_usecase.dart';
import 'market_state.dart';

/// Cubit for managing market screen state and business logic
/// Handles loading market coins with pagination and search functionality
class MarketCubit extends Cubit<MarketState> {
  final GetMarketCoinsUseCase getMarketCoinsUseCase;
  final SearchCoinsUseCase searchCoinsUseCase;
  final GetMarketCoinsByIdsUseCase getMarketCoinsByIdsUseCase;

  /// Prevents multiple simultaneous load requests
  bool _isLoading = false;

  /// Prevents multiple simultaneous pagination requests
  bool _isLoadingMore = false;

  /// Search state management
  SearchState _searchState = const SearchInitial();
  SearchState get searchState => _searchState;

  /// Debounce timer for search
  Timer? _searchDebounce;

  /// Search debounce duration (800ms to reduce API calls)
  static const _searchDebounceDuration = Duration(milliseconds: 800);

  MarketCubit({
    required this.getMarketCoinsUseCase,
    required this.searchCoinsUseCase,
    required this.getMarketCoinsByIdsUseCase,
  }) : super(MarketInitial()) {
    debugPrint('[MarketCubit] created');
  }

  /// Loads market coins for the initial page
  Future<void> loadMarketCoins() async {
    if (_isLoading) {
      debugPrint('[MarketCubit] loadMarketCoins skipped - already loading');
      return;
    }

    _isLoading = true;
    debugPrint('[MarketCubit] loadMarketCoins start');
    emit(MarketLoading());

    try {
      final result = await getMarketCoinsUseCase(
        page: 1,
        perPage: ApiDefaults.defaultPerPage,
      );

      if (isClosed) return;

      result.fold(
        (failure) {
          debugPrint('[MarketCubit] loadMarketCoins error: ${failure.message}');
          emit(MarketError(message: failure.message));
        },
        (coins) {
          debugPrint(
              '[MarketCubit] loadMarketCoins success - loaded ${coins.length} coins');
          _searchState = const SearchInitial();
          emit(MarketLoaded(
            coins: coins,
            currentPage: 1,
            hasMorePages: coins.length >= ApiDefaults.defaultPerPage,
            searchState: _searchState,
          ));
        },
      );
    } catch (e) {
      if (!isClosed) {
        debugPrint('[MarketCubit] loadMarketCoins unexpected error: $e');
        emit(MarketError(message: 'An unexpected error occurred: $e'));
      }
    } finally {
      _isLoading = false;
    }
  }

  /// Loads more market coins (pagination)
  Future<void> loadMoreMarketCoins() async {
    final currentState = state;
    if (currentState is! MarketLoaded) return;

    if (_isLoadingMore || !currentState.hasMorePages) {
      debugPrint(
          '[MarketCubit] loadMoreMarketCoins skipped - isLoading: $_isLoadingMore, hasMore: ${currentState.hasMorePages}');
      return;
    }

    _isLoadingMore = true;
    final nextPage = currentState.currentPage + 1;
    debugPrint('[MarketCubit] loadMoreMarketCoins page: $nextPage');

    // Update state to show loading indicator
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final result = await getMarketCoinsUseCase(
        page: nextPage,
        perPage: ApiDefaults.defaultPerPage,
      );

      if (isClosed) return;

      result.fold(
        (failure) {
          debugPrint(
              '[MarketCubit] loadMoreMarketCoins error: ${failure.message}');
          // Revert loading state on error
          emit(currentState.copyWith(isLoadingMore: false));
        },
        (newCoins) {
          debugPrint(
              '[MarketCubit] loadMoreMarketCoins success - loaded ${newCoins.length} coins');
          // Append new coins to existing list
          final allCoins = [...currentState.coins, ...newCoins];
          emit(MarketLoaded(
            coins: allCoins,
            currentPage: nextPage,
            hasMorePages: newCoins.length >= ApiDefaults.defaultPerPage,
            isLoadingMore: false,
            searchState: currentState.searchState,
          ));
        },
      );
    } catch (e) {
      if (!isClosed) {
        debugPrint('[MarketCubit] loadMoreMarketCoins unexpected error: $e');
        // Revert loading state on error
        emit(currentState.copyWith(isLoadingMore: false));
      }
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Refreshes market data (pull to refresh)
  Future<void> refreshMarketCoins() async {
    debugPrint('[MarketCubit] refreshMarketCoins');
    await loadMarketCoins();
  }

  /// Searches for coins by keyword with debouncing
  void searchCoins(String query) {
    // Cancel previous debounce timer
    _searchDebounce?.cancel();

    // If query is empty, reset search state
    if (query.trim().isEmpty) {
      _updateSearchState(SearchInitial());
      return;
    }

    // Show loading state immediately
    _updateSearchState(const SearchLoading());

    // Debounce the search request
    _searchDebounce = Timer(_searchDebounceDuration, () {
      _performSearch(query);
    });
  }

  /// Performs the actual search API call
  Future<void> _performSearch(String query) async {
    debugPrint('[MarketCubit] _performSearch query: $query');

    try {
      _updateSearchState(const SearchLoading());

      // First, search for coins to get IDs
      final searchResult = await searchCoinsUseCase(query);

      if (isClosed) return;

      await searchResult.fold(
        (failure) {
          debugPrint('[MarketCubit] _performSearch error: ${failure.message}');
          _updateSearchState(SearchError(message: failure.message));
        },
        (searchResults) async {
          debugPrint(
              '[MarketCubit] _performSearch success - found ${searchResults.length} results');

          if (searchResults.isEmpty) {
            _updateSearchState(SearchLoaded(
              searchResults: [],
              query: query,
            ));
            return;
          }

          // Extract coin IDs from search results
          final coinIds = searchResults.map((coin) => coin.id).toList();

          // Fetch full market data for these coins
          final marketDataResult = await getMarketCoinsByIdsUseCase(coinIds);

          if (isClosed) return;

          marketDataResult.fold(
            (failure) {
              debugPrint(
                  '[MarketCubit] _performSearch market data error: ${failure.message}');
              _updateSearchState(SearchError(message: failure.message));
            },
            (marketCoins) {
              debugPrint(
                  '[MarketCubit] _performSearch market data success - loaded ${marketCoins.length} coins with prices');
              _updateSearchState(SearchLoaded(
                searchResults: marketCoins,
                query: query,
              ));
            },
          );
        },
      );
    } catch (e) {
      if (!isClosed) {
        debugPrint('[MarketCubit] _performSearch unexpected error: $e');
        _updateSearchState(
            SearchError(message: 'An unexpected error occurred: $e'));
      }
    }
  }

  /// Clears search results and resets search state
  void clearSearch() {
    debugPrint('[MarketCubit] clearSearch');
    _searchDebounce?.cancel();
    _updateSearchState(const SearchInitial());
  }

  /// Updates search state and notifies listeners
  void _updateSearchState(SearchState newState) {
    _searchState = newState;
    // Emit current market state to trigger rebuild with new search state
    if (state is MarketLoaded) {
      emit((state as MarketLoaded).copyWith(searchState: newState));
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
