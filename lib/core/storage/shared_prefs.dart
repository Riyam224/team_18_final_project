import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const String _onboardingKey = 'onboarding_completed';

  /// Save onboarding completion
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  /// Check if onboarding was completed before
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
}
