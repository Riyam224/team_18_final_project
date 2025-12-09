/// Biometric configuration for the application
/// Contains all biometric authentication-related constants
class BiometricConfig {
  const BiometricConfig._();

  // Biometric Authentication Reasons
  static const String defaultAuthReason = 'Please authenticate to continue';
  static const String verifyIdentityReason = 'Verify your identity';
  static const String loginReason = 'Authenticate to login';
  static const String setupReason = 'Authenticate to setup biometric';
  static const String transactionReason = 'Authenticate to confirm transaction';

  // Biometric Types
  static const String fingerprintType = 'fingerprint';
  static const String faceIdType = 'face';
  static const String noneType = 'none';

  // Error Messages
  static const String authenticationFailed = 'Authentication failed';
  static const String fingerprintAuthFailed =
      'Fingerprint authentication failed';
  static const String faceIdAuthFailed = 'Face ID authentication failed';
  static const String biometricNotAvailable =
      'Biometric authentication is not available';
  static const String biometricNotEnrolled =
      'No biometric credentials enrolled';

  // Success Messages
  static const String authenticationSuccess = 'Authentication successful';
  static const String biometricSetupSuccess =
      'Biometric authentication setup successfully';

  // Biometric Storage Keys (duplicated from StorageKeysConfig for clarity)
  static const String enabledKey = 'biometric_enabled';
  static const String typeKey = 'biometric_type';
  static const String emailKey = 'biometric_email';
  static const String passwordKey = 'biometric_password';
  static const String credentialsStoredKey = 'biometric_credentials_stored';
}
