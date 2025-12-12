/// Common test helpers and utilities
library;

/// Mock data constants for testing
class TestData {
  // Valid test data
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String validFirstName = 'John';
  static const String validLastName = 'Doe';
  static const String validPhone = '+1234567890';
  static const String validUserId = 'test-user-id-123';
  static const String validToken = 'test-token-abc';
  static const String validRefreshToken = 'test-refresh-token-xyz';

  // Invalid test data
  static const String invalidEmail = 'invalid-email';
  static const String emptyString = '';
  static const String shortPassword = '12345';
  static final String longPassword = 'a' * 129; // Exceeds max length of 128
  static const String invalidPhone = 'abc123';

  // Edge cases
  static const String emailWithSpaces = '  test@example.com  ';
  static const String passwordWithSpecialChars = 'P@ssw0rd!#\$';
  static final String veryLongName = 'a' * 100;

  // Crypto market data
  static const double mockMarketCap = 1000000000000.0;
  static const double mockVolume24h = 50000000000.0;
  static const double mockBtcDominance = 45.5;
  static const int mockActiveCoins = 10000;
  static const double mockMarketCapChangePercentage = 2.5;

  // Transaction data
  static const String mockTransactionId = 'txn-123';
  static const String mockAsset = 'BTC';
  static const double mockAmount = 0.5;
  static const String mockNote = 'Test transaction';
}

/// Helper function to create test DateTime
DateTime testDateTime() => DateTime(2024, 1, 1, 12, 0, 0);

/// Helper function to create future test DateTime
DateTime futureTestDateTime() => DateTime(2024, 1, 1, 13, 0, 0);

/// Helper function to create past test DateTime
DateTime pastTestDateTime() => DateTime(2024, 1, 1, 11, 0, 0);
