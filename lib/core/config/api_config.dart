class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const String defaultCurrency = 'usd';
  static const String headerAccept = 'Accept';
  static const String headerApiKey = 'x-cg-demo-api-key';
  static const String headerContentType = 'application/json';
  static const int rateLimitStatusCode = 429;
  static const int unauthorizedStatusCode = 401;
}
