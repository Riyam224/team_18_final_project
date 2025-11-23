// Imports Dio HTTP client for making network requests
import 'package:dio/dio.dart';
// Imports foundation library to check if app is running in debug mode
import 'package:flutter/foundation.dart';
// Imports environment configuration for API keys and secrets
import 'package:team_18_final_project/core/config/env_config.dart';
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

        // Maximum time to wait for connection to be established (30 seconds)
        // Prevents app from hanging if server is unreachable
        connectTimeout: const Duration(seconds: 30),

        // Maximum time to wait for server to send response data (30 seconds)
        // Prevents app from hanging if server is slow to respond
        receiveTimeout: const Duration(seconds: 30),

        // Default headers sent with every request
        headers: {
          // Tell server we accept JSON responses
          'Accept': 'application/json',

          // CoinGecko API key header for authentication
          // Required for higher rate limits and full API access
          'x-cg-demo-api-key': _apiKey,
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

          // Check if API key is missing and warn developer
          if (apiKey.isEmpty) {
            // kDebugMode is true only in debug builds (not in release)
            if (kDebugMode) {
              print('⚠️ [DioClient] Warning: COINGECKO_API_KEY not found in .env file');
            }
          }

          // Inject API key into request headers
          // This ensures every request has the API key, even if config changes
          options.headers['x-cg-demo-api-key'] = apiKey;

          // Log outgoing request details (only in debug mode)
          if (kDebugMode) {
            // Print HTTP method (GET, POST, etc.) and full URL
            print('🌐 [DioClient] Request → ${options.method} ${options.uri}');
          }

          // Pass request to next interceptor or send it
          // handler.next() continues the request chain
          return handler.next(options);
        },

        // onResponse: Called after receiving successful response (status 200-299)
        // Allows us to process or log the response before it reaches the caller
        onResponse: (response, handler) {
          // Log successful response (only in debug mode)
          if (kDebugMode) {
            // Print status code (e.g., 200, 201) and requested URL
            print('✅ [DioClient] Response → ${response.statusCode} ${response.requestOptions.uri}');
          }

          // Pass response to next interceptor or return it to caller
          return handler.next(response);
        },

        // onError: Called when request fails or server returns error (status 400+)
        // Allows us to handle errors globally before they reach individual API calls
        onError: (error, handler) {
          // Log error details (only in debug mode)
          if (kDebugMode) {
            // Print HTTP error code (e.g., 404, 500) and URL that failed
            print('❌ [DioClient] Error → ${error.response?.statusCode} ${error.requestOptions.uri}');
            // Print error message from Dio
            print('❌ [DioClient] Message → ${error.message}');
          }

          // Handle specific CoinGecko API errors with user-friendly messages

          // 429 = Too Many Requests (rate limit exceeded)
          if (error.response?.statusCode == 429) {
            if (kDebugMode) {
              print('⚠️ Rate limit exceeded. Please wait before making more requests.');
            }
          }
          // 401 = Unauthorized (invalid or missing API key)
          else if (error.response?.statusCode == 401) {
            if (kDebugMode) {
              print('🚫 Unauthorized. API key might be invalid or missing.');
            }
          }

          // Pass error to next interceptor or throw it to caller
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

          // Custom log print function (adds 🔹 emoji for easy identification)
          // obj is the log message (string) to be printed
          logPrint: (obj) => print('🔹 $obj'),
        ),
      );
    }

    // Return the fully configured Dio instance
    // This instance can now be used by API services (e.g., HomeApiService)
    return dio;
  }
}
