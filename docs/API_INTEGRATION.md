# API Integration Guide

This document explains how the app integrates with the CoinGecko API for cryptocurrency data.

## Table of Contents
1. [API Overview](#api-overview)
2. [Network Configuration](#network-configuration)
3. [Endpoints](#endpoints)
4. [Data Flow](#data-flow)
5. [Error Handling](#error-handling)
6. [Caching Strategy](#caching-strategy)

---

## API Overview

### Provider: CoinGecko API
**Base URL**: `https://api.coingecko.com/api/v3`

**Why CoinGecko?**
- Free tier available (no API key required for basic features)
- Comprehensive cryptocurrency data
- Reliable and well-documented
- Real-time market data
- Trending coins based on search volume

**Rate Limits**:
- Free tier: ~10-30 requests/minute
- This app uses caching to minimize API calls

---

## Network Configuration

### Dio HTTP Client Setup

**Location**: `lib/core/networking/` (assumed)

**Basic Configuration**:
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.coingecko.com/api/v3',
  connectTimeout: Duration(seconds: 30),
  receiveTimeout: Duration(seconds: 30),
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
));
```

**Interceptors** (if configured):
- Logging interceptor for debugging
- Error handling interceptor
- Token refresh interceptor (if needed)

### Retrofit Integration

**Purpose**: Type-safe REST client with compile-time code generation

**Setup in** `home_api_service.dart`:
```dart
@RestApi()
abstract class HomeApiService {
  factory HomeApiService(Dio dio, {String baseUrl}) = _HomeApiService;

  @GET('/global')
  Future<GlobalDataModel> getGlobalData();

  // More endpoints...
}
```

**Generated Implementation** (`home_api_service.g.dart`):
- Handles request building
- Automatic JSON serialization/deserialization
- Type-safe response handling

---

## Endpoints

### 1. Global Market Data

**Endpoint**: `GET /global`

**Purpose**: Fetch global cryptocurrency market statistics

**Request**:
```http
GET https://api.coingecko.com/api/v3/global
Accept: application/json
```

**Response Structure**:
```json
{
  "data": {
    "active_cryptocurrencies": 13847,
    "upcoming_icos": 0,
    "ongoing_icos": 49,
    "ended_icos": 3376,
    "markets": 1098,
    "total_market_cap": {
      "usd": 2100000000000,
      "eur": 1950000000000,
      "btc": 45123.45
    },
    "total_volume": {
      "usd": 98500000000,
      "eur": 91200000000,
      "btc": 2134.56
    },
    "market_cap_percentage": {
      "btc": 52.34,
      "eth": 16.82,
      "usdt": 6.23
    },
    "market_cap_change_percentage_24h_usd": 1.23,
    "updated_at": 1704067200
  }
}
```

**Used For**:
- Market Overview (market cap, volume, BTC dominance)
- Portfolio Balance (market change percentage)

**Caching**: Yes (30 seconds)

---

### 2. Trending Coins

**Endpoint**: `GET /search/trending`

**Purpose**: Get coins currently trending on CoinGecko (based on search volume)

**Request**:
```http
GET https://api.coingecko.com/api/v3/search/trending
Accept: application/json
```

**Response Structure**:
```json
{
  "coins": [
    {
      "item": {
        "id": "bitcoin",
        "coin_id": 1,
        "name": "Bitcoin",
        "symbol": "BTC",
        "market_cap_rank": 1,
        "thumb": "https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png",
        "small": "https://assets.coingecko.com/coins/images/1/small/bitcoin.png",
        "large": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
        "slug": "bitcoin",
        "price_btc": 1.0,
        "score": 0,
        "data": {
          "price": "$45,123.45",
          "price_btc": "1.0",
          "price_change_percentage_24h": {
            "usd": 3.45,
            "btc": 0.0
          },
          "market_cap": "$850,000,000,000",
          "total_volume": "$35,000,000,000"
        }
      }
    }
    // ... more coins
  ]
}
```

**Key Fields**:
- `coins` - Array of trending coin items
- `item` - Nested coin object
- `data.price` - Can be string or number
- `score` - Trending score (higher = more popular)

**Used For**: Trending Now carousel

**Caching**: No

---

### 3. Top Gainers (Market Data)

**Endpoint**: `GET /coins/markets`

**Purpose**: Get market data for cryptocurrencies sorted by market cap

**Request**:
```http
GET https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc
Accept: application/json
```

**Query Parameters**:
- `vs_currency=usd` - Price currency
- `order=market_cap_desc` - Sort by market cap descending

**Response Structure** (Array):
```json
[
  {
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
    "current_price": 45123.45,
    "market_cap": 850000000000,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 950000000000,
    "total_volume": 35000000000,
    "high_24h": 46000.00,
    "low_24h": 44000.00,
    "price_change_24h": 1234.56,
    "price_change_percentage_24h": 2.81,
    "market_cap_change_24h": 25000000000,
    "market_cap_change_percentage_24h": 3.03,
    "circulating_supply": 19600000,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 69000.00,
    "ath_change_percentage": -34.62,
    "ath_date": "2021-11-10T14:24:11.849Z",
    "atl": 67.81,
    "atl_change_percentage": 66444.56,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "last_updated": "2024-01-01T12:00:00.000Z"
  }
  // ... more coins
]
```

**Processing**:
1. Fetch all coins
2. Filter where `price_change_percentage_24h > 0`
3. Sort by `price_change_percentage_24h` descending
4. Take top 10

**Used For**: Top Gainers list

**Caching**: No

---

## Data Flow

### Complete Request-Response Cycle

```
┌──────────────────────────────────────────────────────────────┐
│  1. UI Event (User opens app / Pull to refresh)             │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  2. HomeCubit.loadHomeData()                                 │
│     - Emits HomeLoading state                                │
│     - Executes all use cases in parallel                     │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  3. Use Cases (4 parallel calls)                             │
│     - GetMarketOverviewUseCase()                             │
│     - GetTrendingCoinsUseCase()                              │
│     - GetTopGainersUseCase()                                 │
│     - GetPortfolioBalanceUseCase()                           │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  4. HomeRepository (checks cache for global data)            │
│     - Market overview: Uses cached global data               │
│     - Trending: Fresh API call                               │
│     - Top gainers: Fresh API call                            │
│     - Portfolio: Uses cached global data                     │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  5. HomeApiService (Retrofit)                                │
│     - Builds HTTP requests                                   │
│     - Sends to Dio client                                    │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  6. Dio (HTTP Client)                                        │
│     - GET /global                                            │
│     - GET /search/trending                                   │
│     - GET /coins/markets                                     │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  7. CoinGecko API                                            │
│     - Processes requests                                     │
│     - Returns JSON responses                                 │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  8. JSON Deserialization (auto-generated)                    │
│     - GlobalDataModel.fromJson()                             │
│     - TrendingCoinsModel.fromJson()                          │
│     - List<TopGainerModel>.fromJson()                        │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│  9. HomeRepository (Data transformation)                     │
│     - Model → Entity mapping                                 │
│     - Currency formatting                                    │
│     - Data filtering/sorting                                 │
│     - Wrap in Either (Success/Failure)                       │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│ 10. Use Cases return Either<Failure, Data>                   │
│     - Right(entity) for success                              │
│     - Left(failure) for errors                               │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│ 11. HomeCubit processes results                              │
│     - Checks all Either results with fold()                  │
│     - If any failed: emit HomeError                          │
│     - If all succeeded: emit HomeLoaded                      │
└──────────────────────────────────────────────────────────────┘
                            ↓
┌──────────────────────────────────────────────────────────────┐
│ 12. UI Updates (BlocBuilder rebuilds)                        │
│     - HomeLoaded → Show data                                 │
│     - HomeError → Show error with retry                      │
└──────────────────────────────────────────────────────────────┘
```

**Total Time**: ~1-3 seconds (with parallel requests)

---

## Error Handling

### Error Types

1. **Network Errors**
   - No internet connection
   - Timeout
   - DNS resolution failure

2. **HTTP Errors**
   - 4xx Client errors (bad request, not found)
   - 5xx Server errors (server down, maintenance)
   - 429 Rate limit exceeded

3. **Parsing Errors**
   - Invalid JSON
   - Missing required fields
   - Type mismatch

### Error Handler

**Location**: `lib/core/networking/api_error_handler.dart` (assumed)

**Example Implementation**:
```dart
class ApiErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please try again.';

        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network.';

        case DioExceptionType.badResponse:
          return _handleHttpError(error.response?.statusCode);

        default:
          return 'Something went wrong. Please try again.';
      }
    }
    return error.toString();
  }

  static String _handleHttpError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please try again.';
      case 404:
        return 'Data not found.';
      case 429:
        return 'Too many requests. Please wait a moment.';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'An error occurred (Code: $statusCode).';
    }
  }
}
```

### Repository Error Handling

**Pattern**:
```dart
Future<Either<Failure, MarketOverview>> getMarketOverview() async {
  try {
    final data = await _apiService.getGlobalData();
    final entity = _mapToEntity(data);
    return Right(entity);  // Success
  } catch (e) {
    final errorMessage = ApiErrorHandler.handleError(e);
    return Left(ServerFailure(message: errorMessage));  // Failure
  }
}
```

### UI Error Display

**In HomeScreen**:
```dart
if (state is HomeError) {
  return Column(
    children: [
      Text('Error: ${state.message}'),
      ElevatedButton(
        onPressed: () => cubit.refreshHomeData(),
        child: Text('Retry'),
      ),
    ],
  );
}
```

---

## Caching Strategy

### Global Data Caching

**Why Cache?**
- Market overview and portfolio balance use same API endpoint
- Reduces redundant API calls
- Improves performance
- Respects rate limits

**Implementation**:
```dart
class HomeRepositoryImpl {
  dynamic _cachedGlobalData;
  DateTime? _cacheTimestamp;
  static const _cacheDuration = Duration(seconds: 30);

