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

  @override
  String get currencySyp => 'ل.س';

  @override
  String get currencyUsd => '\$';

  @override
  String homeDeliveryTo(String area) {
    return 'التوصيل إلى: $area';
  }

  @override
  String get homeSearchHint => 'ابحث عن باقة، كيك، هدية…';

  @override
  String get homeDesignerEyebrow => 'مصمّم الباقات';

  @override
  String get homeDesignerTitle => 'صمّم باقتك على ذوقك';

  @override
  String get homeDesignerBody =>
      'اختر الورد والتغليف والإضافات، وشاهد الباقة والسعر قبل الطلب.';

  @override
  String get homeDesignerCta => 'ابدأ التصميم';

  @override
  String get homeOrderNow => 'اطلب الآن';

  @override
  String get homeOrderNowSub => 'توصيل أو استلام';

  @override
  String get homeWhatsapp => 'واتساب';

  @override
  String get homeWhatsappSub => 'اسأل المحل';

  @override
  String get homeCategories => 'التصنيفات';

  @override
  String get homeTodayTitle => 'ورد اليوم';

  @override
  String get homeTodaySub => 'ما هو متوفر طازجاً اليوم في المحل';

  @override
  String get homeCakesTitle => 'كيك وحلويات';

  @override
  String get homeCakesSub => 'تحضير يومي في مطبخ المحل';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get shopOpenNow => 'مفتوح الآن';

  @override
  String get shopBusyNow => 'مشغول الآن';

  @override
  String get shopClosedNow => 'مغلق الآن';

  @override
  String shopUntil(String time) {
    return 'حتى $time';
  }

  @override
  String shopOpensAt(String time) {
    return 'يفتح $time';
  }

  @override
  String get branchHoursLabel => 'ساعات العمل';

  @override
  String branchHoursDaily(String open, String close) {
    return 'يومياً $open – $close';
  }

  @override
  String get branchMap => 'الخريطة';

  @override
  String get branchInstagram => 'إنستغرام';

  @override
  String get branchTitle => 'الفرع والتواصل';

  @override
  String get branchDirections => 'الاتجاهات';

  @override
  String get branchCall => 'اتصال';

  @override
  String get branchPolicies => 'السياسات';

  @override
  String branchPartners(String list) {
    return 'نتواجد أيضاً على $list';
  }

  @override
  String get branchContactSoon => 'يضيف المحل رقم الهاتف وواتساب قريباً.';

  @override
  String get badgeBestSeller => 'الأكثر طلباً';

  @override
  String get badgeSeasonal => 'موسمي';

  @override
  String get badgeToday => 'ورد اليوم';

  @override
  String get badgeTodayOnly => 'متوفر اليوم فقط';

  @override
  String get badgeLimited => 'كمية محدودة';

  @override
  String get badgeUnavailable => 'غير متوفر اليوم';

  @override
  String priceFrom(String price) {
    return 'من ⁨$price⁩';
  }

  @override
  String priceApprox(String price) {
    return '≈ $price';
  }

  @override
  String get shopTitle => 'المتجر';

  @override
  String get shopSearchHint => 'ابحث في المتجر';

  @override
  String get shopFilters => 'الفلاتر';

  @override
  String shopFiltersCount(int count) {
    return 'الفلاتر · $count';
  }

  @override
  String get shopAll => 'الكل';

  @override
  String shopResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج',
      many: '$count منتجاً',
      few: '$count منتجات',
      two: 'منتجان',
      one: 'منتج واحد',
      zero: 'لا منتجات',
    );
    return '$_temp0';
  }

  @override
  String shopSortedBy(String sort) {
    return 'مرتبة حسب: $sort';
  }

  @override
  String get sortPopular => 'الأكثر طلباً';

  @override
  String get sortNewest => 'الأحدث';

  @override
  String get sortPriceAsc => 'السعر: من الأقل';

  @override
  String get sortPriceDesc => 'السعر: من الأعلى';

  @override
  String get shopSortTitle => 'ترتيب المنتجات';

  @override
  String get shopOpenForOrders => 'مفتوح للطلب';

  @override
  String get shopLoadMore => 'عرض المزيد';

  @override
  String get shopEmpty => 'لا توجد منتجات بهذه الفلاتر.';

  @override
  String get shopClearFilters => 'مسح الفلاتر';

  @override
  String get filtersOccasion => 'المناسبة';

  @override
  String get filtersColor => 'اللون';

  @override
  String get filtersFlowerType => 'نوع الورد';

  @override
  String filtersPrice(String currency) {
    return 'السعر ($currency)';
  }

  @override
  String get filtersAvailableToday => 'متوفر اليوم فقط';

  @override
  String get filtersDeliverableToday => 'يمكن توصيله اليوم';

  @override
  String get filtersClearAll => 'مسح الكل';

  @override
  String filtersShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عرض $count منتج',
      many: 'عرض $count منتجاً',
      few: 'عرض $count منتجات',
      two: 'عرض منتجين',
      one: 'عرض منتج واحد',
      zero: 'لا توجد منتجات',
    );
    return '$_temp0';
  }

  @override
  String get filtersShowResults => 'عرض النتائج';

  @override
  String get searchRecent => 'عمليات البحث الأخيرة';

  @override
  String get searchClear => 'مسح';

  @override
  String searchTab(String name, int count) {
    return '$name · $count';
  }

  @override
  String searchNoResults(String query) {
    return 'لم نجد نتائج لـ «$query». جرّب كلمة أخرى.';
  }

  @override
  String get searchOfflineNote =>
      'أنت غير متصل. نبحث في المنتجات المحفوظة على جهازك.';

  @override
  String get todayNotice =>
      'يحدّث المحل هذه القائمة يومياً. تنتهي صلاحيتها منتصف الليل بتوقيت دمشق.';

  @override
  String todayLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'متبقٍ $count',
      few: 'متبقٍ $count قطع',
      two: 'بقيت قطعتان',
      one: 'بقيت قطعة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get todayAvailable => 'متوفرة';

  @override
  String get todayStemsTitle => 'ورد متاح للتصميم اليوم';

  @override
  String todayStem(String name, String count) {
    return '$name · $count';
  }

  @override
  String get todayDesignCta => 'صمّم باقة من ورد اليوم';

  @override
  String get todayEmpty => 'لم ينشر المحل قائمة اليوم بعد. عد لاحقاً.';

  @override
  String get occasionTabFlowers => 'ورد';

  @override
  String get occasionTabCakes => 'كيك';

  @override
  String get occasionTabExtras => 'إضافات';

  @override
  String occasionDesignCta(String occasion) {
    return 'صمّم باقة $occasion';
  }

  @override
  String occasionDesignSub(String occasion) {
    return 'تبدأ بمناسبة «$occasion» محددة مسبقاً';
  }

  @override
  String get productReadyBouquet => 'باقة جاهزة';

  @override
  String productSelected(String group, String option) {
    return '$group المختار: $option';
  }

  @override
  String get productCustomizeTitle => 'تريد لمسة خاصة؟';

  @override
  String get productCustomizeBody =>
      'افتح هذه الباقة في المصمّم وغيّر الورد والألوان.';

  @override
  String get productCustomize => 'خصّصها';

  @override
  String get productIncluded => '(مشمول بالسعر)';

  @override
  String get optionIncluded => 'مشمول';

  @override
  String productEarliest(String when) {
    return 'أقرب توصيل: $when';
  }

  @override
  String get whenToday => 'اليوم';

  @override
  String get whenTomorrow => 'غداً';

  @override
  String whenInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'بعد $days يوماً',
      few: 'بعد $days أيام',
      two: 'بعد يومين',
    );
    return '$_temp0';
  }

  @override
  String get productDeliveryNote =>
      'التوصيل داخل دمشق حسب المنطقة، أو الاستلام من فرع أبو رمانة مجاناً.';

  @override
  String get productDeliveryPolicy => 'سياسة التوصيل';

  @override
  String get productDisclaimer =>
      'قد تختلف الباقة النهائية قليلاً حسب الورد الطازج المتوفر.';

  @override
  String get productPairingsGift => 'أضف إلى هديتك';

  @override
  String get productPairingsDrink => 'يناسب مع مشروبك';

  @override
  String productAllergens(String list) {
    return 'مسببات الحساسية: $list';
  }

  @override
  String get allergenNuts => 'مكسرات';

  @override
  String get allergenMilk => 'حليب';

  @override
  String get allergenEggs => 'بيض';

  @override
  String get allergenGluten => 'غلوتين';

  @override
  String productLeadTime(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'يُطلب قبل $hours ساعة',
      few: 'يُطلب قبل $hours ساعات',
      two: 'يُطلب قبل ساعتين',
      one: 'يُطلب قبل ساعة',
    );
    return '$_temp0';
  }

  @override
  String get productAskTitle => 'عندك سؤال؟';

  @override
  String get productAskBody => 'راسل المحل على واتساب';

  @override
  String get productTotal => 'المجموع';

  @override
  String get productAddToCart => 'أضف إلى السلة';

  @override
  String productAddWithTotal(String price) {
    return 'أضف · ⁨$price⁩';
  }

  @override
  String get productCartSoon => 'السلة قيد التجهيز وتصل في التحديث القادم.';

  @override
  String get productUnavailable =>
      'غير متوفر اليوم. احفظه في المفضلة واطلبه لاحقاً.';

  @override
  String get productFavoriteAdd => 'أضف إلى المفضلة';

  @override
  String get productFavoriteRemove => 'أزل من المفضلة';

  @override
  String get productQuantity => 'الكمية';

  @override
  String get favoriteSignIn => 'سجّل الدخول لتحفظ منتجاتك المفضلة.';

  @override
  String get favoritesTitle => 'المفضلة';

  @override
  String get favoritesEmpty =>
      'لم تحفظ أي منتج بعد. اضغط على القلب في صفحة المنتج.';

  @override
  String get offlineBanner => 'أنت غير متصل. نعرض آخر نسخة محفوظة.';

  @override
  String get loadFailed => 'تعذّر التحميل.';

  @override
  String imagePlaceholder(String name) {
    return 'صورة $name';
  }

  @override
  String get designerTitle => 'صمّم باقتك';

  @override
  String designerStepCaption(int current, String name) {
    return 'الخطوة $current من 4 · $name';
  }

  @override
  String get designerStepOccasion => 'المناسبة والحجم';

  @override
  String get designerStepFlowers => 'الورد والخضرة';

  @override
  String get designerStepWrap => 'التغليف والإضافات';

  @override
  String get designerStepCard => 'البطاقة والمعاينة';

  @override
  String get designerPreviewLabel => 'معاينة حية للباقة';

  @override
  String get designerLive => 'مباشر';

  @override
  String designerStems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count وردة',
      few: '$count ورود',
      two: 'وردتان',
      one: 'وردة واحدة',
      zero: 'بدون ورد',
    );
    return '$_temp0';
  }

  @override
  String get designerPickFlowers => 'اختر الورد ليظهر السعر';

  @override
  String get designerOccasion => 'المناسبة';

  @override
  String get designerSize => 'الحجم';

  @override
  String designerSizeRange(int min, int max) {
    return '$min – $max وردة';
  }

  @override
  String get designerSizeNote => 'عدد الورد في كل حجم يحدده المحل.';

  @override
  String get designerPalette => 'لوحة الألوان';

  @override
  String get designerOptional => '(اختياري)';

  @override
  String get designerNextFlowers => 'التالي: اختيار الورد';

  @override
  String get designerNextWrap => 'التالي: التغليف';

  @override
  String get designerNextCard => 'التالي: البطاقة والمعاينة';

  @override
  String get designerPrevious => 'السابق';

  @override
  String designerStemsRange(String stems, int min, int max) {
    return '$stems من $min – $max';
  }

  @override
  String designerSizeName(String size) {
    return 'حجم $size';
  }

  @override
  String get designerMainFlowers => 'الورد الأساسي';

  @override
  String get designerPerStem => 'السعر للوردة';

  @override
  String designerAvailableCount(String price, String count) {
    return '$price · متوفر $count';
  }

  @override
  String designerAvailable(String price) {
    return '$price · متوفر';
  }

  @override
  String get designerUnavailable => 'غير متوفر اليوم';

  @override
  String get designerSuggest => 'اقترح بديلاً';

  @override
  String get designerFillersGreens => 'الورد المساعد والخضرة';

  @override
  String designerPerSprig(String price) {
    return '$price للغصن';
  }

  @override
  String get designerStockNote =>
      'الأسعار والكميات المتوفرة من «ورد اليوم» الذي يحدّثه المحل.';

  @override
  String designerTooFew(int min) {
    return 'هذا الحجم يحتاج $min وردة على الأقل.';
  }

  @override
  String designerTooMany(int max) {
    return 'هذا الحجم يتسع لـ $max وردة كحد أقصى.';
  }

  @override
  String get designerFitsPalette => 'يناسب لوحتك';

  @override
  String get designerWrap => 'التغليف';

  @override
  String get designerRibbon => 'الشريط';

  @override
  String designerRibbonNote(String price) {
    return 'شريط ساتان · $price';
  }

  @override
  String get designerExtras => 'إضافات';

  @override
  String get designerMode3d => '3D';

  @override
  String get designerModeAi => 'واقعية AI';

  @override
  String get designerModeSoon =>
      'المعاينة ثلاثية الأبعاد والواقعية تصل في الإصدار الثالث؛ قبله تظهر معاينة 2D فقط.';

  @override
  String get designerCard => 'بطاقة الإهداء';

  @override
  String get designerRecipient => 'اسم المستلم';

  @override
  String get designerMessage => 'الرسالة';

  @override
  String designerMessageCount(int count, int max) {
    return '$count / $max';
  }

  @override
  String get designerNoCard => 'بدون بطاقة';

  @override
  String get designerSummary => 'ملخص الباقة';

  @override
  String designerLineQty(String name, int qty) {
    return '$name × $qty';
  }

  @override
  String designerWrapLine(String name) {
    return 'تغليف $name';
  }

  @override
  String designerRibbonLine(String name) {
    return 'شريط $name';
  }

  @override
  String get designerAssemblyFee => 'رسوم التنسيق';

  @override
  String get designerSave => 'احفظ في تصاميمي';

  @override
  String get designerSaveSoon =>
      'حفظ التصاميم في حسابك يصل قريباً. تصميمك محفوظ على هذا الهاتف.';

  @override
  String get designerSend => 'أرسل للمحل';

  @override
  String get designerSendNoNumber => 'يضيف المحل رقم واتساب قريباً.';

  @override
  String get designerWhatsappIntro =>
      'مرحباً، صمّمت هذه الباقة في تطبيق Belle Biens:';

  @override
  String designerWhatsappTotal(String total) {
    return 'المجموع: $total';
  }

  @override
  String designerWhatsappPreview(String link) {
    return 'المعاينة: $link';
  }

  @override
  String get designerAddToCart => 'أضف الباقة إلى السلة';

  @override
  String get designerUndo => 'تراجع';

  @override
  String get designerRedo => 'إعادة';

  @override
  String get designerRestart => 'ابدأ من جديد';

  @override
  String get designerIssueBanner => 'بعض الورد نفد للتو. راجع البدائل.';

  @override
  String get designerFixStems => 'عدّل عدد الورد ليناسب الحجم.';

  @override
  String get substituteTitle => 'بعض الورد نفد للتو';

  @override
  String substituteBody(int available, String name, int qty) {
    return 'بقي $available من $name، وتصميمك يحتاج $qty.';
  }

  @override
  String substituteBodyNone(String name, int qty) {
    return '$name غير متوفر اليوم، وتصميمك يحتاج $qty.';
  }

  @override
  String get substituteChoose => 'اختر بديلاً';

  @override
  String get substituteSamePrice => 'نفس السعر';

  @override
  String get substituteManual => 'تعديل يدوياً';

  @override
  String get substituteApply => 'تطبيق البديل';

  @override
  String get substituteNone =>
      'لا يوجد بديل متوفر الآن. خفّض الكمية أو اختر وردة أخرى.';

  @override
  String substituteOption(String items) {
    return '$items';
  }

  @override
  String get cartTitle => 'السلة';

  @override
  String cartTitleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'السلة · $count قطعة',
      few: 'السلة · $count قطع',
      two: 'السلة · قطعتان',
      one: 'السلة · قطعة واحدة',
      zero: 'السلة',
    );
    return '$_temp0';
  }

  @override
  String get cartOpen => 'السلة';

  @override
  String get cartCheckout => 'إتمام الطلب';

  @override
  String get cartEmptyTitle => 'سلتك فارغة';

  @override
  String get cartEmptyBody => 'ابدأ بباقة من ورد اليوم، أو صمّم باقتك بنفسك.';

  @override
  String get cartBrowseToday => 'تصفّح ورد اليوم';

  @override
  String get cartEditDesign => 'تعديل التصميم';

  @override
  String cartCardMessage(String message) {
    return 'بطاقة: «$message»';
  }

  @override
  String cartRemove(String name) {
    return 'إزالة $name';
  }

  @override
  String cartLeadNotice(int hours, String when) {
    return 'يحتاج بعض ما في سلتك $hours ساعة للتجهيز، لذلك أقرب موعد للطلب كاملاً هو $when.';
  }

  @override
  String cartWhenToday(String time) {
    return 'اليوم $time';
  }

  @override
  String cartWhenTomorrow(String time) {
    return 'غداً $time';
  }

  @override
  String cartWhenDate(String date, String time) {
    return '$date $time';
  }

  @override
  String get cartCoupon => 'كوبون خصم';

  @override
  String get cartCouponApply => 'تطبيق';

  @override
  String get cartCouponRemove => 'إزالة الكوبون';

  @override
  String cartCouponApplied(String code) {
    return 'تم تطبيق $code';
  }

  @override
  String get cartCouponNotFound => 'هذا الكوبون غير صحيح.';

  @override
  String get cartCouponExpired => 'انتهت صلاحية هذا الكوبون.';

  @override
  String get cartCouponUsedUp => 'استُخدم هذا الكوبون بالكامل.';

  @override
  String cartCouponMinOrder(String amount) {
    return 'يعمل هذا الكوبون عند طلب بقيمة ⁨$amount⁩ أو أكثر.';
  }

  @override
  String get cartProducts => 'المنتجات';

  @override
  String get cartDiscount => 'الخصم';

  @override
  String get cartDelivery => 'التوصيل';

  @override
  String get cartDeliveryLater => 'يُحسب حسب المنطقة';

  @override
  String get cartRounding => 'تقريب';

  @override
  String get cartSubtotal => 'المجموع الفرعي';

  @override
  String get cartSuggestions => 'قد يعجبك أيضاً';

  @override
  String get cartContinue => 'متابعة للتوصيل';

  @override
  String get cartFixIssues => 'عدّل ما في السلة قبل المتابعة.';

  @override
  String get cartAdded => 'أُضيف إلى السلة';

  @override
  String get cartView => 'عرض السلة';

  @override
  String get cartUpdated => 'حُدّثت الباقة في السلة';

  @override
  String get cartUpdateDesign => 'حدّث الباقة في السلة';

  @override
  String get issueProductUnavailable => 'غير متوفر الآن.';

  @override
  String get issueOptionUnavailable => 'أحد الخيارات لم يعد متوفراً.';

  @override
  String issueStock(int count) {
    return 'المتوفر الآن $count فقط.';
  }

  @override
  String get issueItemUnavailable => 'بعض محتويات هذه الباقة نفدت.';

  @override
  String get issueStems => 'عدد الورد لا يناسب الحجم.';

  @override
  String get issueBox => 'محتوى الصندوق لا يناسب أركانه.';

  @override
  String get issueInscription => 'الرسالة على الكيك غير مقبولة لهذا المنتج.';

  @override
  String get boxTitle => 'صندوق ورد وحلويات';

  @override
  String get boxHomeBody => 'اختر ورد ركن، وحلويات الركن الآخر.';

  @override
  String get boxHomeCta => 'ركّب صندوقك';

  @override
  String get boxType => 'نوع الصندوق';

  @override
  String boxUpTo(int count) {
    return 'حتى $count';
  }

  @override
  String boxFilled(int count, int capacity) {
    return '$count من $capacity';
  }

  @override
  String get boxPiece => 'قطعة';

  @override
  String get boxLeadNote =>
      'مدة التجهيز = أطول مدة بين محتويات الصندوق. يحسب النظام أقرب موعد تلقائياً.';

  @override
  String boxSummary(String name, String total) {
    return '$name · $total';
  }

  @override
  String get cakeMessage => 'رسالة على الكيك';

  @override
  String cakeMessageCount(int count, int max) {
    return '$count / $max';
  }

  @override
  String get cakePhoto => 'أرفق صورة للتصميم المطلوب';

  @override
  String get cakePhotoHint => 'اختياري · JPG أو PNG';

  @override
  String get cakePhotoAttached => 'أُرفقت الصورة';

  @override
  String get cakePhotoRemove => 'إزالة الصورة';

  @override
  String get cakePhotoFailed => 'تعذّر رفع الصورة. حاول مرة أخرى.';

  @override
  String productAdded(String name) {
    return 'أُضيف $name إلى السلة';
  }

  @override
  String get checkoutTitle => 'إتمام الطلب';

  @override
  String get checkoutStep1 => '1 من 2 · التوصيل والموعد';

  @override
  String get checkoutStep2 => '2 من 2 · الدفع والمراجعة';

  @override
  String get checkoutHowTitle => 'طريقة الاستلام';

  @override
  String get checkoutDelivery => 'توصيل داخل دمشق';

  @override
  String get checkoutDeliveryHint => 'الرسوم حسب منطقة العنوان';

  @override
  String get checkoutPickup => 'استلام من الفرع';

  @override
  String get checkoutPickupFree => 'مجاناً';

  @override
  String checkoutPickupFreeAt(String address) {
    return 'مجاناً · $address';
  }

  @override
  String get checkoutAddressTitle => 'عنوان التوصيل';

  @override
  String get checkoutAddressChange => 'تغيير';

  @override
  String get checkoutAddressSet => 'حدّد العنوان على الخريطة';

  @override
  String checkoutInZone(String fee) {
    return 'داخل منطقة التوصيل · ⁨$fee⁩';
  }

  @override
  String get checkoutYouTitle => 'بياناتك';

  @override
  String get checkoutYourName => 'اسمك';

  @override
  String get checkoutYourPhone => 'رقم هاتفك';

  @override
  String get checkoutRecipientTitle => 'المستلم';

  @override
  String get checkoutRecipientMe => 'أنا المستلم';

  @override
  String get checkoutRecipientOther => 'شخص آخر';

  @override
  String get checkoutRecipientName => 'اسم المستلم';

  @override
  String get checkoutRecipientPhone => 'رقم هاتف المستلم';

  @override
  String get checkoutHideSender => 'لا تُظهر اسمي للمستلم';

  @override
  String get checkoutDayTitle => 'يوم التوصيل';

  @override
  String get checkoutPickupDayTitle => 'يوم الاستلام';

  @override
  String get checkoutToday => 'اليوم';

  @override
  String get checkoutTomorrow => 'غداً';

  @override
  String get checkoutOtherDate => 'تاريخ آخر';

  @override
  String checkoutUpToDays(int days) {
    return 'حتى $days يوماً';
  }

  @override
  String get checkoutUnavailable => 'غير متاح';

  @override
  String checkoutTodayTooSoon(int hours) {
    return '«اليوم» غير متاح لأن طلبك يحتاج $hours ساعة للتجهيز.';
  }

  @override
  String get checkoutDayClosed => 'المحل لا يوصل في هذا اليوم.';

  @override
  String get checkoutTimeTitle => 'الوقت';

  @override
  String checkoutSlot(String start, String end) {
    return '$start – $end';
  }

  @override
  String checkoutSlotFull(String start, String end) {
    return '$start – $end · ممتلئ';
  }

  @override
  String get checkoutNoSlots => 'لا مواعيد متاحة في هذا اليوم. اختر يوماً آخر.';

  @override
  String get checkoutCallBefore => 'اتصل قبل الوصول';

  @override
  String get checkoutNotes => 'ملاحظات للمحل';

  @override
  String checkoutNotesCount(int count) {
    return '$count / 300';
  }

  @override
  String get checkoutWithDelivery => 'مع التوصيل';

  @override
  String get checkoutToPayment => 'متابعة للدفع';

  @override
  String get checkoutNeedAddress => 'حدّد عنوان التوصيل أولاً.';

  @override
  String get checkoutNeedSlot => 'اختر يوم التوصيل ووقته.';

  @override
  String get checkoutNeedName => 'اكتب الاسم.';

  @override
  String get checkoutPickDate => 'اختر التاريخ';

  @override
  String get addressTitle => 'عنوان التوصيل';

  @override
  String addressZoneBadge(String zone) {
    return 'منطقة: $zone';
  }

  @override
  String get addressSearch => 'ابحث عن منطقة';

  @override
  String get addressNoArea => 'لا منطقة توصيل بهذا الاسم.';

  @override
  String addressInZone(String zone, String fee, String eta) {
    return 'العنوان داخل منطقة التوصيل $zone · الرسوم ⁨$fee⁩ · المدة التقريبية $eta.';
  }

  @override
  String get addressOutOfZone => 'هذه النقطة خارج مناطق التوصيل.';

  @override
  String get addressChecking => 'نتحقق من المنطقة…';

  @override
  String get addressMapHint => 'حرّك الخريطة ليقع الدبوس على مكان التوصيل.';

  @override
  String get addressMapLabel => 'خريطة. الدبوس في الوسط هو مكان التوصيل.';

  @override
  String get addressSavedTitle => 'عناويني';

  @override
  String get addressLandmark => 'أقرب معلم';

  @override
  String get addressBuilding => 'البناء';

  @override
  String get addressFloor => 'الطابق';

  @override
  String get addressDetails => 'الشارع وتفاصيل أخرى';

  @override
  String get addressLabel => 'اسم العنوان';

  @override
  String get addressHome => 'البيت';

  @override
  String get addressWork => 'العمل';

  @override
  String get addressOther => 'آخر';

  @override
  String get addressSave => 'احفظ العنوان لطلباتي القادمة';

  @override
  String get addressConfirm => 'تأكيد العنوان';

  @override
  String get paymentMethodTitle => 'طريقة الدفع';

  @override
  String get paymentCash => 'الدفع عند الاستلام';

  @override
  String get paymentCashHint =>
      'نقداً للمندوب أو في المحل. يتصل بك المحل لتأكيد الطلب.';

  @override
  String get paymentShamcash => 'شام كاش';

  @override
  String get paymentShamcashHint =>
      'ادفع من تطبيق شام كاش، ثم أدخل رقم العملية أو صورة الإيصال.';

  @override
  String get paymentStripe => 'بطاقة دولية (Stripe)';

  @override
  String get paymentStripeBadge => 'للمغتربين · USD';

  @override
  String get paymentStripeHint =>
      'تنتقل إلى صفحة Stripe الآمنة. لا نحفظ بيانات بطاقتك.';

  @override
  String get paymentSoon => 'قريباً';

  @override
  String paymentWhenWhere(String when, String where) {
    return '$when · $where';
  }

  @override
  String get paymentPickupWhere => 'الاستلام من الفرع';

  @override
  String paymentRecipient(String name) {
    return 'المستلم: $name';
  }

  @override
  String paymentRecipientHidden(String name) {
    return 'المستلم: $name · بدون إظهار المرسل';
  }

  @override
  String get paymentInvoice => 'الفاتورة';

  @override
  String paymentProducts(int count) {
    return 'المنتجات ($count)';
  }

  @override
  String paymentDeliveryZone(String zone) {
    return 'التوصيل · $zone';
  }

  @override
  String get paymentTotal => 'الإجمالي';

  @override
  String paymentUsdNote(String usd) {
    return '≈ $usd · سعر الصرف يُثبّت عند تأكيد الطلب';
  }

  @override
  String get paymentWhatsapp => 'أفضّل التأكيد عبر واتساب';

  @override
  String get paymentWhatsappHint => 'نرسل ملخص الطلب ورقمه للمحل';

  @override
  String get paymentTermsLead => 'بتأكيد الطلب أنت توافق على ';

  @override
  String get paymentTermsLink => 'شروط البيع وسياسة الإلغاء';

  @override
  String paymentConfirm(String total) {
    return 'تأكيد الطلب · ⁨$total⁩';
  }

  @override
  String get paymentCartChanged =>
      'تغيّر شيء في سلتك. راجع السلة ثم أكمل الطلب.';

  @override
  String get confirmTitle => 'استلمنا طلبك';

  @override
  String get confirmNumber => 'رقم الطلب';

  @override
  String get confirmPendingShop => 'بانتظار تأكيد المحل';

  @override
  String get confirmWhen => 'الموعد';

  @override
  String get confirmWhere => 'العنوان';

  @override
  String get confirmPickup => 'الاستلام';

  @override
  String get confirmPayment => 'الدفع';

  @override
  String get confirmNextTitle => 'ماذا بعد؟';

  @override
  String get confirmNextCash =>
      'يتصل بك المحل أو يراسلك على واتساب لتأكيد الطلب. يصلك إشعار عند التأكيد.';

  @override
  String get confirmNextDelivery =>
      'يجهّز المحل طلبك حسب الوصفة، ثم يخرج للتوصيل في الموعد.';

  @override
  String get confirmNextPickup =>
      'يجهّز المحل طلبك حسب الوصفة، ويكون جاهزاً للاستلام في الموعد.';

  @override
  String get confirmTrack => 'تتبّع الطلب';

  @override
  String get confirmWhatsapp => 'راسل المحل على واتساب';

  @override
  String get confirmContinue => 'متابعة التسوق';

  @override
  String get confirmGuestTitle => 'طلبت كضيف؟';

  @override
  String get confirmGuestBody =>
      'أنشئ حساباً بنفس الرقم لتحفظ هذا الطلب وعناوينك.';

  @override
  String get confirmGuestAction => 'إنشاء حساب';

  @override
  String orderWhatsappMessage(
    String number,
    String summary,
    String total,
    String when,
  ) {
    return 'مرحباً، طلبت من تطبيق Belle Biens.\nرقم الطلب: $number\n$summary\nالإجمالي: $total\nالموعد: $when\nأرجو تأكيد الطلب.';
  }

  @override
  String get outZoneHeadline => 'هذا العنوان خارج مناطق التوصيل حالياً.';

  @override
  String get outZoneBody => 'نوصل داخل دمشق فقط في المناطق المحددة.';

  @override
  String get outZoneWhatsapp => 'اسأل المحل على واتساب';

  @override
  String get outZonePickup => 'استلم من الفرع';

  @override
  String get outZoneOther => 'اختر عنواناً آخر';

  @override
  String outZoneMessage(String link) {
    return 'مرحباً، هل توصلون إلى هذا العنوان؟ $link';
  }

  @override
  String get shopBusyTitle => 'المحل مشغول حالياً';

  @override
  String shopBusyBody(String time) {
    return 'نستقبل الطلبات لمواعيد تبدأ من $time اليوم أو لأي يوم لاحق.';
  }

  @override
  String get shopClosedTitle => 'المحل لا يستقبل طلبات الآن';

  @override
  String get shopClosedBody => 'تصفّح المنتجات وجهّز سلتك، واطلب حين نعود.';
}
