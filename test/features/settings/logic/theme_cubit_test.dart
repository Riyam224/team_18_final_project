import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  blocTest<ThemeCubit, ThemeState>(
    '1. Emits ThemeMode.light when no preference is saved (Default)',
    build: () => ThemeCubit(),
    expect: () => [
      const ThemeState(ThemeMode.light),
    ],
    verify: (cubit) {
      expect(cubit.state.themeMode, ThemeMode.light);
    },
  );

  blocTest<ThemeCubit, ThemeState>(
    '2. Emits ThemeMode.dark when preference is saved as "dark"',
    setUp: () {
      SharedPreferences.setMockInitialValues({'preferred_theme': 'dark'});
    },
    build: () => ThemeCubit(),
    expect: () => [
      const ThemeState(ThemeMode.dark),
    ],
    verify: (cubit) {
      expect(cubit.state.themeMode, ThemeMode.dark);
    },
  );

  blocTest<ThemeCubit, ThemeState>(
    '3. Toggles to ThemeMode.dark and saves it to storage',
    build: () => ThemeCubit(),
    act: (cubit) => cubit.toggleTheme(ThemeMode.dark),
    expect: () => [
      const ThemeState(ThemeMode.dark),
    ],
  );
}