  Future<dynamic> _getGlobalDataCached() async {
    final now = DateTime.now();

    // Check cache validity
    if (_cachedGlobalData != null &&
        _cacheTimestamp != null &&
        now.difference(_cacheTimestamp!) < _cacheDuration) {
      print('Using cached global data');
      return _cachedGlobalData;
    }

    // Fetch fresh data
    print('Fetching fresh global data');
    final response = await _apiService.getGlobalData();
    _cachedGlobalData = response.data;
    _cacheTimestamp = now;

    return _cachedGlobalData;
  }
}
```

**Cache Duration**: 30 seconds
- Short enough for relatively fresh data
- Long enough to avoid excessive API calls
- Good balance for crypto market volatility

**Cache Invalidation**:
- Automatic after 30 seconds
- Manual via pull-to-refresh
- App restart clears cache

### Request Optimization

**Parallel Requests** in `HomeCubit`:
```dart
// Execute all API calls concurrently
final results = await Future.wait([
  getMarketOverviewUseCase(),      // Uses cached global data
  getTrendingCoinsUseCase(),       // Fresh API call
  getTopGainersUseCase(),          // Fresh API call
  getPortfolioBalanceUseCase(),    // Uses cached global data
]);
```

**Benefits**:
- Total time = slowest request (not sum of all)
- Only 3 actual API calls (global data cached for 2 uses)
- Faster app startup

---

## Request/Response Examples

### Example 1: Market Overview Request

**Request**:
```http
GET /global HTTP/1.1
Host: api.coingecko.com
Accept: application/json
```

**Response Processing**:
```dart
// 1. API Response (JSON)
{
  "data": {
    "total_market_cap": {"usd": 2100000000000},
    "total_volume": {"usd": 98500000000},
    "market_cap_percentage": {"btc": 52.34},
    "active_cryptocurrencies": 13847,
    "market_cap_change_percentage_24h_usd": 1.23
  }
}

