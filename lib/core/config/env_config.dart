class EnvConfig {
  EnvConfig._();

  static const String coinGeckoApiKey = String.fromEnvironment(
    'COINGECKO_API_KEY',
    defaultValue: '',
  );

  static void validate() {
    if (coinGeckoApiKey.isEmpty) {
      throw Exception(
        'COINGECKO_API_KEY is not set. Please create a .env file with your API key.',
      );
    }
  }
}
