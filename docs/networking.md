# Networking Guide

This document explains how networking is implemented in the Team 18 Fintech App, including API configuration, error handling, and best practices for making HTTP requests.

## Overview

The app uses **Dio** as its HTTP client to communicate with the CoinGecko API. The networking layer is centrally configured with interceptors for authentication, logging, and error handling.

## Architecture

### Networking Files Structure

```
lib/core/networking/
├── dio_client.dart           # Dio client factory and configuration
├── api_error_handler.dart    # Error handling and formatting
└── api_base_url.dart         # API endpoint constants

lib/core/config/
└── env_config.dart           # Environment variables and API keys

lib/core/error/
└── auth_error_msg.dart       # Error message constants
```

## Configuration

### API Base URL

Defined in [api_base_url.dart](../lib/core/networking/api_base_url.dart):

```dart
class ApiConstants {
  static const baseUrl = "https://api.coingecko.com/api/v3";
}
```

### Environment Configuration

API keys are managed through [env_config.dart](../lib/core/config/env_config.dart):

```dart
class EnvConfig {
  static const String coinGeckoApiKey = String.fromEnvironment(
    'COINGECKO_API_KEY',
    defaultValue: '',
  );
}
```

#### Setting Up API Keys

To provide API keys at runtime:

```bash
flutter run --dart-define=COINGECKO_API_KEY=your_api_key_here
```

Or add to your IDE run configuration:
- **VS Code**: Add to `launch.json`
- **Android Studio**: Edit run configuration > Additional run args

Get your CoinGecko API key from: https://www.coingecko.com/en/api/pricing

## DioClient

The [DioClient](../lib/core/networking/dio_client.dart) class is a factory that creates configured Dio instances.

### Creating a Dio Instance

```dart
final dio = DioClient.createDio();
```

### Configuration Details

```dart
class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'x-cg-demo-api-key': _apiKey,
        },
      ),
    );

    // Add interceptors...
    return dio;
  }
}
```

#### Base Options

- **baseUrl**: `https://api.coingecko.com/api/v3`
- **connectTimeout**: 30 seconds (connection establishment timeout)
- **receiveTimeout**: 30 seconds (response data timeout)
- **Default Headers**:
  - `Accept: application/json` - Requests JSON responses
  - `x-cg-demo-api-key` - CoinGecko API authentication

## Interceptors

The DioClient configures two interceptors to handle requests and responses.

### 1. Request/Response Logging Interceptor

This interceptor handles:
- API key injection
- Request logging
- Response logging
- Basic error handling

```dart
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Inject API key
      options.headers['x-cg-demo-api-key'] = apiKey;

      // Log outgoing request
      if (kDebugMode) {
        print('🌐 [DioClient] Request → ${options.method} ${options.uri}');
      }

      return handler.next(options);
    },

    onResponse: (response, handler) {
      // Log successful response
      if (kDebugMode) {
        print('✅ [DioClient] Response → ${response.statusCode} ${response.requestOptions.uri}');
      }

      return handler.next(response);
    },

    onError: (error, handler) {
      // Log and handle errors
      if (kDebugMode) {
        print('❌ [DioClient] Error → ${error.response?.statusCode} ${error.requestOptions.uri}');
      }

      // Handle rate limiting
      if (error.response?.statusCode == 429) {
        print('⚠️ Rate limit exceeded.');
      }
      // Handle authentication errors
      else if (error.response?.statusCode == 401) {
        print('🚫 Unauthorized. API key might be invalid.');
      }

      return handler.next(error);
    },
  ),
);
```

### 2. Detailed Debug Logging Interceptor

This interceptor provides detailed HTTP traffic logs in debug mode only:

```dart
if (kDebugMode) {
  dio.interceptors.add(
    LogInterceptor(
      request: true,           // Log request details
      requestHeader: true,     // Log request headers
      requestBody: true,       // Log request body
      responseHeader: false,   // Don't log response headers
      responseBody: true,      // Log response body
      error: true,             // Log errors
      logPrint: (obj) => print('🔹 $obj'),
    ),
  );
}
```

## Error Handling

The [ApiErrorHandler](../lib/core/networking/api_error_handler.dart) class converts Dio exceptions and HTTP errors into user-friendly messages.

### Usage

```dart
try {
  final response = await dio.get('/coins/markets');
  // Handle success
} catch (error) {
  final errorMessage = ApiErrorHandler.handleError(error);
  // Display errorMessage to user
}
```

### Error Types Handled

#### DioException Types

