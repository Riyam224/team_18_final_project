// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get market => 'السوق';

  @override
  String get portfolio => 'المحفظة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get portfolioTitle => 'المحفظة';

  @override
  String get totalValue => 'القيمة الإجمالية';

  @override
  String get myHoldings => 'حيازاتي';

  @override
  String get recentTransactions => 'المعاملات الأخيرة';

  @override
  String get buyTransaction => 'شراء';

  @override
  String get sellTransaction => 'بيع';

  @override
  String get hour => 'ساعة';

  @override
  String get hours => 'ساعات';

  @override
  String get day => 'يوم';

  @override
  String get days => 'أيام';

  @override
  String get ago => 'منذ';

  @override
  String get billingPayment => 'الفواتير/الدفع';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get primaryCard => 'البطاقة الأساسية';

  @override
  String get backupCard => 'البطاقة الاحتياطية';

  @override
  String get cardNumberHidden => '**** **** **** ';

  @override
  String get cardVisa => 'فيزا';

  @override
  String get cardMastercard => 'ماستركارد';

  @override
  String get billing => 'الفواتير';

  @override
  String get viewInvoices => 'عرض الفواتير';

  @override
  String get addNewPaymentMethod => 'إضافة طريقة دفع جديدة';

  @override
  String get managePaymentDetails => 'إدارة تفاصيل الدفع';

  @override
  String get faqSupport => 'الأسئلة الشائعة والدعم';

  @override
  String get popularQuestions => 'الأسئلة الشائعة';

  @override
  String get faqUpdateBillingQuestion =>
      'كيف يمكنني تحديث طريقة الدفع الخاصة بي؟';

  @override
  String get faqUpdateBillingAnswer =>
      'انتقل إلى الفواتير/الدفع في الإعدادات واضغط على \"إضافة طريقة دفع جديدة\".';

  @override
  String get faqExportInvoicesQuestion => 'هل يمكنني تصدير فواتيري؟';

  @override
  String get faqExportInvoicesAnswer =>
      'نعم، قم بتنزيل نسخة PDF من قائمة الفواتير.';

  @override
  String get faqContactSupportQuestion => 'كيف يمكنني الاتصال بالدعم؟';

  @override
  String get faqContactSupportAnswer =>
      'استخدم نموذج الاتصال أدناه أو أرسل بريدًا إلكترونيًا إلى support@fintech.app.';

  @override
  String get needMoreHelp => 'هل تحتاج المزيد من المساعدة؟';

  @override
  String get contactSupport => 'اتصل بالدعم';

  @override
  String get supportResponseTime => 'يرد فريقنا عادةً في غضون ساعات قليلة.';

  @override
  String get startChat => 'ابدأ محادثة';

  @override
  String get myAccount => 'حسابي';

  @override
  String get chooseAvatar => 'اختر صورة رمزية';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get trendingNow => 'الأكثر رواجًا الآن';

  @override
  String get topGainers => 'الأكثر ربحًا';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get currentBalance => 'الرصيد الحالي';

  @override
  String get weeklyProfit => 'الربح الأسبوعي';

  @override
  String get marketOverview => 'نظرة عامة على السوق';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cryptoMarketTitle => 'سوق العملات الرقمية';

  @override
  String get searchHint => 'بحث';

  @override
  String get noCoinsFound => 'لا توجد عملات';

  @override
  String noResultsFound(Object query) {
    return 'لا توجد نتائج لـ \"$query\"';
  }

  @override
  String get tapAnyCoin => 'اضغط على أي عملة لعرض السعر والشراء';

  @override
  String get noTrendingCoinsAvailable => 'لا توجد عملات رائجة متاحة';

  @override
  String get noTopGainersAvailable => 'لا توجد عملات رابحة متاحة';
}
