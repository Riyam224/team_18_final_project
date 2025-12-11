// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get generalSection => 'عام';

  @override
  String get myAccountTitle => 'حسابي';

  @override
  String get billingPaymentTitle => 'الفواتير/الدفع';

  @override
  String get faqSupportTitle => 'الأسئلة والدعم';

  @override
  String get languageTitle => 'اللغة';

  @override
  String get darkModeTitle => 'الوضع الداكن';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String languageSetSuccess(Object languageName) {
    return 'تم تعيين اللغة إلى $languageName بنجاح';
  }

  @override
  String get languageSetSuccessDescription => 'رسالة تظهر عند تغيير لغة التطبيق بنجاح';

  @override
  String get defaultGuestName => 'ضيف';
}
