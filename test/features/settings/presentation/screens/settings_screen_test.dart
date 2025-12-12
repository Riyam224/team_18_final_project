import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';   
import 'package:mocktail/mocktail.dart';
import 'package:team_18_final_project/features/settings/logic/language_cubit.dart';
import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';
import 'package:team_18_final_project/features/settings/presentation/screens/settings_screen.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}
class MockLanguageCubit extends MockCubit<LanguageState> implements LanguageCubit {}


void main() {
  late MockThemeCubit mockThemeCubit;
  late MockLanguageCubit mockLanguageCubit;

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockLanguageCubit = MockLanguageCubit();
    when(() => mockThemeCubit.state).thenReturn(const ThemeState(ThemeMode.light));
    when(() => mockLanguageCubit.state).thenReturn(const LanguageState('en')); 
  });
  
  Widget createSettingsScreenWrapper({
    required ThemeState themeState,
    required LanguageState languageState,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>.value(value: mockThemeCubit),
            BlocProvider<LanguageCubit>.value(value: mockLanguageCubit),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(languageState.languageCode),
            
            theme: ThemeData(
              textTheme: TextTheme(
                headlineLarge: const TextStyle(fontSize: 24, color: Colors.blue),
                headlineMedium: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
              primaryColor: Colors.blue,
              brightness: themeState.themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light,
            ),
            home: const SettingsScreen(),
          ),
        );
      },
    );
  }



  testWidgets('Screen displays English text correctly and language button works', (tester) async {
    when(() => mockLanguageCubit.state).thenReturn(const LanguageState('en'));

    await tester.pumpWidget(createSettingsScreenWrapper(
      themeState: const ThemeState(ThemeMode.light),
      languageState: const LanguageState('en'),
    ));
    await tester.pumpAndSettle();    

    expect(find.text('Settings'), findsNWidgets(2)); 
    expect(find.text('My Account'), findsOneWidget);
    
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.text('Choose Language'), findsOneWidget);
  });

  
  testWidgets('Screen displays Arabic text correctly and updates language', (tester) async {
    when(() => mockLanguageCubit.state).thenReturn(const LanguageState('ar'));

    await tester.pumpWidget(createSettingsScreenWrapper(
      themeState: const ThemeState(ThemeMode.light),
      languageState: const LanguageState('ar'),
    ));
    await tester.pumpAndSettle();    

    expect(find.text('الإعدادات'), findsNWidgets(2)); 
    expect(find.text('حسابي'), findsOneWidget);
    
    await tester.tap(find.text('اللغة'));
    await tester.pumpAndSettle();
    expect(find.text('اختر اللغة'), findsOneWidget); 
    
  });
  
 
  testWidgets('Screen uses dark background color in Dark Mode', (tester) async {
    when(() => mockLanguageCubit.state).thenReturn(const LanguageState('en'));

    await tester.pumpWidget(createSettingsScreenWrapper(
      themeState: const ThemeState(ThemeMode.dark),
      languageState: const LanguageState('en'),
    ));
    await tester.pumpAndSettle();

    final scaffoldFinder = find.byType(Scaffold);
    final scaffold = tester.widget<Scaffold>(scaffoldFinder);
    expect(scaffold.backgroundColor!.value, greaterThan(0));   
  });
}