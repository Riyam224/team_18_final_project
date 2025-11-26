import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<String> register(UserModel user);

  Future<void> storeUserCredentials({
    required String userId,
    required String token,
  });

  Future<void> storeBiometricSettings({
    required bool enabled,
    required String type,
  });

  Future<bool> isBiometricEnabled();
  Future<String?> getBiometricType();

  // Store credentials for biometric login
  Future<void> storeCredentialsForBiometric({
    required String email,
    required String password,
  });

  // Get stored credentials for biometric login
  Future<String?> getStoredEmail();
  Future<String?> getStoredPassword();
}
