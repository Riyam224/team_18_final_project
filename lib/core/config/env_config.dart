/// Environment configuration
/// API keys and secrets are loaded from environment variables
/// IMPORTANT: Create a .env file with your API keys (see .env.example)
class EnvConfig {
  EnvConfig._();

  // CoinGecko API Configuration
  // Get your API key from: https://www.coingecko.com/en/api/pricing
  // Set COINGECKO_API_KEY in your .env file
  static const String coinGeckoApiKey = String.fromEnvironment(
    'COINGECKO_API_KEY',
    defaultValue: '',
  );

  /// Validate that all required environment variables are set
  static void validate() {
    if (coinGeckoApiKey.isEmpty) {
      throw Exception(
        'COINGECKO_API_KEY is not set. Please create a .env file with your API key.',
      );
    }
  }
}
