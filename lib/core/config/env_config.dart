/// Environment configuration
/// Add your API keys here. This file should be gitignored for production use.
class EnvConfig {
  EnvConfig._();

  // CoinGecko API Configuration
  // Get your API key from: https://www.coingecko.com/en/api/pricing
  static const String coinGeckoApiKey = String.fromEnvironment(
    'COINGECKO_API_KEY',
    defaultValue: '',
  );
}