```dart
class ApiErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ErrorMessages.timeout;

        case DioExceptionType.connectionError:
          return ErrorMessages.noInternet;

        case DioExceptionType.cancel:
          return 'Request cancelled by user';

        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);

        default:
          return ErrorMessages.unexpectedError;
      }
    }
    return ErrorMessages.getErrorMessage(error);
  }
}
```

#### HTTP Status Code Handling

```dart
static String _handleBadResponse(Response? response) {
  // Try to extract error message from response body
  final data = response?.data;

  if (data is Map<String, dynamic>) {
    // Check for 'message' field
    if (data.containsKey('message')) return data['message'];

    // Check for structured validation errors
    if (data['errors'] is Map<String, dynamic>) {
      final errors = data['errors'];

      if (errors.containsKey('email')) {
        // Return first email error
      }

      if (errors.containsKey('generalErrors')) {
        // Return first general error
      }
    }
  }

  // Fall back to status code messages
  switch (response?.statusCode) {
    case 400:
      return ErrorMessages.badRequest;
    case 401:
      return ErrorMessages.unauthorized;
    case 403:
      return ErrorMessages.forbidden;
    case 404:
      return ErrorMessages.notFound;
    case 409:
      return ErrorMessages.emailAlreadyExists;
    case 500:
    case 502:
    case 503:
    case 504:
      return ErrorMessages.serverError;
    default:
      return ErrorMessages.unexpectedError;
  }
}
```

### Common Error Messages

The `ErrorMessages` class (from [auth_error_msg.dart](../lib/core/error/auth_error_msg.dart)) provides constants:

- `ErrorMessages.timeout` - Request timeout
- `ErrorMessages.noInternet` - No internet connection
- `ErrorMessages.unauthorized` - Invalid credentials
- `ErrorMessages.forbidden` - Access denied
- `ErrorMessages.notFound` - Resource not found
- `ErrorMessages.badRequest` - Invalid request
- `ErrorMessages.serverError` - Server error (5xx)
- `ErrorMessages.unexpectedError` - Generic error
- `ErrorMessages.emailAlreadyExists` - Duplicate email

## Making API Calls

### Basic GET Request

```dart
class CoinApiService {
  final Dio _dio = DioClient.createDio();

  Future<List<Coin>> getCoins() async {
    try {
      final response = await _dio.get(
        '/coins/markets',
        queryParameters: {
          'vs_currency': 'usd',
          'order': 'market_cap_desc',
          'per_page': 10,
          'page': 1,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Coin.fromJson(json)).toList();
      }

      throw Exception('Failed to load coins');
    } catch (error) {
      final errorMessage = ApiErrorHandler.handleError(error);
      throw Exception(errorMessage);
    }
  }
}
```

### POST Request with Body

```dart
Future<void> submitData(Map<String, dynamic> data) async {
  try {
    final response = await _dio.post(
      '/endpoint',
      data: data,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
    }
  } catch (error) {
    final errorMessage = ApiErrorHandler.handleError(error);
    throw Exception(errorMessage);
  }
}
```

### Request with Custom Headers

```dart
Future<void> authenticatedRequest() async {
  try {
    final response = await _dio.get(
      '/protected-endpoint',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Custom-Header': 'value',
        },
      ),
    );
    // Handle response
  } catch (error) {
    final errorMessage = ApiErrorHandler.handleError(error);
    throw Exception(errorMessage);
  }
}
```

### Request with Query Parameters

```dart
Future<void> searchCoins(String query) async {
  try {
    final response = await _dio.get(
      '/search',
      queryParameters: {
        'query': query,
        'limit': 20,
      },
    );
    // Handle response
  } catch (error) {
    final errorMessage = ApiErrorHandler.handleError(error);
    throw Exception(errorMessage);
  }
}
```

## Best Practices

### 1. Use Dependency Injection

Register Dio client in your DI container:

```dart
// In di.dart
final getIt = GetIt.instance;

void setupDependencies() {
  // Register Dio client
  getIt.registerLazySingleton<Dio>(() => DioClient.createDio());

  // Register API services
  getIt.registerLazySingleton<CoinApiService>(
    () => CoinApiService(getIt<Dio>()),
  );
}
```

### 2. Create Dedicated API Service Classes

Organize API calls by feature:

```dart
class CoinApiService {
  final Dio _dio;

  CoinApiService(this._dio);

  Future<List<Coin>> getCoins() async { /* ... */ }
  Future<CoinDetail> getCoinById(String id) async { /* ... */ }
  Future<List<Market>> getMarkets() async { /* ... */ }
}
```

