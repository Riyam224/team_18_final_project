import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:team_18_final_project/core/constants/app_strings.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.light)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    ThemeMode mode = ThemeMode.light;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(AppStrings.themePreferenceKey);

      if (savedTheme == AppStrings.themeKeyDarkValue) {
        mode = ThemeMode.dark;
      }
    } catch (e) {
      debugPrint('${AppStrings.debugErrorLoadingTheme} $e');
      mode = ThemeMode.light;
    }

    emit(ThemeState(mode));
  }

  Future<void> toggleTheme(ThemeMode newMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (newMode == ThemeMode.light) {
        await prefs.setString(
            AppStrings.themePreferenceKey, AppStrings.themeKeyLightValue);
      } else if (newMode == ThemeMode.dark) {
        await prefs.setString(
            AppStrings.themePreferenceKey, AppStrings.themeKeyDarkValue);
      }
    } catch (e) {
    debugPrint('${AppStrings.debugErrorSavingTheme} $e');
    }
    emit(ThemeState(newMode));
  }
}
