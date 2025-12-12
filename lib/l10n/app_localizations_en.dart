// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
  String get addNewPaymentMethod => 'Add new payment method';

  @override
  String get managePaymentDetails => 'Manage payment details';

  @override
  String get faqSupport => 'FAQ & Support';

  @override
  String get popularQuestions => 'Popular questions';

  @override
  String get faqUpdateBillingQuestion => 'How do I update my billing method?';

  @override
  String get faqUpdateBillingAnswer =>
      'Go to Billing/Payment in Settings and tap \"Add new payment method\".';

  @override
  String get faqExportInvoicesQuestion => 'Can I export my invoices?';

  @override
  String get faqExportInvoicesAnswer =>
      'Yes, download a PDF copy from the invoices list.';

  @override
  String get faqContactSupportQuestion => 'How do I contact support?';

  @override
  String get faqContactSupportAnswer =>
      'Use the contact form below or email support@fintech.app.';

  @override
  String get needMoreHelp => 'Need more help?';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get supportResponseTime =>
      'Our team typically replies within a few hours.';

  @override
  String get startChat => 'Start a chat';

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
