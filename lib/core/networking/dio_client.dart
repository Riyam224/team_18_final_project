import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:team_18_final_project/core/config/api_config.dart';
import 'package:team_18_final_project/core/config/env_config.dart';
import 'package:team_18_final_project/core/constants/api_constants.dart';

class DioClient {
  static String get _apiKey => EnvConfig.coinGeckoApiKey;

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiBaseUrl.coingecko,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          ApiHeaders.contentType: ApiHeaders.applicationJson,
          ApiConfig.headerApiKey: _apiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final apiKey = _apiKey;
          if (apiKey.isEmpty) {
            if (kDebugMode) {
              print('⚠️ [DioClient] Warning: COINGECKO_API_KEY not found in .env file');
            }
          }
          options.headers[ApiConfig.headerApiKey] = apiKey;

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

          if (error.response?.statusCode == ApiConfig.rateLimitStatusCode) {
            if (kDebugMode) {
              print('⚠️ Rate limit exceeded. Please wait before making more requests.');
            }
          } else if (error.response?.statusCode == ApiConfig.unauthorizedStatusCode) {
            if (kDebugMode) {
              print('🚫 Unauthorized. API key might be invalid or missing.');
            }
          }

          return handler.next(error);
        },
      ),
    );

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
