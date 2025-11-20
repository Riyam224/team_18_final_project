import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'api_base_url.dart';

class DioClient {
  // Load API key from environment variables
  static String get _apiKey => dotenv.env['COINGECKO_API_KEY'] ?? '';

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

    // API Key Interceptor (adds CoinGecko API key header)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ensure API key is always present from environment
          final apiKey = _apiKey;
          if (apiKey.isEmpty) {
            if (kDebugMode) {
              print('⚠️ [DioClient] Warning: COINGECKO_API_KEY not found in .env file');
            }
          }
          options.headers['x-cg-demo-api-key'] = apiKey;

          if (kDebugMode) {
            print('🌐 [DioClient] Request → ${options.method} ${options.uri}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('✅ [DioClient] Response → ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('❌ [DioClient] Error → ${error.response?.statusCode} ${error.requestOptions.uri}');
            print('❌ [DioClient] Message → ${error.message}');
          }

          // Handle specific CoinGecko API errors
          if (error.response?.statusCode == 429) {
            if (kDebugMode) {
              print('⚠️ Rate limit exceeded. Please wait before making more requests.');
            }
          } else if (error.response?.statusCode == 401) {
            if (kDebugMode) {
              print('🚫 Unauthorized. API key might be invalid or missing.');
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Debug Logging Interceptor (only in debug mode)
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => print('🔹 $obj'),
        ),
      );
    }

    return dio;
  }
}
