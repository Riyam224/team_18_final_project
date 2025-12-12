import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @market.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get market;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @portfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolioTitle;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get totalValue;

  /// No description provided for @myHoldings.
  ///
  /// In en, this message translates to:
  /// **'My Holdings'**
  String get myHoldings;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @buyTransaction.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buyTransaction;

  /// No description provided for @sellTransaction.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sellTransaction;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hour;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;

  /// No description provided for @billingPayment.
  ///
  /// In en, this message translates to:
  /// **'Billing/Payment'**
  String get billingPayment;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @primaryCard.
  ///
  /// In en, this message translates to:
  /// **'Primary Card'**
  String get primaryCard;

  /// No description provided for @backupCard.
  ///
  /// In en, this message translates to:
  /// **'Backup Card'**
  String get backupCard;

  /// No description provided for @cardNumberHidden.
  ///
  /// In en, this message translates to:
  /// **'**** **** **** '**
  String get cardNumberHidden;

  /// No description provided for @cardVisa.
  ///
  /// In en, this message translates to:
  /// **'VISA'**
  String get cardVisa;

  /// No description provided for @cardMastercard.
  ///
  /// In en, this message translates to:
  /// **'Mastercard'**
  String get cardMastercard;

  /// No description provided for @billing.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billing;

  /// No description provided for @viewInvoices.
  ///
  /// In en, this message translates to:
  /// **'View Invoices'**
  String get viewInvoices;

  /// No description provided for @addNewPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add new payment method'**
  String get addNewPaymentMethod;

  /// No description provided for @managePaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Manage payment details'**
  String get managePaymentDetails;

  /// No description provided for @faqSupport.
  ///
  /// In en, this message translates to:
  /// **'FAQ & Support'**
  String get faqSupport;

  /// No description provided for @popularQuestions.
  ///
  /// In en, this message translates to:
  /// **'Popular questions'**
  String get popularQuestions;

  /// No description provided for @faqUpdateBillingQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I update my billing method?'**
  String get faqUpdateBillingQuestion;

  /// No description provided for @faqUpdateBillingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to Billing/Payment in Settings and tap \"Add new payment method\".'**
  String get faqUpdateBillingAnswer;

  /// No description provided for @faqExportInvoicesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Can I export my invoices?'**
  String get faqExportInvoicesQuestion;

  /// No description provided for @faqExportInvoicesAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes, download a PDF copy from the invoices list.'**
  String get faqExportInvoicesAnswer;

  /// No description provided for @faqContactSupportQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I contact support?'**
  String get faqContactSupportQuestion;

  /// No description provided for @faqContactSupportAnswer.
  ///
  /// In en, this message translates to:
  /// **'Use the contact form below or email support@fintech.app.'**
  String get faqContactSupportAnswer;

  /// No description provided for @needMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Need more help?'**
  String get needMoreHelp;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @supportResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Our team typically replies within a few hours.'**
  String get supportResponseTime;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start a chat'**
  String get startChat;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose an avatar'**
  String get chooseAvatar;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @trendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// No description provided for @topGainers.
  ///
  /// In en, this message translates to:
  /// **'Top Gainers'**
  String get topGainers;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @weeklyProfit.
  ///
  /// In en, this message translates to:
  /// **'Weekly Profit'**
  String get weeklyProfit;

  /// No description provided for @marketOverview.
  ///
  /// In en, this message translates to:
  /// **'Market Overview'**
  String get marketOverview;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cryptoMarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Crypto Market'**
  String get cryptoMarketTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @noCoinsFound.
  ///
  /// In en, this message translates to:
  /// **'No coins found'**
  String get noCoinsFound;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found for \"{query}\"'**
  String noResultsFound(Object query);

  /// No description provided for @tapAnyCoin.
  ///
  /// In en, this message translates to:
  /// **'Tap any coin to view price and buy'**
  String get tapAnyCoin;

  /// No description provided for @noTrendingCoinsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No trending coins available'**
  String get noTrendingCoinsAvailable;

  /// No description provided for @noTopGainersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No top gainers available'**
  String get noTopGainersAvailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
