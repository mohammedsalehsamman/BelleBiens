// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Belle Biens';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navShop => 'المتجر';

  @override
  String get navDesigner => 'صمّم باقتك';

  @override
  String get navOrders => 'طلباتي';

  @override
  String get navAccount => 'حسابي';

  @override
  String get comingSoon => 'قيد البناء';

  @override
  String comingSoonBody(String sprint) {
    return 'هذه الشاشة تُبنى في سبرنت $sprint.';
  }

  @override
  String environmentBadge(String name) {
    return 'بيئة: $name';
  }

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonEdit => 'تعديل';

  @override
  String get commonOr => 'أو';

  @override
  String get commonLater => 'لاحقاً';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get errorNetwork =>
      'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';

  @override
  String get errorTimeout => 'الاتصال بطيء. حاول مرة أخرى بعد قليل.';

  @override
  String get errorGeneric => 'حدث خطأ غير متوقع. حاول مرة أخرى بعد قليل.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get onboardingBrowseAsGuest => 'تصفّح كضيف';

  @override
  String get onboardingPhotoLabel => 'صورة: باقة ورد من المحل';

  @override
  String get onboardingBadge => 'ورد · حلويات · قهوة · هدايا';

  @override
  String get onboardingEyebrow => 'BELLE BIENS · DAMASCUS';

  @override
  String get onboardingTitle => 'أهلاً بك في Belle Biens';

  @override
  String get onboardingBody =>
      'ورد طازج، كيك وحلويات، قهوة وماتشا، وهدايا من فرعنا في أبو رمانة.';

  @override
  String get onboardingDesignTitle => 'صمّم باقتك بنفسك';

  @override
  String get onboardingDesignBody =>
      'اختر الورد والتغليف وشاهد الباقة والسعر مباشرة.';

  @override
  String get onboardingDeliveryTitle => 'توصيل داخل دمشق أو استلام من المحل';

  @override
  String get onboardingDeliveryBody => 'اليوم أو غداً أو بتاريخ مناسبتك.';

  @override
  String get onboardingWhatsappTitle => 'واتساب متاح دائماً';

  @override
  String get onboardingWhatsappBody => 'اسأل المحل أو أكّد طلبك برسالة.';

  @override
  String get onboardingCreateAccount => 'إنشاء حساب';

  @override
  String get onboardingSignIn => 'تسجيل الدخول';

  @override
  String get onboardingContinueAsGuest => 'المتابعة كضيف';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginHeading => 'مرحباً بعودتك';

  @override
  String get loginBody =>
      'أدخل رقم هاتفك لنرسل لك رمز تحقق، أو سجّل الدخول بالبريد.';

  @override
  String get loginTabPhone => 'رقم الهاتف';

  @override
  String get loginTabEmail => 'البريد الإلكتروني';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => '0944 123 456';

  @override
  String get phoneHelper =>
      'يقبل ⁦09XXXXXXXX⁩ أو ⁦+9639XXXXXXXX⁩، وأرقام دولية للمغتربين.';

  @override
  String get phoneInvalid =>
      'رقم الهاتف غير صحيح. اكتبه بالشكل ⁦09XXXXXXXX⁩ أو ⁦+9639XXXXXXXX⁩، أو رقماً دولياً يبدأ بـ ⁦+⁩.';

  @override
  String get loginSendCode => 'إرسال رمز التحقق';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get emailInvalid => 'اكتب بريداً إلكترونياً صحيحاً.';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordRequired => 'اكتب كلمة المرور.';

  @override
  String get loginWithEmail => 'تسجيل الدخول';

  @override
  String get loginGoogle => 'المتابعة بحساب Google';

  @override
  String get loginNoAccount => 'ليس لديك حساب؟';

  @override
  String get loginBrowseAsGuest => 'التصفّح كضيف';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerHeading => 'أنشئ حسابك';

  @override
  String get registerBody =>
      'احفظ عناوينك وتصاميمك وتابع طلباتك، وتذكّر مناسبات من تحب.';

  @override
  String get nameLabel => 'الاسم الكامل';

  @override
  String get nameHint => 'مثال: سارة الأحمد';

  @override
  String get nameRequired => 'اكتب اسمك.';

  @override
  String get mobileLabel => 'رقم الموبايل';

  @override
  String get mobileHint => '09XX XXX XXX';

  @override
  String get mobileHelper => 'سنرسل رمز تحقق لتأكيد الرقم.';

  @override
  String get emailOptionalLabel => 'البريد الإلكتروني (اختياري)';

  @override
  String get areaLabel => 'منطقتك في دمشق (لاقتراح التوصيل)';

  @override
  String get areaHelper => 'القائمة تأتي من مناطق التوصيل التي يحددها المحل.';

  @override
  String get areaAbuRummaneh => 'أبو رمانة';

  @override
  String get areaMalki => 'المالكي';

  @override
  String get areaMazzeh => 'المزة';

  @override
  String get areaShaalan => 'الشعلان';

  @override
  String get areaQassaa => 'القصاع';

  @override
  String get areaOther => 'منطقة أخرى';

  @override
  String get termsAccept => 'أوافق على شروط الاستخدام وسياسة الخصوصية.';

  @override
  String get termsRequired =>
      'يجب الموافقة على شروط الاستخدام وسياسة الخصوصية لإنشاء حساب.';

  @override
  String get marketingOptIn =>
      'أرغب باستلام العروض وتذكير المناسبات (يمكن إلغاؤها لاحقاً).';

  @override
  String get registerSubmit => 'إنشاء الحساب والتحقق';

  @override
  String get registerGoogle => 'التسجيل بحساب Google';

  @override
  String get registerHaveAccount => 'لديك حساب؟';

  @override
  String get otpTitle => 'رمز التحقق';

  @override
  String get otpHeading => 'أدخل الرمز المرسل إليك';

  @override
  String otpSentSms(int length) {
    return 'أرسلنا رمزاً من $length أرقام برسالة SMS إلى';
  }

  @override
  String otpSentWhatsapp(int length) {
    return 'أرسلنا رمزاً من $length أرقام عبر واتساب إلى';
  }

  @override
  String get otpFieldLabel => 'رمز التحقق';

  @override
  String otpResendIn(String time) {
    return 'يمكنك طلب رمز جديد خلال $time';
  }

  @override
  String get otpResendSms => 'أرسل رمزاً جديداً';

  @override
  String get otpSendWhatsapp => 'أرسل الرمز عبر واتساب بدلاً من SMS';

  @override
  String get otpConfirm => 'تأكيد';

  @override
  String get otpNotice =>
      'الرمز صالح لمدة 5 دقائق، ويمكنك المحاولة 5 مرات. لم يصلك؟ تواصل معنا على واتساب.';

  @override
  String otpAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بقيت $count محاولة.',
      few: 'بقيت $count محاولات.',
      two: 'بقيت محاولتان.',
      one: 'بقيت محاولة واحدة.',
    );
    return '$_temp0';
  }

  @override
  String get completeTitle => 'أكمل حسابك';

  @override
  String get completeHeading => 'خطوة أخيرة';

  @override
  String get completeBody =>
      'أخبرنا باسمك ووافق على الشروط لنحفظ طلباتك وعناوينك.';

  @override
  String get completeSubmit => 'حفظ والمتابعة';

  @override
  String get notifyLater => 'لاحقاً';

  @override
  String get notifyHeading => 'ابقَ على اطلاع بطلباتك';

  @override
  String get notifyBody =>
      'فعّل الإشعارات لتعرف حالة طلبك ونذكّرك بمناسباتك. لن نرسل عروضاً إلا إذا وافقت عليها.';

  @override
  String get notifyOrderTitle => 'حالة الطلب';

  @override
  String get notifyOrderBody => 'عند تأكيد طلبك، وخروجه للتوصيل، ووصوله.';

  @override
  String get notifyOccasionTitle => 'تذكير المناسبات';

  @override
  String get notifyOccasionBody => 'قبل أعياد الميلاد والذكريات التي تحفظها.';

  @override
  String get notifyOffersTitle => 'ورد اليوم والعروض';

  @override
  String get notifyOffersBody => 'اختياري، ويمكن إيقافه من الإعدادات.';

  @override
  String get notifyEnable => 'تفعيل الإشعارات';

  @override
  String get notifySystemHint => 'سيظهر بعدها طلب الإذن من نظام هاتفك.';

  @override
  String get accountGuestTitle => 'أنت تتصفّح كضيف';

  @override
  String get accountGuestBody =>
      'سجّل الدخول لحفظ عناوينك وتصاميمك ومتابعة طلباتك.';

  @override
  String accountHello(String name) {
    return 'أهلاً $name';
  }

  @override
  String get accountSignOut => 'تسجيل الخروج';

  @override
  String get accountLanguage => 'اللغة';
}
