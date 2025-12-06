/// Network configuration for the application
/// Contains all network-related constants (headers, status codes, API URLs)
class NetworkConfig {
  const NetworkConfig._();

  // API Base URLs
  static const String coinGeckoBaseUrl = 'https://api.coingecko.com/api/v3';

  // HTTP Headers
  static const String acceptHeader = 'Accept';
  static const String acceptValue = 'application/json';
  static const String contentTypeHeader = 'Content-Type';
  static const String contentTypeValue = 'application/json';
  static const String apiKeyHeader = 'x-cg-demo-api-key';

  // HTTP Status Codes
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

  // Error Messages
  static const String rateLimitExceeded =
      'Rate limit exceeded. Please wait before making more requests.';
  static const String unauthorizedRequest =
      'Unauthorized. API key might be invalid or missing.';

  // Environment Variable Keys
  static const String coinGeckoApiKeyEnv = 'COINGECKO_API_KEY';

  // Debug/Log Messages
  static const String apiKeyNotFoundWarning =
      '⚠️ [DioClient] Warning: COINGECKO_API_KEY not found in .env file';

  // Log Prefixes
  static const String requestLogPrefix = '🌐 [DioClient] Request →';
  static const String responseLogPrefix = '✅ [DioClient] Response →';
  static const String errorLogPrefix = '❌ [DioClient] Error →';
  static const String messageLogPrefix = '❌ [DioClient] Message →';
  static const String warningLogPrefix = '⚠️';
  static const String unauthorizedLogPrefix = '🚫';
  static const String detailsLogPrefix = '🔹';
}
