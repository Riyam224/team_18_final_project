# Complete File Structure Guide

This document provides a detailed explanation of every file in the home feature module.

## Table of Contents
1. [Data Layer Files](#data-layer-files)
2. [Domain Layer Files](#domain-layer-files)
3. [Presentation Layer Files](#presentation-layer-files)
4. [Generated Files](#generated-files)

---

## Data Layer Files

### 📁 `lib/features/home/data/data_sources/`

#### `home_api_service.dart`
**Purpose**: Defines API endpoints for home screen data using Retrofit

**Key Components**:
```dart
@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String baseUrl});

  @GET(Endpoints.global)
  Future<GlobalDataModel> getGlobalData();

  @GET(Endpoints.trendingCoinsList)
  Future<TrendingCoinsModel> getTrendingCoins();

  @GET(Endpoints.topGainers)
  Future<List<TopGainerModel>> getTopGainers();
}
```

**Endpoints Used**:
- `/global` - Global market statistics
- `/search/trending` - Trending cryptocurrencies
- `/coins/markets?vs_currency=usd&order=market_cap_desc` - Market data for top coins

**Dependencies**:
- Dio (HTTP client)
- Retrofit (type-safe API client)

---

### 📁 `lib/features/home/data/models/`

#### `global_data_model.dart`
**Purpose**: Model for global cryptocurrency market data from API

**Classes**:
1. **`GlobalDataModel`** - Wrapper for API response
   ```dart
   class GlobalDataModel {
     final GlobalData data;  // Nested data object
   }
   ```

2. **`GlobalData`** - Actual market statistics
   ```dart
   class GlobalData {
     final int activeCryptocurrencies;              // Number of tracked coins
     final Map<String, double> totalMarketCap;      // Market cap by currency
     final Map<String, double> totalVolume;         // 24h volume by currency
     final Map<String, double> marketCapPercentage; // Dominance percentages
     final double marketCapChangePercentage24hUsd;  // 24h change
   }
   ```

**JSON Fields**:
- `active_cryptocurrencies` → activeCryptocurrencies
- `total_market_cap` → totalMarketCap (Map)
- `total_volume` → totalVolume (Map)
- `market_cap_percentage` → marketCapPercentage (Map)
- `market_cap_change_percentage_24h_usd` → marketCapChangePercentage24hUsd

**Usage**: Fetched by `HomeApiService.getGlobalData()`, used in market overview and portfolio

---

#### `top_gainer_model.dart`
**Purpose**: Model for cryptocurrency with high 24h price increase

**Class Structure**:
```dart
class TopGainerModel {
  // Identification
  final String id;                    // e.g., 'bitcoin'
  final String symbol;                // e.g., 'btc'
  final String name;                  // e.g., 'Bitcoin'
  final String image;                 // Logo URL

  // Current prices & market data
  final double currentPrice;          // Current price in USD
  final double marketCap;             // Total market capitalization
  final int? marketCapRank;           // Rank by market cap (nullable)
  final double? fullyDilutedValuation; // FDV (nullable)
  final double totalVolume;           // 24h trading volume

  // 24-hour price range
  final double? high24h;              // 24h high price
  final double? low24h;               // 24h low price

  // Price changes (24h)
  final double? priceChange24h;              // Absolute change
  final double? priceChangePercentage24h;    // Percentage change ⭐
  final double? marketCapChange24h;          // Market cap change
  final double? marketCapChangePercentage24h; // Market cap % change

  // Supply metrics
  final double? circulatingSupply;    // Coins in circulation
  final double? totalSupply;          // Total existing coins
  final double? maxSupply;            // Maximum possible supply

  // All-time high (ATH)
  final double? ath;                  // ATH price
  final double? athChangePercentage;  // % from ATH
  final String? athDate;              // Date of ATH

  // All-time low (ATL)
  final double? atl;                  // ATL price
  final double? atlChangePercentage;  // % from ATL
  final String? atlDate;              // Date of ATL

  final String lastUpdated;           // Last update timestamp
}
```

**Key Field**: `priceChangePercentage24h` - Used to identify "top gainers"

**Nullable Fields**: Most fields are nullable because API may not always provide complete data

**Usage**: Fetched by `HomeApiService.getTopGainers()`, displayed in Top Gainers list

---

#### `trending_coin_model.dart`
**Purpose**: Models for trending cryptocurrencies based on search volume

**Classes**:
1. **`TrendingCoinsModel`** - Top-level API response
   ```dart
   class TrendingCoinsModel {
     final List<TrendingCoinItem> coins;
   }
   ```

2. **`TrendingCoinItem`** - Wrapper for each trending coin
   ```dart
   class TrendingCoinItem {
     final TrendingCoin item;  // Nested coin data
   }
   ```

3. **`TrendingCoin`** - Coin identification and images
   ```dart
   class TrendingCoin {
     final String id;           // Coin ID
     final int coinId;          // CoinGecko numeric ID
     final String name;         // Full name
     final String symbol;       // Symbol
     final String thumb;        // Thumbnail image URL
     final String small;        // Small image URL
     final String large;        // Large image URL
     final String slug;         // URL slug
     final double priceBtc;     // Price in BTC
     final int score;           // Trending score
     final TrendingCoinData data; // Nested market data
   }
   ```

4. **`TrendingCoinData`** - Market data for trending coin
   ```dart
   class TrendingCoinData {
     final dynamic price;       // Current price (flexible type)
     final dynamic priceBtc;    // Price in BTC (flexible type)
     final Map<String, dynamic>? priceChangePercentage24h; // 24h changes
     final dynamic marketCap;   // Market cap (flexible type)
     final dynamic totalVolume; // Trading volume (flexible type)
   }
   ```

**Why Dynamic Types?**: API returns inconsistent types (sometimes string, sometimes number)

**Nested Structure**: API returns coins inside `{ coins: [{ item: {...} }] }`

**Usage**: Fetched by `HomeApiService.getTrendingCoins()`, displayed in Trending Now carousel

---

### 📁 `lib/features/home/data/repositories/`

#### `home_repository_impl.dart`
**Purpose**: Implements data fetching logic and maps models to entities

**Key Responsibilities**:
1. Fetch data from API service
2. Transform API models → Domain entities
3. Handle errors → Failure objects
4. Cache global data (30-second TTL)

**Methods**:

1. **`getMarketOverview()`**
   ```dart
   Future<Either<Failure, MarketOverview>> getMarketOverview() async {
     try {
       final data = await _getGlobalDataCached(); // Use cached data
       // Extract and format values
       final marketCap = _formatCurrency(data.totalMarketCap['usd']);
       final volume = _formatCurrency(data.totalVolume['usd']);
       final btcDominance = '${data.marketCapPercentage['btc']}%';

       return Right(MarketOverview(...));
     } catch (e) {
       return Left(ServerFailure(message: errorMessage));
     }
   }
   ```

2. **`getTrendingCoins()`**
   ```dart
   Future<Either<Failure, List<TrendingCoinEntity>>> getTrendingCoins() async {
     // Fetch trending coins
     // Handle dynamic price types
     // Map to TrendingCoinEntity
     // Return Either<Failure, List>
   }
   ```

3. **`getTopGainers()`**
   ```dart
   Future<Either<Failure, List<TopGainerEntity>>> getTopGainers() async {
     // Fetch all coins
     // Filter: priceChangePercentage24h > 0
     // Sort by priceChangePercentage24h (descending)
     // Take top 10
     // Map to TopGainerEntity
   }
   ```

4. **`getPortfolioBalance()`**
   ```dart
   Future<Either<Failure, PortfolioBalance>> getPortfolioBalance() async {
     // Use cached global data
     // Simulate portfolio balance (baseBalance = $143,421.20)
     // Calculate weekly change from market data
     // Return PortfolioBalance entity
   }
   ```

**Caching Strategy**:
```dart
dynamic _cachedGlobalData;
DateTime? _cacheTimestamp;
static const _cacheDuration = Duration(seconds: 30);

Future<dynamic> _getGlobalDataCached() async {
  // Check if cache is still valid
  if (cache valid) return _cachedGlobalData;

  // Fetch fresh data
  final response = await _apiService.getGlobalData();
  _cachedGlobalData = response.data;
  _cacheTimestamp = DateTime.now();
  return _cachedGlobalData;
}
```

**Currency Formatting**:
```dart
String _formatCurrency(double value) {
  if (value >= 1T) return '\$${(value / 1T).toFixed(1)}T';
  if (value >= 1B) return '\$${(value / 1B).toFixed(1)}B';
  if (value >= 1M) return '\$${(value / 1M).toFixed(1)}M';
  return '\$${value.toFixed(0)}';
}
```

---

## Domain Layer Files

### 📁 `lib/features/home/domain/entities/`

#### `market_overview.dart`
**Purpose**: Business object representing global market statistics

**Class Structure**:
```dart
class MarketOverview extends Equatable {
  final String marketCap;        // e.g., "$2.1T"
  final String volume24h;        // e.g., "$98.5B"
  final String btcDominance;     // e.g., "52.3%"
  final int activeCoins;         // e.g., 13847
  final double marketCapChangePercentage; // e.g., 1.23 or -2.45
}
```

**Extends Equatable**: Enables value comparison (two objects equal if all fields match)

**Formatted Strings**: marketCap, volume24h, btcDominance are human-readable

**Used In**: Market Overview Grid widget

---

#### `portfolio_balance.dart`
**Purpose**: Represents user's portfolio value and performance

**Class Structure**:
```dart
class PortfolioBalance extends Equatable {
  final double totalBalance;           // e.g., 143421.20
  final double weeklyChangePercentage; // e.g., 5.67 or -3.21
}
```

**Simple Design**: Only two fields needed for balance card

**Used In**: Balance Card widget (top of home screen)

---

#### `top_gainer.dart`
**Purpose**: Represents a cryptocurrency with significant 24h price increase

**Class Structure**:
```dart
class TopGainerEntity extends Equatable {
  final String id;              // e.g., 'bitcoin'
  final String name;            // e.g., 'Bitcoin'
  final String symbol;          // e.g., 'BTC' (uppercase)
  final String imageUrl;        // Logo URL
  final double currentPrice;    // e.g., 45123.45
  final double priceChangePercentage24h; // e.g., 12.34
}
```

**Key Field**: `priceChangePercentage24h` - Determines gainer rank

**All Required**: No nullable fields (filtered during mapping)

**Used In**: Top Gainers List widget

---

#### `trending_coin.dart`
**Purpose**: Represents a trending cryptocurrency

**Class Structure**:
```dart
class TrendingCoinEntity extends Equatable {
  final String id;              // e.g., 'ethereum'
  final String name;            // e.g., 'Ethereum'
  final String symbol;          // e.g., 'ETH' (uppercase)
  final String imageUrl;        // Logo URL
  final String price;           // e.g., "$2,845.67" (formatted string)
  final double priceChangePercentage24h; // e.g., 3.45 or -1.23
}
```

**Price as String**: Flexible handling of various API formats

**Used In**: Trending Now carousel widget

---

### 📁 `lib/features/home/domain/repositories/`

#### `home_repository.dart`
**Purpose**: Abstract contract defining data operations

**Interface**:
```dart
abstract class HomeRepository {
  Future<Either<Failure, MarketOverview>> getMarketOverview();
  Future<Either<Failure, List<TrendingCoinEntity>>> getTrendingCoins();
  Future<Either<Failure, List<TopGainerEntity>>> getTopGainers();
  Future<Either<Failure, PortfolioBalance>> getPortfolioBalance();
}
```

**Why Abstract?**:
- Domain defines contract
- Data layer implements it
- Presentation layer uses interface
- Easy to mock for testing
- Can swap implementations

**Either Type**: Functional error handling (Left = Failure, Right = Success)

---

### 📁 `lib/features/home/domain/usecases/`

#### `get_market_overview_usecase.dart`
**Purpose**: Encapsulates the action of fetching market overview

**Class**:
```dart
class GetMarketOverviewUseCase {
  final HomeRepository repository;

  GetMarketOverviewUseCase(this.repository);

  Future<Either<Failure, MarketOverview>> call() async {
    return await repository.getMarketOverview();
  }
}
```

**Single Responsibility**: One use case = one business action

**Call Operator**: Allows `useCase()` syntax

---

#### `get_trending_coins_usecase.dart`
**Purpose**: Fetches trending cryptocurrencies

**Similar structure to market overview use case**

**Used By**: HomeCubit to load trending coins

---

#### `get_top_gainers_usecase.dart`
**Purpose**: Fetches top gaining cryptocurrencies

**Similar structure to market overview use case**

**Used By**: HomeCubit to load top gainers

---

#### `get_portfolio_balance_usecase.dart`
**Purpose**: Fetches user's portfolio balance

**Similar structure to market overview use case**

**Used By**: HomeCubit to load portfolio data

---

## Presentation Layer Files

### 📁 `lib/features/home/presentation/cubit/`

#### `home_state.dart`
**Purpose**: Defines all possible states for home screen

**States**:

1. **`HomeInitial`** - Default state when cubit is created
   ```dart
   class HomeInitial extends HomeState {}
   ```

2. **`HomeLoading`** - Data is being fetched
   ```dart
   class HomeLoading extends HomeState {}
   ```

3. **`HomeLoaded`** - Data successfully loaded
   ```dart
   class HomeLoaded extends HomeState {
     final MarketOverview marketOverview;
     final List<TrendingCoinEntity> trendingCoins;
     final List<TopGainerEntity> topGainers;
     final PortfolioBalance portfolioBalance;
   }
   ```

4. **`HomeError`** - Data fetch failed
   ```dart
   class HomeError extends HomeState {
     final String message;
   }
   ```

**State Transitions**:
```
HomeInitial → HomeLoading → HomeLoaded
                         ↘ HomeError
```

---

#### `home_cubit.dart`
**Purpose**: Manages business logic and state for home screen

**Dependencies** (injected via constructor):
```dart
final GetMarketOverviewUseCase getMarketOverviewUseCase;
final GetTrendingCoinsUseCase getTrendingCoinsUseCase;
final GetTopGainersUseCase getTopGainersUseCase;
final GetPortfolioBalanceUseCase getPortfolioBalanceUseCase;
```

**Key Methods**:

1. **`loadHomeData()`** - Fetches all home screen data
   ```dart
   Future<void> loadHomeData() async {
     emit(HomeLoading());

     // Execute all use cases in parallel
     final results = await Future.wait([
       getMarketOverviewUseCase(),
       getTrendingCoinsUseCase(),
       getTopGainersUseCase(),
       getPortfolioBalanceUseCase(),
     ]);

     // Check results with fold pattern
     // Emit HomeLoaded or HomeError
   }
   ```

2. **`refreshHomeData()`** - Triggered by pull-to-refresh
   ```dart
   Future<void> refreshHomeData() async {
     await loadHomeData();
   }
   ```

**Parallel Execution**: Uses `Future.wait()` for better performance

**Error Handling**: Any failure emits `HomeError` immediately

---

### 📁 `lib/features/home/presentation/screens/`

#### `home_screen.dart`
**Purpose**: Main screen widget for home feature

**Structure**:
```dart
class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: const HomeScreenContent(),
    );
  }
}
```

**`HomeScreenContent`** - Stateless widget with BlocBuilder
```dart
class HomeScreenContent extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) return LoadingIndicator();
            if (state is HomeError) return ErrorWidget();
            if (state is HomeLoaded) return LoadedContent();
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

**LoadedContent Structure**:
```dart
RefreshIndicator(
  onRefresh: () => cubit.refreshHomeData(),
  child: SingleChildScrollView(
    child: Column(
      children: [
        HomeHeader(),           // Greeting + profile
        BalanceCard(),          // Portfolio balance
        SectionTitle("Market Overview"),
        MarketOverviewGrid(),   // Market stats
        SectionTitle("Trending Now"),
        TrendingNowList(),      // Trending coins
        SectionTitle("Top Gainers"),
        TopGainersList(),       // Top gainers
      ],
    ),
  ),
)
```

**Key Features**:
- Pull-to-refresh with `RefreshIndicator`
- Scrollable content with `SingleChildScrollView`
- Error state with retry button
- Loading state with `CircularProgressIndicator`

---

### 📁 `lib/features/home/presentation/widgets/`

Detailed widget documentation is in [WIDGET_GUIDE.md](./WIDGET_GUIDE.md).

**Widget List**:
- `home_header.dart` - Greeting and profile button
- `balance_card.dart` - Portfolio balance display
- `market_overview_grid.dart` - Market statistics grid
- `section_title.dart` - Section headers
- `view_all.dart` - "View All" link button
- `trending_now_list.dart` - Horizontal trending coins carousel
- `top_gainers_list.dart` - Vertical top gainers list
- `top_gainer_tile.dart` - Single top gainer item
- `crypto_item_tile.dart` - Generic crypto item (if exists)

---

## Generated Files

### `*.g.dart` Files

Generated by `build_runner` using annotations from:
- `json_serializable` - For JSON serialization
- `retrofit_generator` - For API service implementation

**Examples**:
- `global_data_model.g.dart` - JSON serialization for GlobalDataModel
- `top_gainer_model.g.dart` - JSON serialization for TopGainerModel
- `trending_coin_model.g.dart` - JSON serialization for TrendingCoinsModel
- `home_api_service.g.dart` - Retrofit implementation of HomeApiService

**How They Work**:
```dart
// Original model
@JsonSerializable()
class TopGainerModel {
  final String id;
  // ...
}

// Generated code
TopGainerModel _$TopGainerModelFromJson(Map<String, dynamic> json) =>
    TopGainerModel(
      id: json['id'] as String,
      // ...
    );

Map<String, dynamic> _$TopGainerModelToJson(TopGainerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      // ...
    };
```

**Regenerate**: `flutter pub run build_runner build --delete-conflicting-outputs`

---

## File Dependencies Diagram

```
home_screen.dart
    ↓
home_cubit.dart
    ↓
[Use Cases] ← (Injected via GetIt)
    ↓
home_repository.dart (interface)
    ↑ (implements)
home_repository_impl.dart
    ↓
home_api_service.dart
    ↓
[Models] → [Entities]
```

---

## Summary

**Total Files by Layer**:
- **Data Layer**: 7 files (3 models + 1 service + 1 repository + 2 generated)
- **Domain Layer**: 8 files (4 entities + 1 repository interface + 4 use cases)
- **Presentation Layer**: 10+ files (1 cubit + 1 state + 1 screen + 8+ widgets)

**Generated Files**: 4 files (auto-generated, don't edit manually)

This structure provides clear separation, testability, and maintainability!
