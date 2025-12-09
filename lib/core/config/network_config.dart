import 'package:team_18_final_project/core/constants/api_constants.dart';

class NetworkConfig {
  const NetworkConfig._();

  static const String coinGeckoBaseUrl = ApiBaseUrl.coingecko;

  static const String acceptHeader = 'Accept';
  static const String acceptValue = ApiHeaders.applicationJson;
  static const String contentTypeHeader = ApiHeaders.contentType;
  static const String contentTypeValue = ApiHeaders.applicationJson;
  static const String apiKeyHeader = 'x-cg-demo-api-key';

  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusTooManyRequests = 429;
  static const int statusInternalServerError = 500;
  static const int statusServiceUnavailable = 503;

  static const String rateLimitExceeded =
      'Rate limit exceeded. Please wait before making more requests.';
  static const String unauthorizedRequest =
      'Unauthorized. API key might be invalid or missing.';

  static const String coinGeckoApiKeyEnv = 'COINGECKO_API_KEY';

  static const String apiKeyNotFoundWarning =
      '⚠️ [DioClient] Warning: COINGECKO_API_KEY not found in .env file';

  static const String requestLogPrefix = '🌐 [DioClient] Request →';
  static const String responseLogPrefix = '✅ [DioClient] Response →';
  static const String errorLogPrefix = '❌ [DioClient] Error →';
  static const String messageLogPrefix = '❌ [DioClient] Message →';
  static const String warningLogPrefix = '⚠️';
  static const String unauthorizedLogPrefix = '🚫';
  static const String detailsLogPrefix = '🔹';
}
