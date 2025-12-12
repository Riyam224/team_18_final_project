import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:team_18_final_project/core/config/app_text_styles.dart';
import 'package:team_18_final_project/core/utils/app_colors.dart';
import 'package:team_18_final_project/features/settings/presentation/widgets/settings_header.dart';
import 'package:team_18_final_project/l10n/app_localizations.dart'; 
import 'package:team_18_final_project/core/extension/app_extension.dart';

const String mockUserName = 'Test User';
const String mockLocalizedName = 'Sophia Isabella';

class MockAppLocalizations implements AppLocalizations {

  final Locale locale; 
  @override String get localeName => locale.toString();


  MockAppLocalizations(this.locale);  
  @override String get name => mockLocalizedName;
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
String get languageSetSuccessDescription => 'Mock language description';
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

  Widget createHeaderWrapper({required Brightness brightness}) {
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
          supportedLocales: const [Locale('en')],
          locale: const Locale('en'), 
          
          theme: ThemeData(
            primaryColor: AppColors.primary,
            brightness: brightness,
            textTheme: TextTheme(
              headlineMedium: AppTextStyles.headlineMedium.copyWith(fontSize: 18),
            ),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
              brightness: brightness,
              background: brightness == Brightness.dark ? AppColors.darkBackground : AppColors.lightBackground,
            )
          ),
          
          home:  Scaffold(body: SettingsHeader(userName: mockUserName,)), 
        );
      },
    );
  }

  
  testWidgets('Header displays name, image, and light mode colors', (tester) async {
    await tester.pumpWidget(createHeaderWrapper(brightness: Brightness.light));
    await tester.pumpAndSettle(); 

    expect(find.text(mockUserName), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text(mockUserName));
    expect(textWidget.style!.color, equals(AppColors.primary)); 

    expect(find.byType(CircleAvatar), findsOneWidget); 
  });
  
  
  testWidgets('Header applies dark mode colors correctly', (tester) async {
    await tester.pumpWidget(createHeaderWrapper(brightness: Brightness.dark));
    await tester.pumpAndSettle();

    final textWidget = tester.widget<Text>(find.text(mockUserName));
    expect(textWidget.style!.color, equals(AppColors.textWhite)); 

    expect(find.byType(CircleAvatar), findsOneWidget); 
    
    final circleAvatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(circleAvatar.backgroundColor!.value, isNot(equals(AppColors.primary.value)));
  });
}