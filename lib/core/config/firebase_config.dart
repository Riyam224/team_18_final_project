/// Firebase configuration for the application
/// Contains collection names, field names, and Firestore structure constants
class FirebaseConfig {
  const FirebaseConfig._();

  // Collection Names
  static const String usersCollection = 'users';

  // Document Fields - User Document Structure
  static const String profileField = 'profile';
  static const String settingsField = 'settings';
  static const String securityField = 'security';

  // Timestamp Fields
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String settingsUpdatedAtField = 'settingsUpdatedAt';
  static const String lastLoginAtField = 'lastLoginAt';

  // Profile Fields
  static const String emailField = 'email';
  static const String displayNameField = 'displayName';
  static const String phoneNumberField = 'phoneNumber';
  static const String photoUrlField = 'photoUrl';
  static const String avatarUrlField = 'avatarUrl';

  // Settings Fields
  static const String biometricEnabledField = 'biometricEnabled';
  static const String biometricTypeField = 'biometricType';
  static const String sessionTimeoutField = 'sessionTimeoutMinutes';
  static const String autoLockTimeoutField = 'autoLockTimeoutSeconds';

  // Security Fields
  static const String lastLoginEmailField = 'lastLoginEmail';
  static const String lastLoginDeviceField = 'lastLoginDevice';
  static const String lastLoginIpField = 'lastLoginIp';

  // Auth State
  static const String uidField = 'uid';
  static const String isEmailVerifiedField = 'isEmailVerified';
}
