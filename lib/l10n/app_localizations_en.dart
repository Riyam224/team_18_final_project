// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get generalSection => 'General';

  @override
  String get myAccountTitle => 'My Account';

  @override
  String get billingPaymentTitle => 'Billing/Payment';

  @override
  String get faqSupportTitle => 'FAQ & Support';

  @override
  String get languageTitle => 'Language';

  @override
  String get darkModeTitle => 'Dark Mode';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String languageSetSuccess(Object languageName) {
    return 'Language set to $languageName successfully';
  }

  @override
  String get languageSetSuccessDescription => 'Message shown when the app language is successfully changed';

  @override
  String get defaultGuestName => 'Guest';

  @override
  String get coinDetailsTitle => 'Coin Details';

  @override
  String get staticsTitle => 'Statics';

  @override
  String get aboutCoinTitle => 'About Coin';

  @override
  String get buttonSell => 'Sell';

  @override
  String get buttonBuy => 'Buy';

  @override
  String get marketCap => 'Market Cap';

  @override
  String get volume24h => 'Volume 24h';

  @override
  String get availableSupply => 'Available Supply';

  @override
  String get maxSupply => 'Max Supply';

  @override
  String get currentPrice => 'Current Price';
}
