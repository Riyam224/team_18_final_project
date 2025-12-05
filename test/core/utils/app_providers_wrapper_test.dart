import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/utils/app_providers_wrapper.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';
import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart'; 

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}
class MockLanguageCubit extends MockCubit<LanguageState> implements LanguageCubit {}

void main() {
  late MockThemeCubit mockThemeCubit;
  late MockLanguageCubit mockLanguageCubit;

  setUpAll(() {
    sl.registerFactory<ThemeCubit>(() => mockThemeCubit);
    sl.registerFactory<LanguageCubit>(() => mockLanguageCubit);
  });

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockLanguageCubit = MockLanguageCubit();
    
    when(() => mockThemeCubit.state).thenReturn(const ThemeState(ThemeMode.light));
    when(() => mockLanguageCubit.state).thenReturn(const LanguageState('en'));
  });

  testWidgets('AppProvidersWrapper provides ThemeCubit and LanguageCubit', (tester) async {
    await tester.pumpWidget(const AppProvidersWrapper());
    await tester.pumpAndSettle();

    
    expect(() => tester.widget<BlocProvider<ThemeCubit>>(
      find.byType(BlocProvider<ThemeCubit>)),
      returnsNormally,
    );

    expect(() => tester.widget<BlocProvider<LanguageCubit>>(
      find.byType(BlocProvider<LanguageCubit>)),
      returnsNormally,
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
  
  testWidgets('Changing LanguageCubit state updates MaterialApp locale', (tester) async {
    whenListen(
      mockLanguageCubit,
      Stream.fromIterable([const LanguageState('ar')]), 
      initialState: const LanguageState('en'),
    );

    await tester.pumpWidget(const AppProvidersWrapper());
    await tester.pumpAndSettle();

    MaterialApp initialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(initialApp.locale!.languageCode, 'en');

    await tester.pump();
    
    MaterialApp updatedApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(updatedApp.locale!.languageCode, 'ar');
  });
}