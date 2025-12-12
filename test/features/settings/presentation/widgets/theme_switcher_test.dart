import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:team_18_final_project/features/settings/logic/theme_cubit.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/theme_switcher.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/custom_toggle_switch.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';


class MockThemeCubit extends MockCubit<ThemeState> implements ThemeCubit {}

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get darkModeTitle => 'Dark Mode';
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

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(ThemeMode.light);
  });

  setUp(() {
    mockThemeCubit = MockThemeCubit();
    mockAppLocalizations = MockAppLocalizations();
    when(() => mockThemeCubit.state).thenReturn(ThemeState(ThemeMode.light));
    when(() => mockThemeCubit.toggleTheme(any())).thenAnswer((_) async => null);
  });

  Widget createTestWidget({required ThemeMode initialMode}) {
    when(() => mockThemeCubit.state).thenReturn(ThemeState(initialMode));

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: [
            MockAppLocalizationsDelegate(mockAppLocalizations),
          ],
          supportedLocales: const [Locale('en')],
          home: BlocProvider<ThemeCubit>.value(
            value: mockThemeCubit,
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: ThemeSwitcherTile(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  testWidgets('ThemeSwitcherTile shows OFF in Light Mode', (tester) async {
    await tester.pumpWidget(createTestWidget(initialMode: ThemeMode.light));
    await tester.pumpAndSettle();

    final toggleFinder = find.byType(CustomToggleSwitch);
    expect(toggleFinder, findsOneWidget);
    expect(tester.widget<CustomToggleSwitch>(toggleFinder).value, isFalse);

    expect(find.text('Dark Mode'), findsOneWidget);
  });

  testWidgets('Tapping toggle switches theme Light -> Dark', (tester) async {
    await tester.pumpWidget(createTestWidget(initialMode: ThemeMode.light));
    await tester.pumpAndSettle();

    final toggleFinder = find.byType(CustomToggleSwitch);
    await tester.tap(toggleFinder);
    await tester.pumpAndSettle();

    verify(() => mockThemeCubit.toggleTheme(ThemeMode.dark)).called(1);
  });

  testWidgets('Tapping list tile switches theme Dark -> Light', (tester) async {
    await tester.pumpWidget(createTestWidget(initialMode: ThemeMode.dark));
    await tester.pumpAndSettle();

    final tileFinder = find.descendant(
      of: find.byType(ThemeSwitcherTile),
      matching: find.byType(SettingsListTile),
    );

    expect(tileFinder, findsOneWidget);

    await tester.tap(tileFinder);
    await tester.pumpAndSettle();

    verify(() => mockThemeCubit.toggleTheme(ThemeMode.light)).called(1);
  });
}
