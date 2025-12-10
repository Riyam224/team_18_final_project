class FirebaseConfig {
  const FirebaseConfig._();

  static const String usersCollection = 'users';

  static const String profileField = 'profile';
  static const String settingsField = 'settings';
  static const String securityField = 'security';

  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String settingsUpdatedAtField = 'settingsUpdatedAt';
  static const String lastLoginAtField = 'lastLoginAt';

  static const String emailField = 'email';
  static const String displayNameField = 'displayName';
  static const String phoneNumberField = 'phoneNumber';
  static const String photoUrlField = 'photoUrl';
  static const String avatarUrlField = 'avatarUrl';
  static const String avatarStorageFolder = 'avatars';

  static const String biometricEnabledField = 'biometricEnabled';
  static const String biometricTypeField = 'biometricType';
  static const String sessionTimeoutField = 'sessionTimeoutMinutes';
  static const String autoLockTimeoutField = 'autoLockTimeoutSeconds';

  static const String lastLoginEmailField = 'lastLoginEmail';
  static const String lastLoginDeviceField = 'lastLoginDevice';
  static const String lastLoginIpField = 'lastLoginIp';

  static const String uidField = 'uid';
  static const String isEmailVerifiedField = 'isEmailVerified';
}
