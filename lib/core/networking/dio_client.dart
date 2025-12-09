import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:team_18_final_project/core/config/env_config.dart';
import 'package:team_18_final_project/core/config/network_config.dart';
import 'package:team_18_final_project/core/config/timing_config.dart';
import 'api_base_url.dart';

/// Factory class that creates and configures Dio HTTP client instances.
/// Sets up interceptors for API key injection, logging, and error handling.
class DioClient {
  /// API key is loaded at compile-time using --dart-define.
  /// Returns empty string if not provided (app will still work with limited features).
  static String get _apiKey => EnvConfig.coinGeckoApiKey;

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: TimingConfig.connectionTimeout,
        receiveTimeout: TimingConfig.receiveTimeout,
        headers: {
          NetworkConfig.acceptHeader: NetworkConfig.acceptValue,
          NetworkConfig.apiKeyHeader: _apiKey,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final apiKey = _apiKey;

          if (apiKey.isEmpty && kDebugMode) {
            debugPrint(NetworkConfig.apiKeyNotFoundWarning);
          }

          options.headers[NetworkConfig.apiKeyHeader] = apiKey;

          if (kDebugMode) {
            debugPrint('${NetworkConfig.requestLogPrefix} ${options.method} ${options.uri}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
                '${NetworkConfig.responseLogPrefix} ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
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

    /// Debug-only detailed logging to avoid performance overhead in production
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint('${NetworkConfig.detailsLogPrefix} $obj'),
        ),
      );
    }

    return dio;
  }
}
