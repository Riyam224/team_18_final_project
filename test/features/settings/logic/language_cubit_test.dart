import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart'; 

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    SharedPreferences.setMockInitialValues({}); 
    mockSharedPreferences = MockSharedPreferences();
    when(() => SharedPreferences.getInstance()).thenAnswer((_) async => mockSharedPreferences);
  });
  
  blocTest<LanguageCubit, LanguageState>(
    '1. Emits English ("en") when no language preference is saved (Default)',
    setUp: () {
      when(() => mockSharedPreferences.getString('app_language_code')).thenReturn(null);
    },
    build: () => LanguageCubit(),
    expect: () => [
        isA<LanguageState>(),    
        const LanguageState('en'), 
      ], 
    verify: (cubit) {
      expect(cubit.state.languageCode, 'en');
    },
  );

  
  blocTest<LanguageCubit, LanguageState>(
    '2. Emits Arabic ("ar") when "ar" preference is saved in SharedPreferences',
    setUp: () {
      when(() => mockSharedPreferences.getString('app_language_code')).thenReturn('ar');
    },
    build: () => LanguageCubit(),
    expect: () => [
        isA<LanguageState>(),  
        const LanguageState('ar'), 
      ],
    verify: (cubit) {
      expect(cubit.state.languageCode, 'ar');
    },
  );
  
  
  blocTest<LanguageCubit, LanguageState>(
    '3. Calls changeLanguage("ar"), emits "ar", and saves the value to storage',
    setUp: () {
      when(() => mockSharedPreferences.setString('app_language_code', 'ar')).thenAnswer((_) async => true);
    },
    build: () => LanguageCubit(),
    act: (cubit) => cubit.changeLanguage('ar'),
    expect: () => [
      const LanguageState('ar'),
    ],
    verify: (_) {
      verify(() => mockSharedPreferences.setString('app_language_code', 'ar')).called(1);
    },
  );
}