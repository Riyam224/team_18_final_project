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
  String get languageSetSuccessDescription =>
      'Message shown when the app language is successfully changed';

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

  @override
  String get home => 'Home';

  @override
  String get market => 'Market';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get settings => 'Settings';

  @override
  String get portfolioTitle => 'Portfolio';

  @override
  String get totalValue => 'Total Value';

  @override
  String get myHoldings => 'My Holdings';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get buyTransaction => 'Buy';

  @override
  String get sellTransaction => 'Sell';

  @override
  String get hour => 'hour';

  @override
  String get hours => 'hours';

  @override
  String get day => 'day';

  @override
  String get days => 'days';

  @override
  String get ago => 'ago';

  @override
  String get billingPayment => 'Billing/Payment';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get primaryCard => 'Primary Card';

  @override
  String get backupCard => 'Backup Card';

  @override
  String get cardNumberHidden => '**** **** **** ';

  @override
  String get cardVisa => 'VISA';

  @override
  String get cardMastercard => 'Mastercard';

  @override
  String get billing => 'Billing';

  @override
  String get viewInvoices => 'View Invoices';

  @override
  String get addNewPaymentMethod => 'Add New Payment Method';

  @override
  String get managePaymentDetails => 'Manage Payment Details';

  @override
  String get faqSupport => 'FAQ & Support';

  @override
  String get popularQuestions => 'Popular Questions';

  @override
  String get faqUpdateBillingQuestion => 'How do I update my billing method?';

  @override
  String get faqUpdateBillingAnswer =>
      'Go to Billing/Payment in Settings, select your primary card, and tap “Edit” to update details or add a new method.';

  @override
  String get faqExportInvoicesQuestion => 'Can I export my invoices?';

  @override
  String get faqExportInvoicesAnswer =>
      'Yes. From Billing/Payment, choose “View Invoices” and tap the export icon to download a PDF or send it to your email.';

  @override
  String get faqContactSupportQuestion => 'How do I contact support?';

  @override
  String get faqContactSupportAnswer =>
      'Use the “Start Chat” button in the support section or email support@team18.app. Our team typically responds within 15 minutes.';

  @override
  String get needMoreHelp => 'Need more help?';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get supportResponseTime => 'We usually respond within 15 minutes.';

  @override
  String get startChat => 'Start Chat';

  @override
  String get myAccount => 'My Account';

  @override
  String get chooseAvatar => 'Choose an avatar';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get trendingNow => 'Trending Now';

  @override
  String get topGainers => 'Top Gainers';

  @override
  String get viewAll => 'View all';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get weeklyProfit => 'Weekly Profit';

  @override
  String get marketOverview => 'Market Overview';

  @override
  String get retry => 'Retry';

  @override
  String get cryptoMarketTitle => 'Crypto Market';

  @override
  String get searchHint => 'Search';

  @override
  String get noCoinsFound => 'No coins found';

  @override
  String noResultsFound(Object query) {
    return 'No results found for \"$query\"';
  }

  @override
  String get tapAnyCoin => 'Tap any coin to view price and buy';

  @override
  String get noTrendingCoinsAvailable => 'No trending coins available';

  @override
  String get noTopGainersAvailable => 'No top gainers available';
}