### 3. Handle Errors Consistently

Always wrap API calls in try-catch and use `ApiErrorHandler`:

```dart
try {
  final response = await _dio.get('/endpoint');
  return parseResponse(response);
} catch (error) {
  final message = ApiErrorHandler.handleError(error);
  throw Exception(message);
}
```

### 4. Use Models for Type Safety

Create data models for API responses:

```dart
class Coin {
  final String id;
  final String name;
  final double currentPrice;

  Coin({required this.id, required this.name, required this.currentPrice});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      name: json['name'],
      currentPrice: (json['current_price'] as num).toDouble(),
    );
  }
}
```

### 5. Implement Retry Logic for Rate Limiting

```dart
Future<Response> retryRequest(Future<Response> Function() request) async {
  int retries = 3;
  int delay = 1000; // milliseconds

  for (int i = 0; i < retries; i++) {
    try {
      return await request();
    } catch (error) {
      if (error is DioException && error.response?.statusCode == 429) {
        if (i < retries - 1) {
          await Future.delayed(Duration(milliseconds: delay));
          delay *= 2; // Exponential backoff
          continue;
        }
      }
      rethrow;
    }
  }

  throw Exception('Max retries exceeded');
}
```

### 6. Cancel Requests When Needed

```dart
class CoinApiService {
  final CancelToken _cancelToken = CancelToken();

  Future<void> getCoins() async {
    try {
      final response = await _dio.get(
        '/coins',
        cancelToken: _cancelToken,
      );
      // Handle response
    } catch (error) {
      if (CancelToken.isCancel(error)) {
        print('Request cancelled');
      }
    }
  }

  void cancelRequests() {
    _cancelToken.cancel('User cancelled');
  }
}
```

## Testing

### Mocking Dio for Tests

```dart
class MockDio extends Mock implements Dio {}

void main() {
  late CoinApiService apiService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    apiService = CoinApiService(mockDio);
  });

  test('getCoins returns list of coins', () async {
    when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
        .thenAnswer((_) async => Response(
              data: [/* mock data */],
              statusCode: 200,
              requestOptions: RequestOptions(path: '/coins/markets'),
            ));

    final coins = await apiService.getCoins();

    expect(coins, isNotEmpty);
  });
}
```

## Logging and Debugging

### Debug Console Output

In debug mode, you'll see detailed logs:

```
🌐 [DioClient] Request → GET https://api.coingecko.com/api/v3/coins/markets
🔹 *** Request ***
🔹 uri: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd
🔹 method: GET
🔹 headers: {Accept: application/json, x-cg-demo-api-key: ...}
✅ [DioClient] Response → 200 https://api.coingecko.com/api/v3/coins/markets
🔹 *** Response ***
🔹 statusCode: 200
🔹 body: [{"id":"bitcoin","name":"Bitcoin"...}]
```

### Rate Limiting Warnings

When rate limit is exceeded:

```
❌ [DioClient] Error → 429 https://api.coingecko.com/api/v3/coins/markets
⚠️ Rate limit exceeded. Please wait before making more requests.
```

### Authentication Warnings

When API key is missing or invalid:

```
⚠️ [DioClient] Warning: COINGECKO_API_KEY not found in .env file
🚫 Unauthorized. API key might be invalid or missing.
```

## Common Issues and Solutions

### Issue: 429 Rate Limit Errors

**Solution**:
- Implement caching
- Add retry logic with exponential backoff
- Upgrade to paid CoinGecko plan

### Issue: Timeout Errors

**Solution**:
- Increase timeout duration
- Check internet connection
- Verify API server status

### Issue: Missing API Key

**Solution**:
- Add API key to environment: `--dart-define=COINGECKO_API_KEY=your_key`
- Get API key from CoinGecko
- App will work with limited features if no key is provided

## Related Files

- [dio_client.dart](../lib/core/networking/dio_client.dart) - Dio configuration
- [api_error_handler.dart](../lib/core/networking/api_error_handler.dart) - Error handling
- [api_base_url.dart](../lib/core/networking/api_base_url.dart) - API constants
- [env_config.dart](../lib/core/config/env_config.dart) - Environment config

## Resources

- [Dio Documentation](https://pub.dev/packages/dio)
- [CoinGecko API Documentation](https://www.coingecko.com/en/api/documentation)
- [Flutter HTTP Best Practices](https://flutter.dev/docs/cookbook/networking)