// 2. Deserialized to Model
GlobalDataModel(
  data: GlobalData(
    totalMarketCap: {'usd': 2100000000000.0},
    totalVolume: {'usd': 98500000000.0},
    marketCapPercentage: {'btc': 52.34},
    activeCryptocurrencies: 13847,
    marketCapChangePercentage24hUsd: 1.23
  )
)

// 3. Mapped to Entity
MarketOverview(
  marketCap: '$2.1T',           // Formatted
  volume24h: '$98.5B',          // Formatted
  btcDominance: '52.3%',        // Formatted
  activeCoins: 13847,
  marketCapChangePercentage: 1.23
)
```

### Example 2: Top Gainers Processing

**Response** (truncated):
```json
[
  {"id": "coin1", "price_change_percentage_24h": 45.2, ...},
  {"id": "coin2", "price_change_percentage_24h": 32.1, ...},
  {"id": "coin3", "price_change_percentage_24h": -5.3, ...},
  {"id": "coin4", "price_change_percentage_24h": 28.7, ...}
]
```

**Processing Steps**:
```dart
// 1. Filter positive changes
filtered = coins.where((c) => c.priceChangePercentage24h > 0)
// Result: [coin1, coin2, coin4]

// 2. Sort descending
sorted = filtered.sort((a, b) => b.priceChange.compareTo(a.priceChange))
// Result: [coin1(45.2%), coin2(32.1%), coin4(28.7%)]

// 3. Take top 10
topGainers = sorted.take(10).toList()

// 4. Map to entities
entities = topGainers.map((model) => TopGainerEntity(...))
```

---

## Testing API Integration

### Mock API Service

```dart
class MockHomeApiService extends Mock implements HomeApiService {}

void main() {
  test('getMarketOverview returns data successfully', () async {
    // Arrange
    final mockApi = MockHomeApiService();
    final mockData = GlobalDataModel(/* ... */);

    when(() => mockApi.getGlobalData())
        .thenAnswer((_) async => mockData);

    final repository = HomeRepositoryImpl(mockApi);

    // Act
    final result = await repository.getMarketOverview();

    // Assert
    expect(result.isRight(), true);
    verify(() => mockApi.getGlobalData()).called(1);
  });
}
```

---

## Summary

**API Endpoints Used**: 3
1. `/global` - Global market data (cached)
2. `/search/trending` - Trending coins
3. `/coins/markets` - Market data for top gainers

**Total API Calls per Load**: 3 (thanks to caching)

**Error Handling**: Comprehensive with user-friendly messages

**Performance**: Optimized with parallel requests and caching

**Reliability**: Retry mechanism and graceful error handling
