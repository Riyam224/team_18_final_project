# Portfolio Feature Documentation

## Overview
A cryptocurrency portfolio tracker with real-time pricing, allocation charts, and historical data. Built with Clean Architecture and BLoC pattern using the CoinGecko API.

**Key Features:**
- 📊 Real-time portfolio value with 24h change tracking
- 🥧 Asset allocation donut chart
- 📈 Historical price data (30-180 days)
- 💼 Holdings management with live price updates
- 📜 Transaction history display

---

## Architecture

### Clean Architecture Layers
```
Presentation → Domain → Data
```

- **Presentation**: Screens, widgets, BLoC cubits
- **Domain**: Business entities, repository contracts, use cases
- **Data**: API services, local data sources, repository implementations

### Core Components

**Data Layer:**
- `PortfolioApiService` - Retrofit client for CoinGecko API
- `PortfolioRemoteDataSource` - Handles API calls
- `PortfolioLocalDataSource` - Manages local holdings data
- `PortfolioRepositoryImpl` - Combines remote/local data with caching
- `MarketChartMapper` - Safely converts API models to domain entities
- `MarketChartModel` - API response model with null-safe parsing

**Domain Layer:**
- `PortfolioHolding` - Individual asset entity
- `PortfolioOverview` - Complete portfolio snapshot with division by zero protection
- `MarketChart` - Historical price data entity with null-safe calculations
- `GetPortfolioOverviewUseCase` - Business logic orchestration

**Presentation Layer:**
- `PortfolioCubit` - State management
- `PortfolioScreen` - Main UI
- Custom widgets: `AllocationChart`, `HoldingCard`, `MonthSelector`

---

## API Integration

**Base URL:** `https://api.coingecko.com/api/v3`

**Endpoints:**
- `/simple/price` - Current prices with 24h change
- `/coins/{id}/market_chart` - Historical price data

**Error Handling:**
- Automatic retry on network errors
- Cached data fallback
- User-friendly error messages

---

## State Management

### Portfolio State
```dart
PortfolioState {
  bool isLoading;
  String? error;
  String totalValue;
  String changeLabel;
  List<AllocationSegment> allocations;
  List<HoldingViewData> holdings;
}
```

### Data Flow
```
User Action → Cubit → UseCase → Repository → Remote/Local Sources
                ↓
        State Update → UI Rebuild
```

---

## Key Calculations

### Portfolio Metrics
```dart
// Individual holding value
valueUsd = amount * priceUsd

// Total portfolio value
totalValue = Σ(all holdings.valueUsd)

// 24h change in USD
changeUsd = valueUsd * (changePercent24h / 100)
totalChangeUsd = Σ(all holdings.changeUsd)

// Weighted portfolio change % (with division by zero protection)
previousValue = totalValue - totalChangeUsd
if (totalValue == 0 || previousValue == 0) {
  totalChangePercent = 0
} else {
  totalChangePercent = (totalChangeUsd / previousValue) * 100
}

// Asset allocation %
allocationPercent = (holding.valueUsd / totalValue) * 100
```

### Market Chart Calculations (Null-Safe)

```dart
// All methods return null when data is unavailable (empty prices)
averagePrice = prices.isEmpty ? null : Σ(prices) / count
latestPrice = prices.isEmpty ? null : prices.last
earliestPrice = prices.isEmpty ? null : prices.first

// Price change with null safety and division by zero check
if (latestPrice == null || earliestPrice == null || earliestPrice == 0) {
  priceChangePercent = null
} else {
  priceChangePercent = ((latestPrice - earliestPrice) / earliestPrice) * 100
}
```

---

## Safety & Error Handling

### Division by Zero Protection

**PortfolioOverview.totalChangePercent:**
- Checks if `totalValue == 0` before calculation
- Checks if `previousValue == 0` to prevent division errors
- Returns `0.0` instead of crashing when denominator is zero

**MarketChart.priceChangePercent:**
- Validates `earliestPrice != 0` before division
- Returns `null` when calculation is impossible
- Prevents crashes from invalid or missing data

### Null Safety Implementation

**MarketChart Entity:**

- All getters return `double?` (nullable) instead of `double`
- Returns `null` when `prices.isEmpty` rather than `0`
- Distinguishes between "no data" (null) vs "zero value" (0)
- Example: `averagePrice`, `latestPrice`, `earliestPrice` all return `null` for empty data

**MarketChartModel Safe Parsing:**

```dart
// safeParse() handles invalid API responses gracefully
- Returns empty list if data is not a List
- Filters out non-List and non-num elements
- Provides default [0, 0] for malformed entries
- Applies to prices, marketCaps, and totalVolumes
```

**Benefits:**
- No runtime crashes from division by zero
- Clear semantic difference between "no data" and "zero value"
- Graceful degradation when API returns unexpected data
- Type-safe null handling throughout the feature

---

## UI Components

### Main Screen Sections
1. **Header** - Portfolio title
2. **Total Value Card** - Displays total value and 24h change
3. **Month Selector** - Switch between time periods (30-180 days)
4. **Allocation Chart** - Visual breakdown by asset
5. **Holdings List** - Detailed view of each asset
6. **Recent Transactions** - Transaction history

