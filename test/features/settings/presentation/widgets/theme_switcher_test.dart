import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mocktail/mocktail.dart';

import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';
import 'package:team_18_final_project/features/settings/presentation/screens/settings_screen.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/custom_toggle_switch.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart'; 
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_list_tile.dart';


class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override String get darkModeTitle => 'Dark Mode'; 
  @override String get settingsTitle => 'Settings'; 
  @override String get generalSection => 'General';
  @override String get myAccountTitle => 'My Account';
  @override String get billingPaymentTitle => 'Billing/Payment';
  @override String get faqSupportTitle => 'FAQ & Support';
  @override String get languageTitle => 'Language';
  @override String get chooseLanguage => 'Choose Language';
  @override String get cancelButton => 'Cancel';
}

class MockAppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final AppLocalizations mock;
  const MockAppLocalizationsDelegate(this.mock);

  @override
  bool isSupported(Locale locale) => true;   
  @override
  Future<AppLocalizations> load(Locale locale) => Future.value(mock); 
  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

void main() {
  late MockThemeCubit mockThemeCubit;
  late MockAppLocalizations mockAppLocalizations;

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockAppLocalizations = MockAppLocalizations();
  });
  

  Widget createFullWrapper({required ThemeMode initialMode}) {
    when(() => mockThemeCubit.state).thenReturn(ThemeState(initialMode));
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            MockAppLocalizationsDelegate(mockAppLocalizations),  
          ],
          supportedLocales: const [Locale('en')],
          locale: const Locale('en'), 
          theme: ThemeData(primaryColor: Colors.blue, brightness: Brightness.light),
          
          home: BlocProvider<ThemeCubit>(
            create: (context) => mockThemeCubit,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SettingsScreen(), 
            ),
          ),
        );
      },
    );
  }


  testWidgets('ThemeSwitcherTile displays OFF state in Light Mode', (tester) async {
    await tester.pumpWidget(createFullWrapper(initialMode: ThemeMode.light));
    await tester.pumpAndSettle();

    final toggleFinder = find.byType(CustomToggleSwitch);
    expect(toggleFinder, findsOneWidget);
    
    expect(tester.widget<CustomToggleSwitch>(toggleFinder).value, isFalse); 
    
    expect(find.text('Dark Mode'), findsOneWidget); 
  });

  
  testWidgets('Tapping the toggle switches theme from Light to Dark', (tester) async {
    await tester.pumpWidget(createFullWrapper(initialMode: ThemeMode.light));
    
    await tester.tap(find.byType(CustomToggleSwitch));
    
    verify(() => mockThemeCubit.toggleTheme(ThemeMode.dark)).called(1);
  });
  

  testWidgets('Tapping the list tile switches theme from Dark to Light', (tester) async {
    await tester.pumpWidget(createFullWrapper(initialMode: ThemeMode.dark));
    
    await tester.tap(find.byType(SettingsListTile).first); 
    
    verify(() => mockThemeCubit.toggleTheme(ThemeMode.light)).called(1);
  });
}