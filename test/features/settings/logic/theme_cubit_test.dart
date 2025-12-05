import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';


class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    SharedPreferences.setMockInitialValues({}); 
    mockSharedPreferences = MockSharedPreferences();
    when(() => SharedPreferences.getInstance()).thenAnswer((_) async => mockSharedPreferences);
  });
  
  
  blocTest<ThemeCubit, ThemeState>(
    '1. Emits ThemeMode.light when no preference is saved (Default)',
    setUp: () {
      when(() => mockSharedPreferences.getString('preferred_theme')).thenReturn(null);
    },
    build: () => ThemeCubit(),
    expect: () => [
        isA<ThemeState>(), 
      ], 
    verify: (cubit) {
      expect(cubit.state.themeMode, ThemeMode.light);
      verify(() => mockSharedPreferences.getString('preferred_theme')).called(1);
    },
  );

  blocTest<ThemeCubit, ThemeState>(
    '2. Emits ThemeMode.dark when preference is saved as "dark"',
    setUp: () {
      when(() => mockSharedPreferences.getString('preferred_theme')).thenReturn('dark');
    },
    build: () => ThemeCubit(),
    expect: () => [
        isA<ThemeState>(),  
        const ThemeState(ThemeMode.dark),  
      ],
    verify: (cubit) {
      expect(cubit.state.themeMode, ThemeMode.dark);
    },
  );
  
  
  blocTest<ThemeCubit, ThemeState>(
    '3. Toggles to ThemeMode.dark and saves it to storage',
    setUp: () {
      
      when(() => mockSharedPreferences.setString('preferred_theme', 'dark')).thenAnswer((_) async => true);
    },
    build: () => ThemeCubit(),
    act: (cubit) => cubit.toggleTheme(ThemeMode.dark),
    expect: () => [
      const ThemeState(ThemeMode.dark),
    ],
    verify: (_) {
      verify(() => mockSharedPreferences.setString('preferred_theme', 'dark')).called(1);
    },
  );
}