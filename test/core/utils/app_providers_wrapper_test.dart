import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:team_18_final_project/core/di/di.dart';
import 'package:team_18_final_project/core/utils/app_providers_wrapper.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';
import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart'; 
import 'package:team_18_final_project/l10n/app_localizations.dart'; 


class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}
class MockLanguageCubit extends MockCubit<LanguageState> implements LanguageCubit {}

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override List<Locale> get supportedLocales => const [Locale('en'), Locale('ar')]; 
  @override String get settingsTitle => 'Project Title';
  @override String get myAccountTitle => 'My Account';
  @override String get generalSection => 'General';
}

void main() {
  late MockThemeCubit mockThemeCubit;
  late MockLanguageCubit mockLanguageCubit;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(ThemeMode.light);
    sl.registerFactory<ThemeCubit>(() => mockThemeCubit);
    sl.registerFactory<LanguageCubit>(() => mockLanguageCubit);
  });

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockLanguageCubit = MockLanguageCubit();
    
    when(() => mockThemeCubit.state).thenReturn(const ThemeState(ThemeMode.light));
    when(() => mockLanguageCubit.state).thenReturn(const LanguageState('en'));
  });

  Widget createAppWrapperTest() {
    return AppProvidersWrapper(key: UniqueKey());
  }

  testWidgets('AppProvidersWrapper provisions ThemeCubit and LanguageCubit', (tester) async {
    await tester.pumpWidget(createAppWrapperTest());
    
    expect(find.byType(BlocProvider<ThemeCubit>), findsOneWidget);
    expect(find.byType(BlocProvider<LanguageCubit>), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });


  testWidgets('Changing ThemeState updates MaterialApp themeMode', (tester) async {
    whenListen(
      mockThemeCubit,
      Stream.fromIterable([const ThemeState(ThemeMode.dark)]), 
      initialState: const ThemeState(ThemeMode.light), 
    );
    when(() => mockLanguageCubit.state).thenReturn(const LanguageState('en'));  

    await tester.pumpWidget(createAppWrapperTest());
    
    MaterialApp appWidgetInitial = tester.widget(find.byType(MaterialApp));
    expect(appWidgetInitial.themeMode, ThemeMode.light); 
    
    await tester.pump(); 
    
    MaterialApp appWidgetUpdated = tester.widget(find.byType(MaterialApp));
    expect(appWidgetUpdated.themeMode, ThemeMode.dark); 
  });
}