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
    await SecureStorageService.saveUserId(userId);
    await SecureStorageService.saveAuthToken(token);
  }

  @override
  Future<void> storeBiometricSettings({
    required bool enabled,
    required String type,
  }) async {
    await SecureStorageService.setBiometricEnabled(enabled);
    await SecureStorageService.setBiometricType(type);
  }

  @override
  Future<bool> isBiometricEnabled() async {
    return SecureStorageService.isBiometricEnabled();
  }

  @override
  Future<String?> getBiometricType() {
    return SecureStorageService.getBiometricType();
  }

  @override
  Future<void> storeCredentialsForBiometric({
    required String email,
    required String password,
  }) async {
    await SecureStorageService.saveBiometricCredentials(
      email: email,
      password: password,
    );
  }

  @override
  Future<String?> getStoredEmail() {
    return SecureStorageService.getBiometricEmail();
  }

  @override
  Future<String?> getStoredPassword() {
    return SecureStorageService.getBiometricPassword();
  }
}
