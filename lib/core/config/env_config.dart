class EnvConfig {
  EnvConfig._();

  static const String coinGeckoApiKey = String.fromEnvironment(
    'COINGECKO_API_KEY',
    defaultValue: '',
  );
}
