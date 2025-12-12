import 'package:flutter/material.dart';

typedef ThemeModeSetter = Future<void> Function(ThemeMode mode);

class ThemeController extends InheritedWidget {
  final ThemeMode themeMode;
  final ThemeModeSetter setThemeMode;

  const ThemeController({
    super.key,
    required this.themeMode,
    required this.setThemeMode,
    required super.child,
  });

  static ThemeController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeController>()!;

  @override
  bool updateShouldNotify(covariant ThemeController oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}
