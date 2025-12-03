// Imports Dio HTTP client for making network requests
import 'package:dio/dio.dart';
// Imports foundation library to check if app is running in debug mode
import 'package:flutter/foundation.dart';
// Imports environment configuration for API keys and secrets
import 'package:team_18_final_project/core/config/env_config.dart';
import 'package:team_18_final_project/core/config/network_config.dart';
import 'package:team_18_final_project/core/config/timing_config.dart';
// Imports API base URL constants
import 'api_base_url.dart';

/// DioClient is a factory class that creates and configures Dio HTTP client instances
/// It sets up interceptors for API key injection, logging, and error handling
/// This centralized configuration ensures consistent network behavior across the app
class DioClient {
  /// Private getter to retrieve the CoinGecko API key from environment configuration
  /// API key is loaded at compile-time using --dart-define
  /// Returns empty string if no API key is provided (app will still work with limited features)
  static String get _apiKey => EnvConfig.coinGeckoApiKey;

  /// Factory method to create a configured Dio instance
  /// This method sets up all necessary interceptors and configuration for API communication
  /// Returns: A fully configured Dio instance ready for making HTTP requests
  static Dio createDio() {
    // Create Dio instance with base configuration
    final dio = Dio(
      BaseOptions(
        // Base URL for all API requests (e.g., https://api.coingecko.com/api/v3)
        baseUrl: ApiConstants.baseUrl,

        // Maximum time to wait for connection to be established
        // Prevents app from hanging if server is unreachable
        connectTimeout: TimingConfig.connectionTimeout,

        // Maximum time to wait for server to send response data
        // Prevents app from hanging if server is slow to respond
        receiveTimeout: TimingConfig.receiveTimeout,

        // Default headers sent with every request
        headers: {
          // Tell server we accept JSON responses
          NetworkConfig.acceptHeader: NetworkConfig.acceptValue,

          // CoinGecko API key header for authentication
          // Required for higher rate limits and full API access
          NetworkConfig.apiKeyHeader: _apiKey,
        },
      ),
    );

    // ============================================================
    // INTERCEPTOR 1: API Key Injection and Request/Response Logging
    // ============================================================
    // Interceptors are middleware that can modify requests/responses
    // or perform actions before/after HTTP calls
    dio.interceptors.add(
      InterceptorsWrapper(
        // onRequest: Called before every HTTP request is sent
        // Allows us to modify the request or add headers
        onRequest: (options, handler) async {
          // Retrieve API key from environment
          final apiKey = _apiKey;

          if (apiKey.isEmpty && kDebugMode) {
            debugPrint(NetworkConfig.apiKeyNotFoundWarning);
          }

          // Inject API key into request headers
          // This ensures every request has the API key, even if config changes
          options.headers[NetworkConfig.apiKeyHeader] = apiKey;

          if (kDebugMode) {
            debugPrint('${NetworkConfig.requestLogPrefix} ${options.method} ${options.uri}');
          }

          // Pass request to next interceptor or send it
          // handler.next() continues the request chain
          return handler.next(options);
        },

        // onResponse: Called after receiving successful response (status 200-299)
        // Allows us to process or log the response before it reaches the caller
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
                '${NetworkConfig.responseLogPrefix} ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },

        // onError: Called when request fails or server returns error (status 400+)
        // Allows us to handle errors globally before they reach individual API calls
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
                '${NetworkConfig.errorLogPrefix} ${error.response?.statusCode} ${error.requestOptions.uri}');
            debugPrint('${NetworkConfig.messageLogPrefix} ${error.message}');
          }

          if (error.response?.statusCode == NetworkConfig.statusTooManyRequests) {
            if (kDebugMode) {
              debugPrint('${NetworkConfig.warningLogPrefix} ${NetworkConfig.rateLimitExceeded}');
            }
          } else if (error.response?.statusCode == NetworkConfig.statusUnauthorized) {
            if (kDebugMode) {
              debugPrint('${NetworkConfig.unauthorizedLogPrefix} ${NetworkConfig.unauthorizedRequest}');
            }
          }

          return handler.next(error);
        },
      ),
    );

    // ============================================================
    // INTERCEPTOR 2: Detailed Logging (Debug Mode Only)
    // ============================================================
    // LogInterceptor provides detailed logging of HTTP traffic
    // Only enabled in debug builds to avoid performance overhead in production
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          // Log the request details (URL, method, etc.)
          request: true,

          // Log all request headers (including API key, content-type, etc.)
          requestHeader: true,

          // Log request body (useful for POST/PUT requests with JSON data)
          requestBody: true,

          // Don't log response headers (reduces console clutter)
          // Set to true if you need to debug response headers
          responseHeader: false,

          // Log response body (the actual JSON data returned by API)
          // Useful for debugging API responses
          responseBody: true,

          // Log error details when requests fail
          error: true,

          logPrint: (obj) => debugPrint('${NetworkConfig.detailsLogPrefix} $obj'),
        ),
      );
    }

    // Return the fully configured Dio instance
    // This instance can now be used by API services (e.g., HomeApiService)
    return dio;
  }
}
