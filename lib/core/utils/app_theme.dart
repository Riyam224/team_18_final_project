import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:team_18_final_project/core/utils/light_theme.dart';
import 'package:team_18_final_project/core/utils/dark_theme.dart';

class AppTheme {
  /// Getters used inside MaterialApp
  static ThemeData get lightTheme => buildLightTheme();
  static ThemeData get darkTheme => buildDarkTheme();

  /// System status bar styling depending on theme
  static void setSystemUIOverlayStyle(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
