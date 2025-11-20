import 'package:shared_preferences/shared_preferences.dart';

/// Save the access token (just the token string, not the whole response)
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
}

/// Retrieve the saved token later
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

/// Remove the token (for logout)
Future<void> clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
}