import 'package:flutter/material.dart';

extension AppThemeData on BuildContext {
  ThemeData get appTheme => Theme.of(this);
}

extension DarkOrLight on BuildContext {
  Brightness get _brightnessTheme => Theme.of(this).brightness;

  bool isDark() => (_brightnessTheme == Brightness.dark);
  bool islight() => (_brightnessTheme == Brightness.light);
}

extension StringExtension on String? {
  bool isNullOrEmp() => this == null || this == "";
}
