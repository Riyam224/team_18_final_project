import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Lightweight manual localization loader (replaces generated file after merge conflicts).
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <
      LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settingsTitle': 'Settings',
      'generalSection': 'General',
      'myAccountTitle': 'My Account',
      'billingPaymentTitle': 'Billing/Payment',
      'faqSupportTitle': 'FAQ & Support',
      'languageTitle': 'Language',
      'darkModeTitle': 'Dark Mode',
      'chooseLanguage': 'Choose Language',
      'cancelButton': 'Cancel',
      'languageEnglish': 'English',
      'languageArabic': 'Arabic',
      'languageSetSuccess': 'Language set to {languageName} successfully',
      'languageSetSuccessDescription':
          'Message shown when the app language is successfully changed',
      'defaultGuestName': 'Guest',
      'coinDetailsTitle': 'Coin Details',
      'staticsTitle': 'Statics',
      'aboutCoinTitle': 'About Coin',
      'buttonSell': 'Sell',
      'buttonBuy': 'Buy',
      'marketCap': 'Market Cap',
      'volume24h': 'Volume 24h',
      'availableSupply': 'Available Supply',
      'maxSupply': 'Max Supply',
      'currentPrice': 'Current Price',
      'home': 'Home',
      'market': 'Market',
      'portfolio': 'Portfolio',
      'settings': 'Settings',
      'portfolioTitle': 'Portfolio',
      'totalValue': 'Total Value',
      'myHoldings': 'My Holdings',
      'recentTransactions': 'Recent Transactions',
      'buyTransaction': 'Buy',
      'sellTransaction': 'Sell',
      'hour': 'hour',
      'hours': 'hours',
      'day': 'day',
      'days': 'days',
      'ago': 'ago',
      'billingPayment': 'Billing/Payment',
      'paymentMethods': 'Payment Methods',
      'primaryCard': 'Primary Card',
      'backupCard': 'Backup Card',
      'cardNumberHidden': '**** **** **** ',
      'cardVisa': 'VISA',
      'cardMastercard': 'Mastercard',
      'billing': 'Billing',
      'viewInvoices': 'View Invoices',
      'addNewPaymentMethod': 'Add New Payment Method',
      'managePaymentDetails': 'Manage Payment Details',
      'faqSupport': 'FAQ & Support',
      'popularQuestions': 'Popular Questions',
      'faqUpdateBillingQuestion': 'How do I update my billing method?',
      'faqUpdateBillingAnswer':
          'Go to Billing/Payment in Settings, select your primary card, and tap “Edit” to update details or add a new method.',
      'faqExportInvoicesQuestion': 'Can I export my invoices?',
      'faqExportInvoicesAnswer':
          'Yes. From Billing/Payment, choose “View Invoices” and tap the export icon to download a PDF or send it to your email.',
      'faqContactSupportQuestion': 'How do I contact support?',
      'faqContactSupportAnswer':
          'Use the “Start Chat” button in the support section or email support@team18.app. Our team typically responds within 15 minutes.',
      'needMoreHelp': 'Need more help?',
      'contactSupport': 'Contact Support',
      'supportResponseTime': 'We usually respond within 15 minutes.',
      'startChat': 'Start Chat',
      'myAccount': 'My Account',
      'chooseAvatar': 'Choose an avatar',
      'language': 'Language',
      'darkMode': 'Dark Mode',
      'trendingNow': 'Trending Now',
      'topGainers': 'Top Gainers',
      'viewAll': 'View all',
      'currentBalance': 'Current Balance',
      'weeklyProfit': 'Weekly Profit',
      'marketOverview': 'Market Overview',
      'retry': 'Retry',
      'cryptoMarketTitle': 'Crypto Market',
      'searchHint': 'Search',
      'noCoinsFound': 'No coins found',
      'noResultsFound': 'No results found for "{query}"',
      'tapAnyCoin': 'Tap any coin to view price and buy',
      'noTrendingCoinsAvailable': 'No trending coins available',
      'noTopGainersAvailable': 'No top gainers available',
    },
    'ar': {
      'settingsTitle': 'الإعدادات',
      'generalSection': 'عام',
      'myAccountTitle': 'حسابي',
      'billingPaymentTitle': 'الفواتير/الدفع',
      'faqSupportTitle': 'الأسئلة والدعم',
      'languageTitle': 'اللغة',
      'darkModeTitle': 'الوضع الداكن',
      'chooseLanguage': 'اختر اللغة',
      'cancelButton': 'إلغاء',
      'languageEnglish': 'الإنجليزية',
      'languageArabic': 'العربية',
      'languageSetSuccess': 'تم تعيين اللغة إلى {languageName} بنجاح',
      'languageSetSuccessDescription':
          'رسالة تظهر عند تغيير لغة التطبيق بنجاح',
      'defaultGuestName': 'ضيف',
      'coinDetailsTitle': 'تفاصيل العملة',
      'staticsTitle': 'الإحصائيات',
      'aboutCoinTitle': 'حول العملة',
      'buttonSell': 'بيع',
      'buttonBuy': 'شراء',
      'marketCap': 'القيمة السوقية',
      'volume24h': 'حجم التداول 24 ساعة',
      'availableSupply': 'العرض المتاح',
      'maxSupply': 'الحد الأقصى للعرض',
      'currentPrice': 'السعر الحالي',
      'home': 'الرئيسية',
      'market': 'السوق',
      'portfolio': 'المحفظة',
      'settings': 'الإعدادات',
      'portfolioTitle': 'المحفظة',
      'totalValue': 'القيمة الإجمالية',
      'myHoldings': 'حيازاتي',
      'recentTransactions': 'المعاملات الأخيرة',
      'buyTransaction': 'شراء',
      'sellTransaction': 'بيع',
      'hour': 'ساعة',
      'hours': 'ساعات',
      'day': 'يوم',
      'days': 'أيام',
      'ago': 'منذ',
      'billingPayment': 'الفواتير/الدفع',
      'paymentMethods': 'طرق الدفع',
      'primaryCard': 'البطاقة الأساسية',
      'backupCard': 'البطاقة الاحتياطية',
      'cardNumberHidden': '**** **** **** ',
      'cardVisa': 'فيزا',
      'cardMastercard': 'ماستركارد',
      'billing': 'الفواتير',
      'viewInvoices': 'عرض الفواتير',
      'addNewPaymentMethod': 'إضافة طريقة دفع جديدة',
      'managePaymentDetails': 'إدارة تفاصيل الدفع',
      'faqSupport': 'الأسئلة الشائعة والدعم',
      'popularQuestions': 'الأسئلة الشائعة',
      'faqUpdateBillingQuestion': 'كيف يمكنني تحديث طريقة الدفع الخاصة بي؟',
      'faqUpdateBillingAnswer':
          'انتقل إلى الفواتير/الدفع في الإعدادات واضغط على \"إضافة طريقة دفع جديدة\".',
      'faqExportInvoicesQuestion': 'هل يمكنني تصدير فواتيري؟',
      'faqExportInvoicesAnswer':
          'نعم، قم بتنزيل نسخة PDF من قائمة الفواتير.',
      'faqContactSupportQuestion': 'كيف يمكنني الاتصال بالدعم؟',
      'faqContactSupportAnswer':
          'استخدم نموذج الاتصال أدناه أو أرسل بريدًا إلكترونيًا إلى support@fintech.app.',
      'needMoreHelp': 'هل تحتاج المزيد من المساعدة؟',
      'contactSupport': 'اتصل بالدعم',
      'supportResponseTime': 'يرد فريقنا عادةً في غضون ساعات قليلة.',
      'startChat': 'ابدأ محادثة',
      'myAccount': 'حسابي',
      'chooseAvatar': 'اختر صورة رمزية',
      'language': 'اللغة',
      'darkMode': 'الوضع الداكن',
      'trendingNow': 'الأكثر رواجًا الآن',
      'topGainers': 'الأكثر ربحًا',
      'viewAll': 'عرض الكل',
      'currentBalance': 'الرصيد الحالي',
      'weeklyProfit': 'الربح الأسبوعي',
      'marketOverview': 'نظرة عامة على السوق',
      'retry': 'إعادة المحاولة',
      'cryptoMarketTitle': 'سوق العملات الرقمية',
      'searchHint': 'بحث',
      'noCoinsFound': 'لا توجد عملات',
      'noResultsFound': 'لا توجد نتائج لـ "{query}"',
      'tapAnyCoin': 'اضغط على أي عملة لعرض السعر والشراء',
      'noTrendingCoinsAvailable': 'لا توجد عملات رائجة متاحة',
      'noTopGainersAvailable': 'لا توجد عملات رابحة متاحة',
    },
  };

  String _string(String key) =>
      _localizedValues[locale.languageCode]?[key] ??
      _localizedValues['en']![key]!;

  // Getters
  String get settingsTitle => _string('settingsTitle');
  String get generalSection => _string('generalSection');
  String get myAccountTitle => _string('myAccountTitle');
  String get billingPaymentTitle => _string('billingPaymentTitle');
  String get faqSupportTitle => _string('faqSupportTitle');
  String get languageTitle => _string('languageTitle');
  String get darkModeTitle => _string('darkModeTitle');
  String get chooseLanguage => _string('chooseLanguage');
  String get cancelButton => _string('cancelButton');
  String get languageEnglish => _string('languageEnglish');
  String get languageArabic => _string('languageArabic');
  String languageSetSuccess(Object languageName) =>
      _string('languageSetSuccess').replaceAll('{languageName}', '$languageName');
  String get languageSetSuccessDescription =>
      _string('languageSetSuccessDescription');
  String get defaultGuestName => _string('defaultGuestName');
  String get coinDetailsTitle => _string('coinDetailsTitle');
  String get staticsTitle => _string('staticsTitle');
  String get aboutCoinTitle => _string('aboutCoinTitle');
  String get buttonSell => _string('buttonSell');
  String get buttonBuy => _string('buttonBuy');
  String get marketCap => _string('marketCap');
  String get volume24h => _string('volume24h');
  String get availableSupply => _string('availableSupply');
  String get maxSupply => _string('maxSupply');
  String get currentPrice => _string('currentPrice');
  String get home => _string('home');
  String get market => _string('market');
  String get portfolio => _string('portfolio');
  String get settings => _string('settings');
  String get portfolioTitle => _string('portfolioTitle');
  String get totalValue => _string('totalValue');
  String get myHoldings => _string('myHoldings');
  String get recentTransactions => _string('recentTransactions');
  String get buyTransaction => _string('buyTransaction');
  String get sellTransaction => _string('sellTransaction');
  String get hour => _string('hour');
  String get hours => _string('hours');
  String get day => _string('day');
  String get days => _string('days');
  String get ago => _string('ago');
  String get billingPayment => _string('billingPayment');
  String get paymentMethods => _string('paymentMethods');
  String get primaryCard => _string('primaryCard');
  String get backupCard => _string('backupCard');
  String get cardNumberHidden => _string('cardNumberHidden');
  String get cardVisa => _string('cardVisa');
  String get cardMastercard => _string('cardMastercard');
  String get billing => _string('billing');
  String get viewInvoices => _string('viewInvoices');
  String get addNewPaymentMethod => _string('addNewPaymentMethod');
  String get managePaymentDetails => _string('managePaymentDetails');
  String get faqSupport => _string('faqSupport');
  String get popularQuestions => _string('popularQuestions');
  String get faqUpdateBillingQuestion => _string('faqUpdateBillingQuestion');
  String get faqUpdateBillingAnswer => _string('faqUpdateBillingAnswer');
  String get faqExportInvoicesQuestion => _string('faqExportInvoicesQuestion');
  String get faqExportInvoicesAnswer => _string('faqExportInvoicesAnswer');
  String get faqContactSupportQuestion => _string('faqContactSupportQuestion');
  String get faqContactSupportAnswer => _string('faqContactSupportAnswer');
  String get needMoreHelp => _string('needMoreHelp');
  String get contactSupport => _string('contactSupport');
  String get supportResponseTime => _string('supportResponseTime');
  String get startChat => _string('startChat');
  String get myAccount => _string('myAccount');
  String get chooseAvatar => _string('chooseAvatar');
  String get language => _string('language');
  String get darkMode => _string('darkMode');
  String get trendingNow => _string('trendingNow');
  String get topGainers => _string('topGainers');
  String get viewAll => _string('viewAll');
  String get currentBalance => _string('currentBalance');
  String get weeklyProfit => _string('weeklyProfit');
  String get marketOverview => _string('marketOverview');
  String get retry => _string('retry');
  String get cryptoMarketTitle => _string('cryptoMarketTitle');
  String get searchHint => _string('searchHint');
  String get noCoinsFound => _string('noCoinsFound');
  String noResultsFound(String query) =>
      _string('noResultsFound').replaceAll('{query}', query);
  String get tapAnyCoin => _string('tapAnyCoin');
  String get noTrendingCoinsAvailable => _string('noTrendingCoinsAvailable');
  String get noTopGainersAvailable => _string('noTopGainersAvailable');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
