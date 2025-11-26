import 'dart:convert';
import 'package:team_18_final_project/core/security/secure_storage_service.dart';
import 'package:team_18_final_project/features/auth/data/models/user_model.dart';

class AuthRepository {
  static const _userKey = 'USER_DATA';
  static const _tokenKey = 'AUTH_TOKEN';

  Future<bool> register(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await SecureStorageService.write(_userKey, jsonString);
    return true;
  }

  Future<UserModel?> getUser() async {
    final jsonString = await SecureStorageService.read(_userKey);
    if (jsonString == null) return null;
    return UserModel.fromJson(jsonDecode(jsonString));
  }

  Future<bool> login(String email, String password) async {
    final user = await getUser();
    if (user == null) return false;

    if (user.email == email && user.password == password) {
      await SecureStorageService.write(_tokenKey, "dummy_token_${DateTime.now().millisecondsSinceEpoch}");
      return true;
    }
    return false;
  }

  Future<bool> isLoggedIn() async {
    final token = await SecureStorageService.read(_tokenKey);
    return token != null;
  }

  Future<void> logout() async {
    await SecureStorageService.delete(_tokenKey);
  }
}
