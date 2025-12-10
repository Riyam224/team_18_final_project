class ApiConfig {
  ApiConfig._();

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String headerApiKey = 'x-cg-demo-api-key';

  static const int rateLimitStatusCode = 429;
  static const int unauthorizedStatusCode = 401;
}
