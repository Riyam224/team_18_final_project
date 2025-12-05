import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'preferred_theme';

  ThemeCubit() : super(const ThemeState(ThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    ThemeMode mode = ThemeMode.light;   

    if (savedTheme == 'dark') {
      mode = ThemeMode.dark;
    }
    
    emit(ThemeState(mode));
  }

  Future<void> toggleTheme(ThemeMode newMode) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (newMode == ThemeMode.light) {
      await prefs.setString(_themeKey, 'light');
    } else if (newMode == ThemeMode.dark) {
      await prefs.setString(_themeKey, 'dark');
    }

    emit(ThemeState(newMode));
  }
}