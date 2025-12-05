import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  blocTest<LanguageCubit, LanguageState>(
    '1. Emits English ("en") when no language preference is saved (Default)',
    build: () => LanguageCubit(),
    expect: () => [
      const LanguageState('en'),
    ],
    verify: (cubit) {
      expect(cubit.state.languageCode, 'en');
    },
  );

  blocTest<LanguageCubit, LanguageState>(
    '2. Emits Arabic ("ar") when "ar" preference is saved in SharedPreferences',
    setUp: () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language_code', 'ar');
    },
    build: () => LanguageCubit(),
    expect: () => [
      const LanguageState('ar'),
    ],
    verify: (cubit) {
      expect(cubit.state.languageCode, 'ar');
    },
  );

  blocTest<LanguageCubit, LanguageState>(
    '3. Calls changeLanguage("ar"), emits "ar", and saves the value to storage',
    build: () => LanguageCubit(),
    act: (cubit) async {
      await cubit.changeLanguage('ar');
    },
    expect: () => [
      const LanguageState('ar'),
    ],
    verify: (cubit) async {
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_language_code'), 'ar');
    },
  );
}