### Custom Widgets
- `AllocationChart` - Custom painted donut chart
- `HoldingCard` - Asset details with price/change
- `MonthSelector` - Time period chips
- `TotalValueCard` - Portfolio summary
- `TransactionTile` - Transaction item

---

## Testing

### Test Coverage
All portfolio tests pass with comprehensive coverage:

**Unit Tests:**
- ✅ Domain entities (holdings, overview)
- ✅ Use cases
- ✅ Repository implementation

**Integration Tests:**
- ✅ Cubit state management
- ✅ Screen rendering
- ✅ User interactions

**Run Tests:**
```bash
flutter test test/features/portfolio/
```

### Test Helpers
- `TestPortfolioData` - Mock data fixtures
- `FakePortfolioRepository` - Controllable test repository
- `TestDiInitializer` - Dependency injection for tests

---

## What We Implemented

### Core Features
1. **Portfolio Overview** - Real-time crypto portfolio tracking
2. **Live Pricing** - Integration with CoinGecko API for current prices
3. **Historical Data** - 30, 60, 90, 120, 150, and 180-day historical views
4. **Asset Allocation** - Visual representation with donut chart
5. **Holdings Management** - Track multiple cryptocurrencies
6. **Transaction History** - Display recent buy/sell transactions

### Technical Achievements
1. **Clean Architecture** - Proper separation of concerns
2. **BLoC Pattern** - Predictable state management
3. **Error Handling** - Graceful fallbacks and user feedback
4. **Caching Strategy** - Offline support with cached data
5. **Responsive UI** - Adaptive layouts for different screen sizes
6. **Type Safety** - Full null safety implementation
7. **Testability** - 100% test pass rate with comprehensive coverage
8. **API Integration** - Retrofit with Dio for robust networking

### Code Quality
- ✅ Follows Flutter best practices
- ✅ Consistent naming conventions
- ✅ Proper error handling
- ✅ Comprehensive testing
- ✅ Clean, readable code
- ✅ Type-safe throughout

---

## Project Structure

```
lib/features/portfolio/
├── data/
│   ├── datasources/
│   │   ├── portfolio_api_service.dart
│   │   ├── portfolio_remote_data_source.dart
│   │   ├── portfolio_local_data_source.dart
│   │   └── transaction_local_data_source.dart
│   ├── models/
│   │   ├── simple_price_model.dart
│   │   └── market_chart_model.dart
│   ├── mappers/
│   │   └── market_chart_mapper.dart
│   └── repositories/
│       └── portfolio_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── portfolio_holding.dart
│   │   ├── portfolio_overview.dart
│   │   └── transaction.dart
│   ├── repositories/
│   │   └── portfolio_repository.dart
│   └── usecases/
│       └── get_portfolio_overview_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── portfolio_cubit.dart
    │   └── portfolio_state.dart
    ├── portfolio_utils/
    │   ├── app_portfolio_colors.dart
    │   └── app_portfolio_constants.dart
    ├── screens/
    │   └── portfolio_screen.dart
    └── widgets/
        ├── allocation_chart.dart
        ├── holding_card.dart
        ├── month_selector.dart
        ├── total_value_card.dart
        └── transaction_tile.dart
```

---

## Dependency Injection

Registered in `lib/core/di/di.dart`:

```dart
// Network
sl.registerLazySingleton<Dio>(() => DioClient.createDio());

// API Service
sl.registerLazySingleton(() => PortfolioApiService(sl()));

// Data Sources
sl.registerLazySingleton(() => PortfolioLocalDataSource());
sl.registerLazySingleton(() => PortfolioRemoteDataSource(api: sl()));

// Repository
sl.registerLazySingleton<PortfolioRepository>(
  () => PortfolioRepositoryImpl(remote: sl(), local: sl()),
);

// Use Case
sl.registerFactory(() => GetPortfolioOverviewUseCase(repository: sl()));

// Cubit
sl.registerFactory(() => PortfolioCubit(getPortfolioOverview: sl()));
```

---

## Common Tasks

### Add a New Cryptocurrency
1. Update `portfolio_local_data_source.dart` with initial holdings
2. Add color/icon mapping in `app_portfolio_colors.dart`
3. Ensure CoinGecko ID matches their API

### Modify Time Periods
Edit `app_portfolio_constants.dart`:
```dart
static const Map<int, int> monthIndexToDays = {
  0: 30,   // 1 month
  1: 60,   // 2 months
  // Add more as needed
};
```

### Change Initial Route
Update `lib/core/routing/app_router.dart`:
```dart
initialLocation: AppRoutes.portfolio
```

---

## Summary

The portfolio feature is a production-ready cryptocurrency portfolio tracker with:
- **Clean, maintainable code** following industry best practices
- **Robust architecture** supporting easy extension and testing
- **Real-world API integration** with proper error handling
- **Professional UI/UX** with smooth interactions
- **Comprehensive test coverage** ensuring reliability

All tests pass successfully, the code is well-structured, and the feature is ready for production use.
