import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_list_tile.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart';

class MockAppLocalizations implements AppLocalizations {
  
  final Locale locale; 
  @override String get localeName => locale.toString();
  MockAppLocalizations(this.locale);  
  @override String get settingsTitle => 'Settings'; 
  @override String get generalSection => 'General';
  @override String get myAccountTitle => 'My Account';
  @override String get billingPaymentTitle => 'Billing/Payment';
  @override String get faqSupportTitle => 'FAQ & Support';
  @override String get languageTitle => 'Language';
  @override String get darkModeTitle => 'Dark Mode';
  @override String get chooseLanguage => 'Choose Language';
  @override String get languageEnglish => 'English';
  @override String get languageArabic => 'Arabic';
  @override String get cancelButton => 'Cancel';
  @override String get defaultGuestName => 'Guest';
  @override String get coinDetailsTitle =>  'Coin Details';
  @override String get staticsTitle =>  'Statics';
  @override String get aboutCoinTitle =>  'About Bitcoin';
  @override String get buttonSell =>  'Sell';
  @override String get buttonBuy =>   'Buy';
  @override String get marketCap =>   'Market Cap';
  @override String get volume24h =>   'Volume 24h';
  @override String get availableSupply =>   'Available Supply';
  @override String get maxSupply =>  'Max Supply';
  @override String get currentPrice =>   'Current Price';
  @override
  String languageSetSuccess(Object languageName) {
    return 'Language set to $languageName successfully'; 
  }
  
  @override
  // TODO: implement languageSetSuccessDescription
  String get languageSetSuccessDescription => throw UnimplementedError();


  List<Locale> get supportedLocales => const [Locale('en'), Locale('ar')]; 
}

class MockAppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const MockAppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) => Future.value(MockAppLocalizations(locale));
  @override
  bool shouldReload(covariant MockAppLocalizationsDelegate old) => false;
}


void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
      });

  Widget createTileWrapper({
    required Brightness brightness,
    required TextDirection direction,
    Widget? trailing,
    bool hasChevron = true,
    String? chevronPath,
    Color? customDividerColor,
    VoidCallback? onTap,
    String title = 'Test Title',
    bool showDivider = true,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          localizationsDelegates: const [
            MockAppLocalizationsDelegate(), 
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          locale: const Locale('en'), 
          
          theme: ThemeData(
            primaryColor: AppColors.primary,
            brightness: brightness,
            scaffoldBackgroundColor: brightness == Brightness.dark ? AppColors.darkBackground : AppColors.lightBackground,
            iconTheme: IconThemeData(color: brightness == Brightness.dark ? AppColors.textWhite : AppColors.textGray),
          ),
          
          home: Directionality(
            textDirection: direction,
            child: Scaffold(
              body: SettingsListTile(
                title: title,
                iconPath: 'assets/icons/dummy_icon.svg',  
                trailing: trailing,
                hasChevron: hasChevron,
                chevronPath: chevronPath,
                dividerColor: customDividerColor,
                onTap: onTap,
                showDivider: showDivider,
              ),
            ),
          ),
        );
      },
    );
  }

  
  testWidgets('Tile applies Dark Mode colors and checks for divider', (tester) async {
    await tester.pumpWidget(createTileWrapper(
      brightness: Brightness.dark,
      direction: TextDirection.ltr,
      showDivider: true,
    ));
    await tester.pumpAndSettle();

    final circleFinder = find.byType(Container).at(1);
    final container = tester.widget<Container>(circleFinder);
    final boxDecoration = container.decoration as BoxDecoration;
    expect(boxDecoration.color, isNot(equals(AppColors.primary))); 
    
    expect(find.byType(Divider), findsOneWidget);
  });
  
    testWidgets('Chevron rotates 180 degrees in RTL (Arabic) mode', (tester) async {
    await tester.pumpWidget(createTileWrapper(
      brightness: Brightness.light,
      direction: TextDirection.rtl,  
      chevronPath: null, 
    ));
    await tester.pumpAndSettle();

    final rotatedBoxFinder = find.byType(RotatedBox);
    final rotatedBox = tester.widget<RotatedBox>(rotatedBoxFinder);
    expect(rotatedBox.quarterTurns, 2); 
  });
  
  testWidgets('Chevron does not show when Trailing is provided', (tester) async {
    await tester.pumpWidget(createTileWrapper(
      brightness: Brightness.light,
      direction: TextDirection.ltr,
      trailing: const Switch(value: true, onChanged: null),  
    ));
    await tester.pumpAndSettle();

    expect(find.byType(RotatedBox), findsNothing); 
    expect(find.byType(Switch), findsOneWidget);
  });
  
  
  testWidgets('Tapping the tile calls the onTap callback', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(createTileWrapper(
      brightness: Brightness.light,
      direction: TextDirection.ltr,
      onTap: () {
        tapped = true; 
      },
    ));
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Test Title')); 
    await tester.pump();
    
    expect(tapped, isTrue); 
  });
}