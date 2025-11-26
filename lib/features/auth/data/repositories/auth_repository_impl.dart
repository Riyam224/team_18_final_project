import 'package:team_18_final_project/core/security/secure_storage_service.dart';
import 'package:team_18_final_project/features/auth/domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login(String email, String password) async {
    // TODO: Replace with real API call
    return "mock_token_123";
  }

  @override
  Future<String> register(UserModel user) async {
    // TODO: Replace with real API call
    return "new_user_id_123";
  }

  @override
  Future<void> storeUserCredentials({
    required String userId,
    required String token,
  }) async {
    await SecureStorageService.write("user_id", userId);
    await SecureStorageService.write("token", token);
  }

  @override
  Future<void> storeBiometricSettings({
    required bool enabled,
    required String type,
  }) async {
    await SecureStorageService.write("biometric_enabled", enabled.toString());
    await SecureStorageService.write("biometric_type", type);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    final enabled = await SecureStorageService.read("biometric_enabled");
    return enabled == "true";
  }

  @override
  Future<String?> getBiometricType() {
    return SecureStorageService.read("biometric_type");
  }

  @override
  Future<void> storeCredentialsForBiometric({
    required String email,
    required String password,
  }) async {
    await SecureStorageService.write("biometric_email", email);
    await SecureStorageService.write("biometric_password", password);
  }

  @override
  Future<String?> getStoredEmail() {
    return SecureStorageService.read("biometric_email");
  }

  @override
  Future<String?> getStoredPassword() {
    return SecureStorageService.read("biometric_password");
  }
}
