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
/// import 'gen/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
  ];

  /// Brand name, not translated
  ///
  /// In ar, this message translates to:
  /// **'Belle Biens'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navShop.
  ///
  /// In ar, this message translates to:
  /// **'المتجر'**
  String get navShop;

  /// No description provided for @navDesigner.
  ///
  /// In ar, this message translates to:
  /// **'صمّم باقتك'**
  String get navDesigner;

  /// No description provided for @navOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get navOrders;

  /// No description provided for @navAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navAccount;

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قيد البناء'**
  String get comingSoon;

  /// No description provided for @comingSoonBody.
  ///
  /// In ar, this message translates to:
  /// **'هذه الشاشة تُبنى في سبرنت {sprint}.'**
  String comingSoonBody(String sprint);

  /// No description provided for @environmentBadge.
  ///
  /// In ar, this message translates to:
  /// **'بيئة: {name}'**
  String environmentBadge(String name);

  /// No description provided for @commonBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get commonBack;

  /// No description provided for @commonContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get commonContinue;

  /// No description provided for @commonEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get commonEdit;

  /// No description provided for @commonOr.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get commonOr;

  /// No description provided for @commonLater.
  ///
  /// In ar, this message translates to:
  /// **'لاحقاً'**
  String get commonLater;

  /// No description provided for @commonRetry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get commonRetry;

  /// No description provided for @errorNetwork.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In ar, this message translates to:
  /// **'الاتصال بطيء. حاول مرة أخرى بعد قليل.'**
  String get errorTimeout;

  /// No description provided for @errorGeneric.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع. حاول مرة أخرى بعد قليل.'**
  String get errorGeneric;

  /// No description provided for @languageArabic.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @onboardingBrowseAsGuest.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح كضيف'**
  String get onboardingBrowseAsGuest;

  /// No description provided for @onboardingPhotoLabel.
  ///
  /// In ar, this message translates to:
  /// **'صورة: باقة ورد من المحل'**
  String get onboardingPhotoLabel;

  /// No description provided for @onboardingBadge.
  ///
  /// In ar, this message translates to:
  /// **'ورد · حلويات · قهوة · هدايا'**
  String get onboardingBadge;

  /// No description provided for @onboardingEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'BELLE BIENS · DAMASCUS'**
  String get onboardingEyebrow;

  /// No description provided for @onboardingTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك في Belle Biens'**
  String get onboardingTitle;

  /// No description provided for @onboardingBody.
  ///
  /// In ar, this message translates to:
  /// **'ورد طازج، كيك وحلويات، قهوة وماتشا، وهدايا من فرعنا في أبو رمانة.'**
  String get onboardingBody;

  /// No description provided for @onboardingDesignTitle.
  ///
  /// In ar, this message translates to:
  /// **'صمّم باقتك بنفسك'**
  String get onboardingDesignTitle;

  /// No description provided for @onboardingDesignBody.
  ///
  /// In ar, this message translates to:
  /// **'اختر الورد والتغليف وشاهد الباقة والسعر مباشرة.'**
  String get onboardingDesignBody;

  /// No description provided for @onboardingDeliveryTitle.
  ///
  /// In ar, this message translates to:
  /// **'توصيل داخل دمشق أو استلام من المحل'**
  String get onboardingDeliveryTitle;

  /// No description provided for @onboardingDeliveryBody.
  ///
  /// In ar, this message translates to:
  /// **'اليوم أو غداً أو بتاريخ مناسبتك.'**
  String get onboardingDeliveryBody;

  /// No description provided for @onboardingWhatsappTitle.
  ///
  /// In ar, this message translates to:
  /// **'واتساب متاح دائماً'**
  String get onboardingWhatsappTitle;

  /// No description provided for @onboardingWhatsappBody.
  ///
  /// In ar, this message translates to:
  /// **'اسأل المحل أو أكّد طلبك برسالة.'**
  String get onboardingWhatsappBody;

  /// No description provided for @onboardingCreateAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get onboardingCreateAccount;

  /// No description provided for @onboardingSignIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get onboardingSignIn;

  /// No description provided for @onboardingContinueAsGuest.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة كضيف'**
  String get onboardingContinueAsGuest;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginTitle;

  /// No description provided for @loginHeading.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً بعودتك'**
  String get loginHeading;

  /// No description provided for @loginBody.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم هاتفك لنرسل لك رمز تحقق، أو سجّل الدخول بالبريد.'**
  String get loginBody;

  /// No description provided for @loginTabPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get loginTabPhone;

  /// No description provided for @loginTabEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get loginTabEmail;

  /// No description provided for @phoneLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'0944 123 456'**
  String get phoneHint;

  /// No description provided for @phoneHelper.
  ///
  /// In ar, this message translates to:
  /// **'يقبل ⁦09XXXXXXXX⁩ أو ⁦+9639XXXXXXXX⁩، وأرقام دولية للمغتربين.'**
  String get phoneHelper;

  /// No description provided for @phoneInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف غير صحيح. اكتبه بالشكل ⁦09XXXXXXXX⁩ أو ⁦+9639XXXXXXXX⁩، أو رقماً دولياً يبدأ بـ ⁦+⁩.'**
  String get phoneInvalid;

  /// No description provided for @loginSendCode.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز التحقق'**
  String get loginSendCode;

  /// No description provided for @emailLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In ar, this message translates to:
  /// **'name@example.com'**
  String get emailHint;

  /// No description provided for @emailInvalid.
  ///
  /// In ar, this message translates to:
  /// **'اكتب بريداً إلكترونياً صحيحاً.'**
  String get emailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get passwordLabel;

  /// No description provided for @passwordRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب كلمة المرور.'**
  String get passwordRequired;

  /// No description provided for @loginWithEmail.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get loginWithEmail;

  /// No description provided for @loginGoogle.
  ///
  /// In ar, this message translates to:
  /// **'المتابعة بحساب Google'**
  String get loginGoogle;

  /// No description provided for @loginNoAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get loginNoAccount;

  /// No description provided for @loginBrowseAsGuest.
  ///
  /// In ar, this message translates to:
  /// **'التصفّح كضيف'**
  String get loginBrowseAsGuest;

  /// No description provided for @registerTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get registerTitle;

  /// No description provided for @registerHeading.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك'**
  String get registerHeading;

  /// No description provided for @registerBody.
  ///
  /// In ar, this message translates to:
  /// **'احفظ عناوينك وتصاميمك وتابع طلباتك، وتذكّر مناسبات من تحب.'**
  String get registerBody;

  /// No description provided for @nameLabel.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: سارة الأحمد'**
  String get nameHint;

  /// No description provided for @nameRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب اسمك.'**
  String get nameRequired;

  /// No description provided for @mobileLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الموبايل'**
  String get mobileLabel;

  /// No description provided for @mobileHint.
  ///
  /// In ar, this message translates to:
  /// **'09XX XXX XXX'**
  String get mobileHint;

  /// No description provided for @mobileHelper.
  ///
  /// In ar, this message translates to:
  /// **'سنرسل رمز تحقق لتأكيد الرقم.'**
  String get mobileHelper;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني (اختياري)'**
  String get emailOptionalLabel;

  /// No description provided for @areaLabel.
  ///
  /// In ar, this message translates to:
  /// **'منطقتك في دمشق (لاقتراح التوصيل)'**
  String get areaLabel;

  /// No description provided for @areaHelper.
  ///
  /// In ar, this message translates to:
  /// **'القائمة تأتي من مناطق التوصيل التي يحددها المحل.'**
  String get areaHelper;

  /// No description provided for @areaAbuRummaneh.
  ///
  /// In ar, this message translates to:
  /// **'أبو رمانة'**
  String get areaAbuRummaneh;

  /// No description provided for @areaMalki.
  ///
  /// In ar, this message translates to:
  /// **'المالكي'**
  String get areaMalki;

  /// No description provided for @areaMazzeh.
  ///
  /// In ar, this message translates to:
  /// **'المزة'**
  String get areaMazzeh;

  /// No description provided for @areaShaalan.
  ///
  /// In ar, this message translates to:
  /// **'الشعلان'**
  String get areaShaalan;

  /// No description provided for @areaQassaa.
  ///
  /// In ar, this message translates to:
  /// **'القصاع'**
  String get areaQassaa;

  /// No description provided for @areaOther.
  ///
  /// In ar, this message translates to:
  /// **'منطقة أخرى'**
  String get areaOther;

  /// No description provided for @termsAccept.
  ///
  /// In ar, this message translates to:
  /// **'أوافق على شروط الاستخدام وسياسة الخصوصية.'**
  String get termsAccept;

  /// No description provided for @termsRequired.
  ///
  /// In ar, this message translates to:
  /// **'يجب الموافقة على شروط الاستخدام وسياسة الخصوصية لإنشاء حساب.'**
  String get termsRequired;

  /// No description provided for @marketingOptIn.
  ///
  /// In ar, this message translates to:
  /// **'أرغب باستلام العروض وتذكير المناسبات (يمكن إلغاؤها لاحقاً).'**
  String get marketingOptIn;

  /// No description provided for @registerSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب والتحقق'**
  String get registerSubmit;

  /// No description provided for @registerGoogle.
  ///
  /// In ar, this message translates to:
  /// **'التسجيل بحساب Google'**
  String get registerGoogle;

  /// No description provided for @registerHaveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب؟'**
  String get registerHaveAccount;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get otpTitle;

  /// No description provided for @otpHeading.
  ///
  /// In ar, this message translates to:
  /// **'أدخل الرمز المرسل إليك'**
  String get otpHeading;

  /// No description provided for @otpSentSms.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمزاً من {length} أرقام برسالة SMS إلى'**
  String otpSentSms(int length);

  /// No description provided for @otpSentWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رمزاً من {length} أرقام عبر واتساب إلى'**
  String otpSentWhatsapp(int length);

  /// No description provided for @otpFieldLabel.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get otpFieldLabel;

  /// No description provided for @otpResendIn.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك طلب رمز جديد خلال {time}'**
  String otpResendIn(String time);

  /// No description provided for @otpResendSms.
  ///
  /// In ar, this message translates to:
  /// **'أرسل رمزاً جديداً'**
  String get otpResendSms;

  /// No description provided for @otpSendWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'أرسل الرمز عبر واتساب بدلاً من SMS'**
  String get otpSendWhatsapp;

  /// No description provided for @otpConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get otpConfirm;

  /// No description provided for @otpNotice.
  ///
  /// In ar, this message translates to:
  /// **'الرمز صالح لمدة 5 دقائق، ويمكنك المحاولة 5 مرات. لم يصلك؟ تواصل معنا على واتساب.'**
  String get otpNotice;

  /// No description provided for @otpAttemptsLeft.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{بقيت محاولة واحدة.} =2{بقيت محاولتان.} few{بقيت {count} محاولات.} other{بقيت {count} محاولة.}}'**
  String otpAttemptsLeft(int count);

  /// No description provided for @completeTitle.
  ///
  /// In ar, this message translates to:
  /// **'أكمل حسابك'**
  String get completeTitle;

  /// No description provided for @completeHeading.
  ///
  /// In ar, this message translates to:
  /// **'خطوة أخيرة'**
  String get completeHeading;

  /// No description provided for @completeBody.
  ///
  /// In ar, this message translates to:
  /// **'أخبرنا باسمك ووافق على الشروط لنحفظ طلباتك وعناوينك.'**
  String get completeBody;

  /// No description provided for @completeSubmit.
  ///
  /// In ar, this message translates to:
  /// **'حفظ والمتابعة'**
  String get completeSubmit;

  /// No description provided for @notifyLater.
  ///
  /// In ar, this message translates to:
  /// **'لاحقاً'**
  String get notifyLater;

  /// No description provided for @notifyHeading.
  ///
  /// In ar, this message translates to:
  /// **'ابقَ على اطلاع بطلباتك'**
  String get notifyHeading;

  /// No description provided for @notifyBody.
  ///
  /// In ar, this message translates to:
  /// **'فعّل الإشعارات لتعرف حالة طلبك ونذكّرك بمناسباتك. لن نرسل عروضاً إلا إذا وافقت عليها.'**
  String get notifyBody;

  /// No description provided for @notifyOrderTitle.
  ///
  /// In ar, this message translates to:
  /// **'حالة الطلب'**
  String get notifyOrderTitle;

  /// No description provided for @notifyOrderBody.
  ///
  /// In ar, this message translates to:
  /// **'عند تأكيد طلبك، وخروجه للتوصيل، ووصوله.'**
  String get notifyOrderBody;

  /// No description provided for @notifyOccasionTitle.
  ///
  /// In ar, this message translates to:
  /// **'تذكير المناسبات'**
  String get notifyOccasionTitle;

  /// No description provided for @notifyOccasionBody.
  ///
  /// In ar, this message translates to:
  /// **'قبل أعياد الميلاد والذكريات التي تحفظها.'**
  String get notifyOccasionBody;

  /// No description provided for @notifyOffersTitle.
  ///
  /// In ar, this message translates to:
  /// **'ورد اليوم والعروض'**
  String get notifyOffersTitle;

  /// No description provided for @notifyOffersBody.
  ///
  /// In ar, this message translates to:
  /// **'اختياري، ويمكن إيقافه من الإعدادات.'**
  String get notifyOffersBody;

  /// No description provided for @notifyEnable.
  ///
  /// In ar, this message translates to:
  /// **'تفعيل الإشعارات'**
  String get notifyEnable;

  /// No description provided for @notifySystemHint.
  ///
  /// In ar, this message translates to:
  /// **'سيظهر بعدها طلب الإذن من نظام هاتفك.'**
  String get notifySystemHint;

  /// No description provided for @accountGuestTitle.
  ///
  /// In ar, this message translates to:
  /// **'أنت تتصفّح كضيف'**
  String get accountGuestTitle;

  /// No description provided for @accountGuestBody.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول لحفظ عناوينك وتصاميمك ومتابعة طلباتك.'**
  String get accountGuestBody;

  /// No description provided for @accountHello.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً {name}'**
  String accountHello(String name);

  /// No description provided for @accountSignOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get accountSignOut;

  /// No description provided for @accountLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get accountLanguage;

  /// No description provided for @currencySyp.
  ///
  /// In ar, this message translates to:
  /// **'ل.س'**
  String get currencySyp;

  /// No description provided for @currencyUsd.
  ///
  /// In ar, this message translates to:
  /// **'\$'**
  String get currencyUsd;

  /// No description provided for @homeDeliveryTo.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل إلى: {area}'**
  String homeDeliveryTo(String area);

  /// No description provided for @homeSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن باقة، كيك، هدية…'**
  String get homeSearchHint;

  /// No description provided for @homeDesignerEyebrow.
  ///
  /// In ar, this message translates to:
  /// **'مصمّم الباقات'**
  String get homeDesignerEyebrow;

  /// No description provided for @homeDesignerTitle.
  ///
  /// In ar, this message translates to:
  /// **'صمّم باقتك على ذوقك'**
  String get homeDesignerTitle;

  /// No description provided for @homeDesignerBody.
  ///
  /// In ar, this message translates to:
  /// **'اختر الورد والتغليف والإضافات، وشاهد الباقة والسعر قبل الطلب.'**
  String get homeDesignerBody;

  /// No description provided for @homeDesignerCta.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ التصميم'**
  String get homeDesignerCta;

  /// No description provided for @homeOrderNow.
  ///
  /// In ar, this message translates to:
  /// **'اطلب الآن'**
  String get homeOrderNow;

  /// No description provided for @homeOrderNowSub.
  ///
  /// In ar, this message translates to:
  /// **'توصيل أو استلام'**
  String get homeOrderNowSub;

  /// No description provided for @homeWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'واتساب'**
  String get homeWhatsapp;

  /// No description provided for @homeWhatsappSub.
  ///
  /// In ar, this message translates to:
  /// **'اسأل المحل'**
  String get homeWhatsappSub;

  /// No description provided for @homeCategories.
  ///
  /// In ar, this message translates to:
  /// **'التصنيفات'**
  String get homeCategories;

  /// No description provided for @homeTodayTitle.
  ///
  /// In ar, this message translates to:
  /// **'ورد اليوم'**
  String get homeTodayTitle;

  /// No description provided for @homeTodaySub.
  ///
  /// In ar, this message translates to:
  /// **'ما هو متوفر طازجاً اليوم في المحل'**
  String get homeTodaySub;

  /// No description provided for @homeCakesTitle.
  ///
  /// In ar, this message translates to:
  /// **'كيك وحلويات'**
  String get homeCakesTitle;

  /// No description provided for @homeCakesSub.
  ///
  /// In ar, this message translates to:
  /// **'تحضير يومي في مطبخ المحل'**
  String get homeCakesSub;

  /// No description provided for @seeAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get seeAll;

  /// No description provided for @shopOpenNow.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح الآن'**
  String get shopOpenNow;

  /// No description provided for @shopBusyNow.
  ///
  /// In ar, this message translates to:
  /// **'مشغول الآن'**
  String get shopBusyNow;

  /// No description provided for @shopClosedNow.
  ///
  /// In ar, this message translates to:
  /// **'مغلق الآن'**
  String get shopClosedNow;

  /// No description provided for @shopUntil.
  ///
  /// In ar, this message translates to:
  /// **'حتى {time}'**
  String shopUntil(String time);

  /// No description provided for @shopOpensAt.
  ///
  /// In ar, this message translates to:
  /// **'يفتح {time}'**
  String shopOpensAt(String time);

  /// No description provided for @branchHoursLabel.
  ///
  /// In ar, this message translates to:
  /// **'ساعات العمل'**
  String get branchHoursLabel;

  /// No description provided for @branchHoursDaily.
  ///
  /// In ar, this message translates to:
  /// **'يومياً {open} – {close}'**
  String branchHoursDaily(String open, String close);

  /// No description provided for @branchMap.
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get branchMap;

  /// No description provided for @branchInstagram.
  ///
  /// In ar, this message translates to:
  /// **'إنستغرام'**
  String get branchInstagram;

  /// No description provided for @branchTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفرع والتواصل'**
  String get branchTitle;

  /// No description provided for @branchDirections.
  ///
  /// In ar, this message translates to:
  /// **'الاتجاهات'**
  String get branchDirections;

  /// No description provided for @branchCall.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get branchCall;

  /// No description provided for @branchPolicies.
  ///
  /// In ar, this message translates to:
  /// **'السياسات'**
  String get branchPolicies;

  /// No description provided for @branchPartners.
  ///
  /// In ar, this message translates to:
  /// **'نتواجد أيضاً على {list}'**
  String branchPartners(String list);

  /// No description provided for @branchContactSoon.
  ///
  /// In ar, this message translates to:
  /// **'يضيف المحل رقم الهاتف وواتساب قريباً.'**
  String get branchContactSoon;

  /// No description provided for @badgeBestSeller.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر طلباً'**
  String get badgeBestSeller;

  /// No description provided for @badgeSeasonal.
  ///
  /// In ar, this message translates to:
  /// **'موسمي'**
  String get badgeSeasonal;

  /// No description provided for @badgeToday.
  ///
  /// In ar, this message translates to:
  /// **'ورد اليوم'**
  String get badgeToday;

  /// No description provided for @badgeTodayOnly.
  ///
  /// In ar, this message translates to:
  /// **'متوفر اليوم فقط'**
  String get badgeTodayOnly;

  /// No description provided for @badgeLimited.
  ///
  /// In ar, this message translates to:
  /// **'كمية محدودة'**
  String get badgeLimited;

  /// No description provided for @badgeUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر اليوم'**
  String get badgeUnavailable;

  /// No description provided for @priceFrom.
  ///
  /// In ar, this message translates to:
  /// **'من ⁨{price}⁩'**
  String priceFrom(String price);

  /// No description provided for @priceApprox.
  ///
  /// In ar, this message translates to:
  /// **'≈ {price}'**
  String priceApprox(String price);

  /// No description provided for @shopTitle.
  ///
  /// In ar, this message translates to:
  /// **'المتجر'**
  String get shopTitle;

  /// No description provided for @shopSearchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث في المتجر'**
  String get shopSearchHint;

  /// No description provided for @shopFilters.
  ///
  /// In ar, this message translates to:
  /// **'الفلاتر'**
  String get shopFilters;

  /// No description provided for @shopFiltersCount.
  ///
  /// In ar, this message translates to:
  /// **'الفلاتر · {count}'**
  String shopFiltersCount(int count);

  /// No description provided for @shopAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get shopAll;

  /// No description provided for @shopResultsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا منتجات} =1{منتج واحد} =2{منتجان} few{{count} منتجات} many{{count} منتجاً} other{{count} منتج}}'**
  String shopResultsCount(int count);

  /// No description provided for @shopSortedBy.
  ///
  /// In ar, this message translates to:
  /// **'مرتبة حسب: {sort}'**
  String shopSortedBy(String sort);

  /// No description provided for @sortPopular.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر طلباً'**
  String get sortPopular;

  /// No description provided for @sortNewest.
  ///
  /// In ar, this message translates to:
  /// **'الأحدث'**
  String get sortNewest;

  /// No description provided for @sortPriceAsc.
  ///
  /// In ar, this message translates to:
  /// **'السعر: من الأقل'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In ar, this message translates to:
  /// **'السعر: من الأعلى'**
  String get sortPriceDesc;

  /// No description provided for @shopSortTitle.
  ///
  /// In ar, this message translates to:
  /// **'ترتيب المنتجات'**
  String get shopSortTitle;

  /// No description provided for @shopOpenForOrders.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح للطلب'**
  String get shopOpenForOrders;

  /// No description provided for @shopLoadMore.
  ///
  /// In ar, this message translates to:
  /// **'عرض المزيد'**
  String get shopLoadMore;

  /// No description provided for @shopEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد منتجات بهذه الفلاتر.'**
  String get shopEmpty;

  /// No description provided for @shopClearFilters.
  ///
  /// In ar, this message translates to:
  /// **'مسح الفلاتر'**
  String get shopClearFilters;

  /// No description provided for @filtersOccasion.
  ///
  /// In ar, this message translates to:
  /// **'المناسبة'**
  String get filtersOccasion;

  /// No description provided for @filtersColor.
  ///
  /// In ar, this message translates to:
  /// **'اللون'**
  String get filtersColor;

  /// No description provided for @filtersFlowerType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الورد'**
  String get filtersFlowerType;

  /// No description provided for @filtersPrice.
  ///
  /// In ar, this message translates to:
  /// **'السعر ({currency})'**
  String filtersPrice(String currency);

  /// No description provided for @filtersAvailableToday.
  ///
  /// In ar, this message translates to:
  /// **'متوفر اليوم فقط'**
  String get filtersAvailableToday;

  /// No description provided for @filtersDeliverableToday.
  ///
  /// In ar, this message translates to:
  /// **'يمكن توصيله اليوم'**
  String get filtersDeliverableToday;

  /// No description provided for @filtersClearAll.
  ///
  /// In ar, this message translates to:
  /// **'مسح الكل'**
  String get filtersClearAll;

  /// No description provided for @filtersShowCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا توجد منتجات} =1{عرض منتج واحد} =2{عرض منتجين} few{عرض {count} منتجات} many{عرض {count} منتجاً} other{عرض {count} منتج}}'**
  String filtersShowCount(int count);

  /// No description provided for @filtersShowResults.
  ///
  /// In ar, this message translates to:
  /// **'عرض النتائج'**
  String get filtersShowResults;

  /// No description provided for @searchRecent.
  ///
  /// In ar, this message translates to:
  /// **'عمليات البحث الأخيرة'**
  String get searchRecent;

  /// No description provided for @searchClear.
  ///
  /// In ar, this message translates to:
  /// **'مسح'**
  String get searchClear;

  /// No description provided for @searchTab.
  ///
  /// In ar, this message translates to:
  /// **'{name} · {count}'**
  String searchTab(String name, int count);

  /// No description provided for @searchNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد نتائج لـ «{query}». جرّب كلمة أخرى.'**
  String searchNoResults(String query);

  /// No description provided for @searchOfflineNote.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل. نبحث في المنتجات المحفوظة على جهازك.'**
  String get searchOfflineNote;

  /// No description provided for @todayNotice.
  ///
  /// In ar, this message translates to:
  /// **'يحدّث المحل هذه القائمة يومياً. تنتهي صلاحيتها منتصف الليل بتوقيت دمشق.'**
  String get todayNotice;

  /// No description provided for @todayLeft.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{بقيت قطعة واحدة} =2{بقيت قطعتان} few{متبقٍ {count} قطع} other{متبقٍ {count}}}'**
  String todayLeft(int count);

  /// No description provided for @todayAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متوفرة'**
  String get todayAvailable;

  /// No description provided for @todayStemsTitle.
  ///
  /// In ar, this message translates to:
  /// **'ورد متاح للتصميم اليوم'**
  String get todayStemsTitle;

  /// No description provided for @todayStem.
  ///
  /// In ar, this message translates to:
  /// **'{name} · {count}'**
  String todayStem(String name, String count);

  /// No description provided for @todayDesignCta.
  ///
  /// In ar, this message translates to:
  /// **'صمّم باقة من ورد اليوم'**
  String get todayDesignCta;

  /// No description provided for @todayEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم ينشر المحل قائمة اليوم بعد. عد لاحقاً.'**
  String get todayEmpty;

  /// No description provided for @occasionTabFlowers.
  ///
  /// In ar, this message translates to:
  /// **'ورد'**
  String get occasionTabFlowers;

  /// No description provided for @occasionTabCakes.
  ///
  /// In ar, this message translates to:
  /// **'كيك'**
  String get occasionTabCakes;

  /// No description provided for @occasionTabExtras.
  ///
  /// In ar, this message translates to:
  /// **'إضافات'**
  String get occasionTabExtras;

  /// No description provided for @occasionDesignCta.
  ///
  /// In ar, this message translates to:
  /// **'صمّم باقة {occasion}'**
  String occasionDesignCta(String occasion);

  /// No description provided for @occasionDesignSub.
  ///
  /// In ar, this message translates to:
  /// **'تبدأ بمناسبة «{occasion}» محددة مسبقاً'**
  String occasionDesignSub(String occasion);

  /// No description provided for @productReadyBouquet.
  ///
  /// In ar, this message translates to:
  /// **'باقة جاهزة'**
  String get productReadyBouquet;

  /// No description provided for @productSelected.
  ///
  /// In ar, this message translates to:
  /// **'{group} المختار: {option}'**
  String productSelected(String group, String option);

  /// No description provided for @productCustomizeTitle.
  ///
  /// In ar, this message translates to:
  /// **'تريد لمسة خاصة؟'**
  String get productCustomizeTitle;

  /// No description provided for @productCustomizeBody.
  ///
  /// In ar, this message translates to:
  /// **'افتح هذه الباقة في المصمّم وغيّر الورد والألوان.'**
  String get productCustomizeBody;

  /// No description provided for @productCustomize.
  ///
  /// In ar, this message translates to:
  /// **'خصّصها'**
  String get productCustomize;

  /// No description provided for @productIncluded.
  ///
  /// In ar, this message translates to:
  /// **'(مشمول بالسعر)'**
  String get productIncluded;

  /// No description provided for @optionIncluded.
  ///
  /// In ar, this message translates to:
  /// **'مشمول'**
  String get optionIncluded;

  /// No description provided for @productEarliest.
  ///
  /// In ar, this message translates to:
  /// **'أقرب توصيل: {when}'**
  String productEarliest(String when);

  /// No description provided for @whenToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get whenToday;

  /// No description provided for @whenTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غداً'**
  String get whenTomorrow;

  /// No description provided for @whenInDays.
  ///
  /// In ar, this message translates to:
  /// **'{days, plural, =2{بعد يومين} few{بعد {days} أيام} other{بعد {days} يوماً}}'**
  String whenInDays(int days);

  /// No description provided for @productDeliveryNote.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل داخل دمشق حسب المنطقة، أو الاستلام من فرع أبو رمانة مجاناً.'**
  String get productDeliveryNote;

  /// No description provided for @productDeliveryPolicy.
  ///
  /// In ar, this message translates to:
  /// **'سياسة التوصيل'**
  String get productDeliveryPolicy;

  /// No description provided for @productDisclaimer.
  ///
  /// In ar, this message translates to:
  /// **'قد تختلف الباقة النهائية قليلاً حسب الورد الطازج المتوفر.'**
  String get productDisclaimer;

  /// No description provided for @productPairingsGift.
  ///
  /// In ar, this message translates to:
  /// **'أضف إلى هديتك'**
  String get productPairingsGift;

  /// No description provided for @productPairingsDrink.
  ///
  /// In ar, this message translates to:
  /// **'يناسب مع مشروبك'**
  String get productPairingsDrink;

  /// No description provided for @productAllergens.
  ///
  /// In ar, this message translates to:
  /// **'مسببات الحساسية: {list}'**
  String productAllergens(String list);

  /// No description provided for @allergenNuts.
  ///
  /// In ar, this message translates to:
  /// **'مكسرات'**
  String get allergenNuts;

  /// No description provided for @allergenMilk.
  ///
  /// In ar, this message translates to:
  /// **'حليب'**
  String get allergenMilk;

  /// No description provided for @allergenEggs.
  ///
  /// In ar, this message translates to:
  /// **'بيض'**
  String get allergenEggs;

  /// No description provided for @allergenGluten.
  ///
  /// In ar, this message translates to:
  /// **'غلوتين'**
  String get allergenGluten;

  /// No description provided for @productLeadTime.
  ///
  /// In ar, this message translates to:
  /// **'{hours, plural, =1{يُطلب قبل ساعة} =2{يُطلب قبل ساعتين} few{يُطلب قبل {hours} ساعات} other{يُطلب قبل {hours} ساعة}}'**
  String productLeadTime(int hours);

  /// No description provided for @productAskTitle.
  ///
  /// In ar, this message translates to:
  /// **'عندك سؤال؟'**
  String get productAskTitle;

  /// No description provided for @productAskBody.
  ///
  /// In ar, this message translates to:
  /// **'راسل المحل على واتساب'**
  String get productAskBody;

  /// No description provided for @productTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get productTotal;

  /// No description provided for @productAddToCart.
  ///
  /// In ar, this message translates to:
  /// **'أضف إلى السلة'**
  String get productAddToCart;

  /// No description provided for @productAddWithTotal.
  ///
  /// In ar, this message translates to:
  /// **'أضف · ⁨{price}⁩'**
  String productAddWithTotal(String price);

  /// No description provided for @productCartSoon.
  ///
  /// In ar, this message translates to:
  /// **'السلة قيد التجهيز وتصل في التحديث القادم.'**
  String get productCartSoon;

  /// No description provided for @productUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر اليوم. احفظه في المفضلة واطلبه لاحقاً.'**
  String get productUnavailable;

  /// No description provided for @productFavoriteAdd.
  ///
  /// In ar, this message translates to:
  /// **'أضف إلى المفضلة'**
  String get productFavoriteAdd;

  /// No description provided for @productFavoriteRemove.
  ///
  /// In ar, this message translates to:
  /// **'أزل من المفضلة'**
  String get productFavoriteRemove;

  /// No description provided for @productQuantity.
  ///
  /// In ar, this message translates to:
  /// **'الكمية'**
  String get productQuantity;

  /// No description provided for @favoriteSignIn.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول لتحفظ منتجاتك المفضلة.'**
  String get favoriteSignIn;

  /// No description provided for @favoritesTitle.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم تحفظ أي منتج بعد. اضغط على القلب في صفحة المنتج.'**
  String get favoritesEmpty;

  /// No description provided for @offlineBanner.
  ///
  /// In ar, this message translates to:
  /// **'أنت غير متصل. نعرض آخر نسخة محفوظة.'**
  String get offlineBanner;

  /// No description provided for @loadFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر التحميل.'**
  String get loadFailed;

  /// No description provided for @imagePlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'صورة {name}'**
  String imagePlaceholder(String name);

  /// No description provided for @designerTitle.
  ///
  /// In ar, this message translates to:
  /// **'صمّم باقتك'**
  String get designerTitle;

  /// No description provided for @designerStepCaption.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة {current} من 4 · {name}'**
  String designerStepCaption(int current, String name);

  /// No description provided for @designerStepOccasion.
  ///
  /// In ar, this message translates to:
  /// **'المناسبة والحجم'**
  String get designerStepOccasion;

  /// No description provided for @designerStepFlowers.
  ///
  /// In ar, this message translates to:
  /// **'الورد والخضرة'**
  String get designerStepFlowers;

  /// No description provided for @designerStepWrap.
  ///
  /// In ar, this message translates to:
  /// **'التغليف والإضافات'**
  String get designerStepWrap;

  /// No description provided for @designerStepCard.
  ///
  /// In ar, this message translates to:
  /// **'البطاقة والمعاينة'**
  String get designerStepCard;

  /// No description provided for @designerPreviewLabel.
  ///
  /// In ar, this message translates to:
  /// **'معاينة حية للباقة'**
  String get designerPreviewLabel;

  /// No description provided for @designerLive.
  ///
  /// In ar, this message translates to:
  /// **'مباشر'**
  String get designerLive;

  /// No description provided for @designerStems.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{بدون ورد} =1{وردة واحدة} =2{وردتان} few{{count} ورود} other{{count} وردة}}'**
  String designerStems(int count);

  /// No description provided for @designerPickFlowers.
  ///
  /// In ar, this message translates to:
  /// **'اختر الورد ليظهر السعر'**
  String get designerPickFlowers;

  /// No description provided for @designerOccasion.
  ///
  /// In ar, this message translates to:
  /// **'المناسبة'**
  String get designerOccasion;

  /// No description provided for @designerSize.
  ///
  /// In ar, this message translates to:
  /// **'الحجم'**
  String get designerSize;

  /// No description provided for @designerSizeRange.
  ///
  /// In ar, this message translates to:
  /// **'{min} – {max} وردة'**
  String designerSizeRange(int min, int max);

  /// No description provided for @designerSizeNote.
  ///
  /// In ar, this message translates to:
  /// **'عدد الورد في كل حجم يحدده المحل.'**
  String get designerSizeNote;

  /// No description provided for @designerPalette.
  ///
  /// In ar, this message translates to:
  /// **'لوحة الألوان'**
  String get designerPalette;

  /// No description provided for @designerOptional.
  ///
  /// In ar, this message translates to:
  /// **'(اختياري)'**
  String get designerOptional;

  /// No description provided for @designerNextFlowers.
  ///
  /// In ar, this message translates to:
  /// **'التالي: اختيار الورد'**
  String get designerNextFlowers;

  /// No description provided for @designerNextWrap.
  ///
  /// In ar, this message translates to:
  /// **'التالي: التغليف'**
  String get designerNextWrap;

  /// No description provided for @designerNextCard.
  ///
  /// In ar, this message translates to:
  /// **'التالي: البطاقة والمعاينة'**
  String get designerNextCard;

  /// No description provided for @designerPrevious.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get designerPrevious;

  /// No description provided for @designerStemsRange.
  ///
  /// In ar, this message translates to:
  /// **'{stems} من {min} – {max}'**
  String designerStemsRange(String stems, int min, int max);

  /// No description provided for @designerSizeName.
  ///
  /// In ar, this message translates to:
  /// **'حجم {size}'**
  String designerSizeName(String size);

  /// No description provided for @designerMainFlowers.
  ///
  /// In ar, this message translates to:
  /// **'الورد الأساسي'**
  String get designerMainFlowers;

  /// No description provided for @designerPerStem.
  ///
  /// In ar, this message translates to:
  /// **'السعر للوردة'**
  String get designerPerStem;

  /// No description provided for @designerAvailableCount.
  ///
  /// In ar, this message translates to:
  /// **'{price} · متوفر {count}'**
  String designerAvailableCount(String price, String count);

  /// No description provided for @designerAvailable.
  ///
  /// In ar, this message translates to:
  /// **'{price} · متوفر'**
  String designerAvailable(String price);

  /// No description provided for @designerUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر اليوم'**
  String get designerUnavailable;

  /// No description provided for @designerSuggest.
  ///
  /// In ar, this message translates to:
  /// **'اقترح بديلاً'**
  String get designerSuggest;

  /// No description provided for @designerFillersGreens.
  ///
  /// In ar, this message translates to:
  /// **'الورد المساعد والخضرة'**
  String get designerFillersGreens;

  /// No description provided for @designerPerSprig.
  ///
  /// In ar, this message translates to:
  /// **'{price} للغصن'**
  String designerPerSprig(String price);

  /// No description provided for @designerStockNote.
  ///
  /// In ar, this message translates to:
  /// **'الأسعار والكميات المتوفرة من «ورد اليوم» الذي يحدّثه المحل.'**
  String get designerStockNote;

  /// No description provided for @designerTooFew.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحجم يحتاج {min} وردة على الأقل.'**
  String designerTooFew(int min);

  /// No description provided for @designerTooMany.
  ///
  /// In ar, this message translates to:
  /// **'هذا الحجم يتسع لـ {max} وردة كحد أقصى.'**
  String designerTooMany(int max);

  /// No description provided for @designerFitsPalette.
  ///
  /// In ar, this message translates to:
  /// **'يناسب لوحتك'**
  String get designerFitsPalette;

  /// No description provided for @designerWrap.
  ///
  /// In ar, this message translates to:
  /// **'التغليف'**
  String get designerWrap;

  /// No description provided for @designerRibbon.
  ///
  /// In ar, this message translates to:
  /// **'الشريط'**
  String get designerRibbon;

  /// No description provided for @designerRibbonNote.
  ///
  /// In ar, this message translates to:
  /// **'شريط ساتان · {price}'**
  String designerRibbonNote(String price);

  /// No description provided for @designerExtras.
  ///
  /// In ar, this message translates to:
  /// **'إضافات'**
  String get designerExtras;

  /// No description provided for @designerMode3d.
  ///
  /// In ar, this message translates to:
  /// **'3D'**
  String get designerMode3d;

  /// No description provided for @designerModeAi.
  ///
  /// In ar, this message translates to:
  /// **'واقعية AI'**
  String get designerModeAi;

  /// No description provided for @designerModeSoon.
  ///
  /// In ar, this message translates to:
  /// **'المعاينة ثلاثية الأبعاد والواقعية تصل في الإصدار الثالث؛ قبله تظهر معاينة 2D فقط.'**
  String get designerModeSoon;

  /// No description provided for @designerCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة الإهداء'**
  String get designerCard;

  /// No description provided for @designerRecipient.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستلم'**
  String get designerRecipient;

  /// No description provided for @designerMessage.
  ///
  /// In ar, this message translates to:
  /// **'الرسالة'**
  String get designerMessage;

  /// No description provided for @designerMessageCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} / {max}'**
  String designerMessageCount(int count, int max);

  /// No description provided for @designerNoCard.
  ///
  /// In ar, this message translates to:
  /// **'بدون بطاقة'**
  String get designerNoCard;

  /// No description provided for @designerSummary.
  ///
  /// In ar, this message translates to:
  /// **'ملخص الباقة'**
  String get designerSummary;

  /// No description provided for @designerLineQty.
  ///
  /// In ar, this message translates to:
  /// **'{name} × {qty}'**
  String designerLineQty(String name, int qty);

  /// No description provided for @designerWrapLine.
  ///
  /// In ar, this message translates to:
  /// **'تغليف {name}'**
  String designerWrapLine(String name);

  /// No description provided for @designerRibbonLine.
  ///
  /// In ar, this message translates to:
  /// **'شريط {name}'**
  String designerRibbonLine(String name);

  /// No description provided for @designerAssemblyFee.
  ///
  /// In ar, this message translates to:
  /// **'رسوم التنسيق'**
  String get designerAssemblyFee;

  /// No description provided for @designerSave.
  ///
  /// In ar, this message translates to:
  /// **'احفظ في تصاميمي'**
  String get designerSave;

  /// No description provided for @designerSend.
  ///
  /// In ar, this message translates to:
  /// **'أرسل للمحل'**
  String get designerSend;

  /// No description provided for @designerSendNoNumber.
  ///
  /// In ar, this message translates to:
  /// **'يضيف المحل رقم واتساب قريباً.'**
  String get designerSendNoNumber;

  /// No description provided for @designerWhatsappIntro.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً، صمّمت هذه الباقة في تطبيق Belle Biens:'**
  String get designerWhatsappIntro;

  /// No description provided for @designerWhatsappTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع: {total}'**
  String designerWhatsappTotal(String total);

  /// No description provided for @designerWhatsappPreview.
  ///
  /// In ar, this message translates to:
  /// **'المعاينة: {link}'**
  String designerWhatsappPreview(String link);

  /// No description provided for @designerAddToCart.
  ///
  /// In ar, this message translates to:
  /// **'أضف الباقة إلى السلة'**
  String get designerAddToCart;

  /// No description provided for @designerUndo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get designerUndo;

  /// No description provided for @designerRedo.
  ///
  /// In ar, this message translates to:
  /// **'إعادة'**
  String get designerRedo;

  /// No description provided for @designerRestart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ من جديد'**
  String get designerRestart;

  /// No description provided for @designerIssueBanner.
  ///
  /// In ar, this message translates to:
  /// **'بعض الورد نفد للتو. راجع البدائل.'**
  String get designerIssueBanner;

  /// No description provided for @designerFixStems.
  ///
  /// In ar, this message translates to:
  /// **'عدّل عدد الورد ليناسب الحجم.'**
  String get designerFixStems;

  /// No description provided for @substituteTitle.
  ///
  /// In ar, this message translates to:
  /// **'بعض الورد نفد للتو'**
  String get substituteTitle;

  /// No description provided for @substituteBody.
  ///
  /// In ar, this message translates to:
  /// **'بقي {available} من {name}، وتصميمك يحتاج {qty}.'**
  String substituteBody(int available, String name, int qty);

  /// No description provided for @substituteBodyNone.
  ///
  /// In ar, this message translates to:
  /// **'{name} غير متوفر اليوم، وتصميمك يحتاج {qty}.'**
  String substituteBodyNone(String name, int qty);

  /// No description provided for @substituteChoose.
  ///
  /// In ar, this message translates to:
  /// **'اختر بديلاً'**
  String get substituteChoose;

  /// No description provided for @substituteSamePrice.
  ///
  /// In ar, this message translates to:
  /// **'نفس السعر'**
  String get substituteSamePrice;

  /// No description provided for @substituteManual.
  ///
  /// In ar, this message translates to:
  /// **'تعديل يدوياً'**
  String get substituteManual;

  /// No description provided for @substituteApply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق البديل'**
  String get substituteApply;

  /// No description provided for @substituteNone.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد بديل متوفر الآن. خفّض الكمية أو اختر وردة أخرى.'**
  String get substituteNone;

  /// No description provided for @substituteOption.
  ///
  /// In ar, this message translates to:
  /// **'{items}'**
  String substituteOption(String items);

  /// No description provided for @cartTitle.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get cartTitle;

  /// No description provided for @cartTitleCount.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{السلة} =1{السلة · قطعة واحدة} =2{السلة · قطعتان} few{السلة · {count} قطع} other{السلة · {count} قطعة}}'**
  String cartTitleCount(int count);

  /// No description provided for @cartOpen.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get cartOpen;

  /// No description provided for @cartCheckout.
  ///
  /// In ar, this message translates to:
  /// **'إتمام الطلب'**
  String get cartCheckout;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In ar, this message translates to:
  /// **'سلتك فارغة'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyBody.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بباقة من ورد اليوم، أو صمّم باقتك بنفسك.'**
  String get cartEmptyBody;

  /// No description provided for @cartBrowseToday.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح ورد اليوم'**
  String get cartBrowseToday;

  /// No description provided for @cartEditDesign.
  ///
  /// In ar, this message translates to:
  /// **'تعديل التصميم'**
  String get cartEditDesign;

  /// No description provided for @cartCardMessage.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة: «{message}»'**
  String cartCardMessage(String message);

  /// No description provided for @cartRemove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة {name}'**
  String cartRemove(String name);

  /// No description provided for @cartLeadNotice.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج بعض ما في سلتك {hours} ساعة للتجهيز، لذلك أقرب موعد للطلب كاملاً هو {when}.'**
  String cartLeadNotice(int hours, String when);

  /// No description provided for @cartWhenToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم {time}'**
  String cartWhenToday(String time);

  /// No description provided for @cartWhenTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غداً {time}'**
  String cartWhenTomorrow(String time);

  /// No description provided for @cartWhenDate.
  ///
  /// In ar, this message translates to:
  /// **'{date} {time}'**
  String cartWhenDate(String date, String time);

  /// No description provided for @cartCoupon.
  ///
  /// In ar, this message translates to:
  /// **'كوبون خصم'**
  String get cartCoupon;

  /// No description provided for @cartCouponApply.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق'**
  String get cartCouponApply;

  /// No description provided for @cartCouponRemove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الكوبون'**
  String get cartCouponRemove;

  /// No description provided for @cartCouponApplied.
  ///
  /// In ar, this message translates to:
  /// **'تم تطبيق {code}'**
  String cartCouponApplied(String code);

  /// No description provided for @cartCouponNotFound.
  ///
  /// In ar, this message translates to:
  /// **'هذا الكوبون غير صحيح.'**
  String get cartCouponNotFound;

  /// No description provided for @cartCouponExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية هذا الكوبون.'**
  String get cartCouponExpired;

  /// No description provided for @cartCouponUsedUp.
  ///
  /// In ar, this message translates to:
  /// **'استُخدم هذا الكوبون بالكامل.'**
  String get cartCouponUsedUp;

  /// No description provided for @cartCouponMinOrder.
  ///
  /// In ar, this message translates to:
  /// **'يعمل هذا الكوبون عند طلب بقيمة ⁨{amount}⁩ أو أكثر.'**
  String cartCouponMinOrder(String amount);

  /// No description provided for @cartProducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات'**
  String get cartProducts;

  /// No description provided for @cartDiscount.
  ///
  /// In ar, this message translates to:
  /// **'الخصم'**
  String get cartDiscount;

  /// No description provided for @cartDelivery.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل'**
  String get cartDelivery;

  /// No description provided for @cartDeliveryLater.
  ///
  /// In ar, this message translates to:
  /// **'يُحسب حسب المنطقة'**
  String get cartDeliveryLater;

  /// No description provided for @cartRounding.
  ///
  /// In ar, this message translates to:
  /// **'تقريب'**
  String get cartRounding;

  /// No description provided for @cartSubtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع الفرعي'**
  String get cartSubtotal;

  /// No description provided for @cartSuggestions.
  ///
  /// In ar, this message translates to:
  /// **'قد يعجبك أيضاً'**
  String get cartSuggestions;

  /// No description provided for @cartContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة للتوصيل'**
  String get cartContinue;

  /// No description provided for @cartFixIssues.
  ///
  /// In ar, this message translates to:
  /// **'عدّل ما في السلة قبل المتابعة.'**
  String get cartFixIssues;

  /// No description provided for @cartAdded.
  ///
  /// In ar, this message translates to:
  /// **'أُضيف إلى السلة'**
  String get cartAdded;

  /// No description provided for @cartView.
  ///
  /// In ar, this message translates to:
  /// **'عرض السلة'**
  String get cartView;

  /// No description provided for @cartUpdated.
  ///
  /// In ar, this message translates to:
  /// **'حُدّثت الباقة في السلة'**
  String get cartUpdated;

  /// No description provided for @cartUpdateDesign.
  ///
  /// In ar, this message translates to:
  /// **'حدّث الباقة في السلة'**
  String get cartUpdateDesign;

  /// No description provided for @issueProductUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متوفر الآن.'**
  String get issueProductUnavailable;

  /// No description provided for @issueOptionUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'أحد الخيارات لم يعد متوفراً.'**
  String get issueOptionUnavailable;

  /// No description provided for @issueStock.
  ///
  /// In ar, this message translates to:
  /// **'المتوفر الآن {count} فقط.'**
  String issueStock(int count);

  /// No description provided for @issueItemUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'بعض محتويات هذه الباقة نفدت.'**
  String get issueItemUnavailable;

  /// No description provided for @issueStems.
  ///
  /// In ar, this message translates to:
  /// **'عدد الورد لا يناسب الحجم.'**
  String get issueStems;

  /// No description provided for @issueBox.
  ///
  /// In ar, this message translates to:
  /// **'محتوى الصندوق لا يناسب أركانه.'**
  String get issueBox;

  /// No description provided for @issueInscription.
  ///
  /// In ar, this message translates to:
  /// **'الرسالة على الكيك غير مقبولة لهذا المنتج.'**
  String get issueInscription;

  /// No description provided for @boxTitle.
  ///
  /// In ar, this message translates to:
  /// **'صندوق ورد وحلويات'**
  String get boxTitle;

  /// No description provided for @boxHomeBody.
  ///
  /// In ar, this message translates to:
  /// **'اختر ورد ركن، وحلويات الركن الآخر.'**
  String get boxHomeBody;

  /// No description provided for @boxHomeCta.
  ///
  /// In ar, this message translates to:
  /// **'ركّب صندوقك'**
  String get boxHomeCta;

  /// No description provided for @boxType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الصندوق'**
  String get boxType;

  /// No description provided for @boxUpTo.
  ///
  /// In ar, this message translates to:
  /// **'حتى {count}'**
  String boxUpTo(int count);

  /// No description provided for @boxFilled.
  ///
  /// In ar, this message translates to:
  /// **'{count} من {capacity}'**
  String boxFilled(int count, int capacity);

  /// No description provided for @boxPiece.
  ///
  /// In ar, this message translates to:
  /// **'قطعة'**
  String get boxPiece;

  /// No description provided for @boxLeadNote.
  ///
  /// In ar, this message translates to:
  /// **'مدة التجهيز = أطول مدة بين محتويات الصندوق. يحسب النظام أقرب موعد تلقائياً.'**
  String get boxLeadNote;

  /// No description provided for @boxSummary.
  ///
  /// In ar, this message translates to:
  /// **'{name} · {total}'**
  String boxSummary(String name, String total);

  /// No description provided for @cakeMessage.
  ///
  /// In ar, this message translates to:
  /// **'رسالة على الكيك'**
  String get cakeMessage;

  /// No description provided for @cakeMessageCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} / {max}'**
  String cakeMessageCount(int count, int max);

  /// No description provided for @cakePhoto.
  ///
  /// In ar, this message translates to:
  /// **'أرفق صورة للتصميم المطلوب'**
  String get cakePhoto;

  /// No description provided for @cakePhotoHint.
  ///
  /// In ar, this message translates to:
  /// **'اختياري · JPG أو PNG'**
  String get cakePhotoHint;

  /// No description provided for @cakePhotoAttached.
  ///
  /// In ar, this message translates to:
  /// **'أُرفقت الصورة'**
  String get cakePhotoAttached;

  /// No description provided for @cakePhotoRemove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة الصورة'**
  String get cakePhotoRemove;

  /// No description provided for @cakePhotoFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر رفع الصورة. حاول مرة أخرى.'**
  String get cakePhotoFailed;

  /// No description provided for @productAdded.
  ///
  /// In ar, this message translates to:
  /// **'أُضيف {name} إلى السلة'**
  String productAdded(String name);

  /// No description provided for @checkoutTitle.
  ///
  /// In ar, this message translates to:
  /// **'إتمام الطلب'**
  String get checkoutTitle;

  /// No description provided for @checkoutStep1.
  ///
  /// In ar, this message translates to:
  /// **'1 من 2 · التوصيل والموعد'**
  String get checkoutStep1;

  /// No description provided for @checkoutStep2.
  ///
  /// In ar, this message translates to:
  /// **'2 من 2 · الدفع والمراجعة'**
  String get checkoutStep2;

  /// No description provided for @checkoutHowTitle.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الاستلام'**
  String get checkoutHowTitle;

  /// No description provided for @checkoutDelivery.
  ///
  /// In ar, this message translates to:
  /// **'توصيل داخل دمشق'**
  String get checkoutDelivery;

  /// No description provided for @checkoutDeliveryHint.
  ///
  /// In ar, this message translates to:
  /// **'الرسوم حسب منطقة العنوان'**
  String get checkoutDeliveryHint;

  /// No description provided for @checkoutPickup.
  ///
  /// In ar, this message translates to:
  /// **'استلام من الفرع'**
  String get checkoutPickup;

  /// No description provided for @checkoutPickupFree.
  ///
  /// In ar, this message translates to:
  /// **'مجاناً'**
  String get checkoutPickupFree;

  /// No description provided for @checkoutPickupFreeAt.
  ///
  /// In ar, this message translates to:
  /// **'مجاناً · {address}'**
  String checkoutPickupFreeAt(String address);

  /// No description provided for @checkoutAddressTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان التوصيل'**
  String get checkoutAddressTitle;

  /// No description provided for @checkoutAddressChange.
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get checkoutAddressChange;

  /// No description provided for @checkoutAddressSet.
  ///
  /// In ar, this message translates to:
  /// **'حدّد العنوان على الخريطة'**
  String get checkoutAddressSet;

  /// No description provided for @checkoutInZone.
  ///
  /// In ar, this message translates to:
  /// **'داخل منطقة التوصيل · ⁨{fee}⁩'**
  String checkoutInZone(String fee);

  /// No description provided for @checkoutYouTitle.
  ///
  /// In ar, this message translates to:
  /// **'بياناتك'**
  String get checkoutYouTitle;

  /// No description provided for @checkoutYourName.
  ///
  /// In ar, this message translates to:
  /// **'اسمك'**
  String get checkoutYourName;

  /// No description provided for @checkoutYourPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتفك'**
  String get checkoutYourPhone;

  /// No description provided for @checkoutRecipientTitle.
  ///
  /// In ar, this message translates to:
  /// **'المستلم'**
  String get checkoutRecipientTitle;

  /// No description provided for @checkoutRecipientMe.
  ///
  /// In ar, this message translates to:
  /// **'أنا المستلم'**
  String get checkoutRecipientMe;

  /// No description provided for @checkoutRecipientOther.
  ///
  /// In ar, this message translates to:
  /// **'شخص آخر'**
  String get checkoutRecipientOther;

  /// No description provided for @checkoutRecipientName.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستلم'**
  String get checkoutRecipientName;

  /// No description provided for @checkoutRecipientPhone.
  ///
  /// In ar, this message translates to:
  /// **'رقم هاتف المستلم'**
  String get checkoutRecipientPhone;

  /// No description provided for @checkoutHideSender.
  ///
  /// In ar, this message translates to:
  /// **'لا تُظهر اسمي للمستلم'**
  String get checkoutHideSender;

  /// No description provided for @checkoutDayTitle.
  ///
  /// In ar, this message translates to:
  /// **'يوم التوصيل'**
  String get checkoutDayTitle;

  /// No description provided for @checkoutPickupDayTitle.
  ///
  /// In ar, this message translates to:
  /// **'يوم الاستلام'**
  String get checkoutPickupDayTitle;

  /// No description provided for @checkoutToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get checkoutToday;

  /// No description provided for @checkoutTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غداً'**
  String get checkoutTomorrow;

  /// No description provided for @checkoutOtherDate.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ آخر'**
  String get checkoutOtherDate;

  /// No description provided for @checkoutUpToDays.
  ///
  /// In ar, this message translates to:
  /// **'حتى {days} يوماً'**
  String checkoutUpToDays(int days);

  /// No description provided for @checkoutUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'غير متاح'**
  String get checkoutUnavailable;

  /// No description provided for @checkoutTodayTooSoon.
  ///
  /// In ar, this message translates to:
  /// **'«اليوم» غير متاح لأن طلبك يحتاج {hours} ساعة للتجهيز.'**
  String checkoutTodayTooSoon(int hours);

  /// No description provided for @checkoutDayClosed.
  ///
  /// In ar, this message translates to:
  /// **'المحل لا يوصل في هذا اليوم.'**
  String get checkoutDayClosed;

  /// No description provided for @checkoutTimeTitle.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get checkoutTimeTitle;

  /// No description provided for @checkoutSlot.
  ///
  /// In ar, this message translates to:
  /// **'{start} – {end}'**
  String checkoutSlot(String start, String end);

  /// No description provided for @checkoutSlotFull.
  ///
  /// In ar, this message translates to:
  /// **'{start} – {end} · ممتلئ'**
  String checkoutSlotFull(String start, String end);

  /// No description provided for @checkoutNoSlots.
  ///
  /// In ar, this message translates to:
  /// **'لا مواعيد متاحة في هذا اليوم. اختر يوماً آخر.'**
  String get checkoutNoSlots;

  /// No description provided for @checkoutCallBefore.
  ///
  /// In ar, this message translates to:
  /// **'اتصل قبل الوصول'**
  String get checkoutCallBefore;

  /// No description provided for @checkoutNotes.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظات للمحل'**
  String get checkoutNotes;

  /// No description provided for @checkoutNotesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} / 300'**
  String checkoutNotesCount(int count);

  /// No description provided for @checkoutWithDelivery.
  ///
  /// In ar, this message translates to:
  /// **'مع التوصيل'**
  String get checkoutWithDelivery;

  /// No description provided for @checkoutToPayment.
  ///
  /// In ar, this message translates to:
  /// **'متابعة للدفع'**
  String get checkoutToPayment;

  /// No description provided for @checkoutNeedAddress.
  ///
  /// In ar, this message translates to:
  /// **'حدّد عنوان التوصيل أولاً.'**
  String get checkoutNeedAddress;

  /// No description provided for @checkoutNeedSlot.
  ///
  /// In ar, this message translates to:
  /// **'اختر يوم التوصيل ووقته.'**
  String get checkoutNeedSlot;

  /// No description provided for @checkoutNeedName.
  ///
  /// In ar, this message translates to:
  /// **'اكتب الاسم.'**
  String get checkoutNeedName;

  /// No description provided for @checkoutPickDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر التاريخ'**
  String get checkoutPickDate;

  /// No description provided for @addressTitle.
  ///
  /// In ar, this message translates to:
  /// **'عنوان التوصيل'**
  String get addressTitle;

  /// No description provided for @addressZoneBadge.
  ///
  /// In ar, this message translates to:
  /// **'منطقة: {zone}'**
  String addressZoneBadge(String zone);

  /// No description provided for @addressSearch.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن منطقة'**
  String get addressSearch;

  /// No description provided for @addressNoArea.
  ///
  /// In ar, this message translates to:
  /// **'لا منطقة توصيل بهذا الاسم.'**
  String get addressNoArea;

  /// No description provided for @addressInZone.
  ///
  /// In ar, this message translates to:
  /// **'العنوان داخل منطقة التوصيل {zone} · الرسوم ⁨{fee}⁩ · المدة التقريبية {eta}.'**
  String addressInZone(String zone, String fee, String eta);

  /// No description provided for @addressOutOfZone.
  ///
  /// In ar, this message translates to:
  /// **'هذه النقطة خارج مناطق التوصيل.'**
  String get addressOutOfZone;

  /// No description provided for @addressChecking.
  ///
  /// In ar, this message translates to:
  /// **'نتحقق من المنطقة…'**
  String get addressChecking;

  /// No description provided for @addressMapHint.
  ///
  /// In ar, this message translates to:
  /// **'حرّك الخريطة ليقع الدبوس على مكان التوصيل.'**
  String get addressMapHint;

  /// No description provided for @addressMapLabel.
  ///
  /// In ar, this message translates to:
  /// **'خريطة. الدبوس في الوسط هو مكان التوصيل.'**
  String get addressMapLabel;

  /// No description provided for @addressSavedTitle.
  ///
  /// In ar, this message translates to:
  /// **'عناويني'**
  String get addressSavedTitle;

  /// No description provided for @addressLandmark.
  ///
  /// In ar, this message translates to:
  /// **'أقرب معلم'**
  String get addressLandmark;

  /// No description provided for @addressBuilding.
  ///
  /// In ar, this message translates to:
  /// **'البناء'**
  String get addressBuilding;

  /// No description provided for @addressFloor.
  ///
  /// In ar, this message translates to:
  /// **'الطابق'**
  String get addressFloor;

  /// No description provided for @addressDetails.
  ///
  /// In ar, this message translates to:
  /// **'الشارع وتفاصيل أخرى'**
  String get addressDetails;

  /// No description provided for @addressLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم العنوان'**
  String get addressLabel;

  /// No description provided for @addressHome.
  ///
  /// In ar, this message translates to:
  /// **'البيت'**
  String get addressHome;

  /// No description provided for @addressWork.
  ///
  /// In ar, this message translates to:
  /// **'العمل'**
  String get addressWork;

  /// No description provided for @addressOther.
  ///
  /// In ar, this message translates to:
  /// **'آخر'**
  String get addressOther;

  /// No description provided for @addressSave.
  ///
  /// In ar, this message translates to:
  /// **'احفظ العنوان لطلباتي القادمة'**
  String get addressSave;

  /// No description provided for @addressConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد العنوان'**
  String get addressConfirm;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get paymentMethodTitle;

  /// No description provided for @paymentCash.
  ///
  /// In ar, this message translates to:
  /// **'الدفع عند الاستلام'**
  String get paymentCash;

  /// No description provided for @paymentCashHint.
  ///
  /// In ar, this message translates to:
  /// **'نقداً للمندوب أو في المحل. يتصل بك المحل لتأكيد الطلب.'**
  String get paymentCashHint;

  /// No description provided for @paymentShamcash.
  ///
  /// In ar, this message translates to:
  /// **'شام كاش'**
  String get paymentShamcash;

  /// No description provided for @paymentShamcashHint.
  ///
  /// In ar, this message translates to:
  /// **'ادفع من تطبيق شام كاش، ثم أدخل رقم العملية أو صورة الإيصال.'**
  String get paymentShamcashHint;

  /// No description provided for @paymentStripe.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة دولية (Stripe)'**
  String get paymentStripe;

  /// No description provided for @paymentStripeBadge.
  ///
  /// In ar, this message translates to:
  /// **'للمغتربين · USD'**
  String get paymentStripeBadge;

  /// No description provided for @paymentStripeHint.
  ///
  /// In ar, this message translates to:
  /// **'تنتقل إلى صفحة Stripe الآمنة. لا نحفظ بيانات بطاقتك.'**
  String get paymentStripeHint;

  /// No description provided for @paymentSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريباً'**
  String get paymentSoon;

  /// No description provided for @paymentWhenWhere.
  ///
  /// In ar, this message translates to:
  /// **'{when} · {where}'**
  String paymentWhenWhere(String when, String where);

  /// No description provided for @paymentPickupWhere.
  ///
  /// In ar, this message translates to:
  /// **'الاستلام من الفرع'**
  String get paymentPickupWhere;

  /// No description provided for @paymentRecipient.
  ///
  /// In ar, this message translates to:
  /// **'المستلم: {name}'**
  String paymentRecipient(String name);

  /// No description provided for @paymentRecipientHidden.
  ///
  /// In ar, this message translates to:
  /// **'المستلم: {name} · بدون إظهار المرسل'**
  String paymentRecipientHidden(String name);

  /// No description provided for @paymentInvoice.
  ///
  /// In ar, this message translates to:
  /// **'الفاتورة'**
  String get paymentInvoice;

  /// No description provided for @paymentProducts.
  ///
  /// In ar, this message translates to:
  /// **'المنتجات ({count})'**
  String paymentProducts(int count);

  /// No description provided for @paymentDeliveryZone.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل · {zone}'**
  String paymentDeliveryZone(String zone);

  /// No description provided for @paymentTotal.
  ///
  /// In ar, this message translates to:
  /// **'الإجمالي'**
  String get paymentTotal;

  /// No description provided for @paymentUsdNote.
  ///
  /// In ar, this message translates to:
  /// **'≈ {usd} · سعر الصرف يُثبّت عند تأكيد الطلب'**
  String paymentUsdNote(String usd);

  /// No description provided for @paymentWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'أفضّل التأكيد عبر واتساب'**
  String get paymentWhatsapp;

  /// No description provided for @paymentWhatsappHint.
  ///
  /// In ar, this message translates to:
  /// **'نرسل ملخص الطلب ورقمه للمحل'**
  String get paymentWhatsappHint;

  /// No description provided for @paymentTermsLead.
  ///
  /// In ar, this message translates to:
  /// **'بتأكيد الطلب أنت توافق على '**
  String get paymentTermsLead;

  /// No description provided for @paymentTermsLink.
  ///
  /// In ar, this message translates to:
  /// **'شروط البيع وسياسة الإلغاء'**
  String get paymentTermsLink;

  /// No description provided for @paymentConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب · ⁨{total}⁩'**
  String paymentConfirm(String total);

  /// No description provided for @paymentCartChanged.
  ///
  /// In ar, this message translates to:
  /// **'تغيّر شيء في سلتك. راجع السلة ثم أكمل الطلب.'**
  String get paymentCartChanged;

  /// No description provided for @confirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'استلمنا طلبك'**
  String get confirmTitle;

  /// No description provided for @confirmNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب'**
  String get confirmNumber;

  /// No description provided for @confirmPendingShop.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار تأكيد المحل'**
  String get confirmPendingShop;

  /// No description provided for @confirmWhen.
  ///
  /// In ar, this message translates to:
  /// **'الموعد'**
  String get confirmWhen;

  /// No description provided for @confirmWhere.
  ///
  /// In ar, this message translates to:
  /// **'العنوان'**
  String get confirmWhere;

  /// No description provided for @confirmPickup.
  ///
  /// In ar, this message translates to:
  /// **'الاستلام'**
  String get confirmPickup;

  /// No description provided for @confirmPayment.
  ///
  /// In ar, this message translates to:
  /// **'الدفع'**
  String get confirmPayment;

  /// No description provided for @confirmNextTitle.
  ///
  /// In ar, this message translates to:
  /// **'ماذا بعد؟'**
  String get confirmNextTitle;

  /// No description provided for @confirmNextCash.
  ///
  /// In ar, this message translates to:
  /// **'يتصل بك المحل أو يراسلك على واتساب لتأكيد الطلب. يصلك إشعار عند التأكيد.'**
  String get confirmNextCash;

  /// No description provided for @confirmNextDelivery.
  ///
  /// In ar, this message translates to:
  /// **'يجهّز المحل طلبك حسب الوصفة، ثم يخرج للتوصيل في الموعد.'**
  String get confirmNextDelivery;

  /// No description provided for @confirmNextPickup.
  ///
  /// In ar, this message translates to:
  /// **'يجهّز المحل طلبك حسب الوصفة، ويكون جاهزاً للاستلام في الموعد.'**
  String get confirmNextPickup;

  /// No description provided for @confirmTrack.
  ///
  /// In ar, this message translates to:
  /// **'تتبّع الطلب'**
  String get confirmTrack;

  /// No description provided for @confirmWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'راسل المحل على واتساب'**
  String get confirmWhatsapp;

  /// No description provided for @confirmContinue.
  ///
  /// In ar, this message translates to:
  /// **'متابعة التسوق'**
  String get confirmContinue;

  /// No description provided for @confirmGuestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبت كضيف؟'**
  String get confirmGuestTitle;

  /// No description provided for @confirmGuestBody.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حساباً بنفس الرقم لتحفظ هذا الطلب وعناوينك.'**
  String get confirmGuestBody;

  /// No description provided for @confirmGuestAction.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب'**
  String get confirmGuestAction;

  /// No description provided for @orderWhatsappMessage.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً، طلبت من تطبيق Belle Biens.\nرقم الطلب: {number}\n{summary}\nالإجمالي: {total}\nالموعد: {when}\nأرجو تأكيد الطلب.'**
  String orderWhatsappMessage(
    String number,
    String summary,
    String total,
    String when,
  );

  /// No description provided for @outZoneHeadline.
  ///
  /// In ar, this message translates to:
  /// **'هذا العنوان خارج مناطق التوصيل حالياً.'**
  String get outZoneHeadline;

  /// No description provided for @outZoneBody.
  ///
  /// In ar, this message translates to:
  /// **'نوصل داخل دمشق فقط في المناطق المحددة.'**
  String get outZoneBody;

  /// No description provided for @outZoneWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'اسأل المحل على واتساب'**
  String get outZoneWhatsapp;

  /// No description provided for @outZonePickup.
  ///
  /// In ar, this message translates to:
  /// **'استلم من الفرع'**
  String get outZonePickup;

  /// No description provided for @outZoneOther.
  ///
  /// In ar, this message translates to:
  /// **'اختر عنواناً آخر'**
  String get outZoneOther;

  /// No description provided for @outZoneMessage.
  ///
  /// In ar, this message translates to:
  /// **'مرحباً، هل توصلون إلى هذا العنوان؟ {link}'**
  String outZoneMessage(String link);

  /// No description provided for @shopBusyTitle.
  ///
  /// In ar, this message translates to:
  /// **'المحل مشغول حالياً'**
  String get shopBusyTitle;

  /// No description provided for @shopBusyBody.
  ///
  /// In ar, this message translates to:
  /// **'نستقبل الطلبات لمواعيد تبدأ من {time} اليوم أو لأي يوم لاحق.'**
  String shopBusyBody(String time);

  /// No description provided for @shopClosedTitle.
  ///
  /// In ar, this message translates to:
  /// **'المحل لا يستقبل طلبات الآن'**
  String get shopClosedTitle;

  /// No description provided for @shopClosedBody.
  ///
  /// In ar, this message translates to:
  /// **'تصفّح المنتجات وجهّز سلتك، واطلب حين نعود.'**
  String get shopClosedBody;

  /// No description provided for @shamcashTitle.
  ///
  /// In ar, this message translates to:
  /// **'الدفع بشام كاش'**
  String get shamcashTitle;

  /// No description provided for @shamcashAmountFor.
  ///
  /// In ar, this message translates to:
  /// **'المبلغ المطلوب · طلب رقم {number}'**
  String shamcashAmountFor(String number);

  /// No description provided for @shamcashPayWithin.
  ///
  /// In ar, this message translates to:
  /// **'أكمل الدفع خلال {time}'**
  String shamcashPayWithin(String time);

  /// No description provided for @shamcashExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مهلة الدفع. أُلغي الطلب إن لم يصل الإيصال.'**
  String get shamcashExpired;

  /// No description provided for @shamcashSteps.
  ///
  /// In ar, this message translates to:
  /// **'الخطوات'**
  String get shamcashSteps;

  /// No description provided for @shamcashStep1.
  ///
  /// In ar, this message translates to:
  /// **'افتح تطبيق شام كاش واختر \"تحويل\" أو \"دفع لتاجر\".'**
  String get shamcashStep1;

  /// No description provided for @shamcashStep2.
  ///
  /// In ar, this message translates to:
  /// **'حوّل المبلغ إلى حساب المحل:'**
  String get shamcashStep2;

  /// No description provided for @shamcashNoAccount.
  ///
  /// In ar, this message translates to:
  /// **'اطلب رقم حساب المحل على واتساب.'**
  String get shamcashNoAccount;

  /// No description provided for @shamcashStep3.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رقم العملية أو أرفق صورة الإيصال هنا.'**
  String get shamcashStep3;

  /// No description provided for @shamcashCopy.
  ///
  /// In ar, this message translates to:
  /// **'نسخ'**
  String get shamcashCopy;

  /// No description provided for @shamcashCopied.
  ///
  /// In ar, this message translates to:
  /// **'نُسخ رقم الحساب'**
  String get shamcashCopied;

  /// No description provided for @shamcashReference.
  ///
  /// In ar, this message translates to:
  /// **'رقم العملية'**
  String get shamcashReference;

  /// No description provided for @shamcashAttach.
  ///
  /// In ar, this message translates to:
  /// **'أرفق صورة الإيصال'**
  String get shamcashAttach;

  /// No description provided for @shamcashAttachHint.
  ///
  /// In ar, this message translates to:
  /// **'JPG أو PNG · حتى 5 ميغابايت'**
  String get shamcashAttachHint;

  /// No description provided for @shamcashAttached.
  ///
  /// In ar, this message translates to:
  /// **'أُرفق الإيصال'**
  String get shamcashAttached;

  /// No description provided for @shamcashAfter.
  ///
  /// In ar, this message translates to:
  /// **'بعد الإرسال يتحقق المحل من الدفعة ويؤكد طلبك. إذا وصل تأكيد شام كاش تلقائياً، يتأكد الطلب فوراً.'**
  String get shamcashAfter;

  /// No description provided for @shamcashChangeMethod.
  ///
  /// In ar, this message translates to:
  /// **'تغيير طريقة الدفع'**
  String get shamcashChangeMethod;

  /// No description provided for @shamcashSent.
  ///
  /// In ar, this message translates to:
  /// **'أرسلت الدفعة'**
  String get shamcashSent;

  /// No description provided for @shamcashNeedProof.
  ///
  /// In ar, this message translates to:
  /// **'اكتب رقم العملية أو أرفق صورة الإيصال.'**
  String get shamcashNeedProof;

  /// No description provided for @confirmPendingPayment.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار التحقق من الدفع'**
  String get confirmPendingPayment;

  /// No description provided for @confirmNextShamcash.
  ///
  /// In ar, this message translates to:
  /// **'يتحقق المحل من دفعتك ويؤكد الطلب. يصلك إشعار عند التأكيد.'**
  String get confirmNextShamcash;

  /// No description provided for @payFailTitle.
  ///
  /// In ar, this message translates to:
  /// **'لم نتمكن من تأكيد الدفعة'**
  String get payFailTitle;

  /// No description provided for @payFailBody.
  ///
  /// In ar, this message translates to:
  /// **'رقم العملية لا يطابق المبلغ أو الحساب. طلبك محفوظ لمدة {time}.'**
  String payFailBody(String time);

  /// No description provided for @payFailNote.
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة المحل: {note}'**
  String payFailNote(String note);

  /// No description provided for @payFailResend.
  ///
  /// In ar, this message translates to:
  /// **'إعادة إرسال الإيصال'**
  String get payFailResend;

  /// No description provided for @payFailCash.
  ///
  /// In ar, this message translates to:
  /// **'الدفع عند الاستلام بدلاً من ذلك'**
  String get payFailCash;

  /// No description provided for @payFailContact.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع المحل'**
  String get payFailContact;

  /// No description provided for @orderTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلب {number}'**
  String orderTitle(String number);

  /// No description provided for @ordersTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get ordersTitle;

  /// No description provided for @ordersCurrent.
  ///
  /// In ar, this message translates to:
  /// **'الحالية · {count}'**
  String ordersCurrent(int count);

  /// No description provided for @ordersPast.
  ///
  /// In ar, this message translates to:
  /// **'السابقة · {count}'**
  String ordersPast(int count);

  /// No description provided for @ordersPastTitle.
  ///
  /// In ar, this message translates to:
  /// **'السابقة'**
  String get ordersPastTitle;

  /// No description provided for @ordersEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا طلبات بعد. حين تطلب، تجد طلبك هنا لتتابعه.'**
  String get ordersEmpty;

  /// No description provided for @ordersPieces.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{قطعة واحدة} =2{قطعتان} few{{count} قطع} other{{count} قطعة}}'**
  String ordersPieces(int count);

  /// No description provided for @ordersTrack.
  ///
  /// In ar, this message translates to:
  /// **'تتبّع الطلب'**
  String get ordersTrack;

  /// No description provided for @ordersAgain.
  ///
  /// In ar, this message translates to:
  /// **'اطلب مجدداً'**
  String get ordersAgain;

  /// No description provided for @ordersAgainDone.
  ///
  /// In ar, this message translates to:
  /// **'أُضيفت محتويات الطلب إلى السلة'**
  String get ordersAgainDone;

  /// No description provided for @ordersGuestTitle.
  ///
  /// In ar, this message translates to:
  /// **'طلبت كضيف؟'**
  String get ordersGuestTitle;

  /// No description provided for @ordersGuestBody.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رقم الطلب ورقم الهاتف الذي طلبت به.'**
  String get ordersGuestBody;

  /// No description provided for @ordersNumber.
  ///
  /// In ar, this message translates to:
  /// **'رقم الطلب'**
  String get ordersNumber;

  /// No description provided for @ordersShow.
  ///
  /// In ar, this message translates to:
  /// **'عرض الطلب'**
  String get ordersShow;

  /// No description provided for @ordersNotFound.
  ///
  /// In ar, this message translates to:
  /// **'لم نجد طلباً بهذا الرقم والهاتف.'**
  String get ordersNotFound;

  /// No description provided for @statusNew.
  ///
  /// In ar, this message translates to:
  /// **'تم استلام الطلب'**
  String get statusNew;

  /// No description provided for @statusConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب'**
  String get statusConfirmed;

  /// No description provided for @statusPreparing.
  ///
  /// In ar, this message translates to:
  /// **'قيد التحضير'**
  String get statusPreparing;

  /// No description provided for @statusReady.
  ///
  /// In ar, this message translates to:
  /// **'جاهز'**
  String get statusReady;

  /// No description provided for @statusOut.
  ///
  /// In ar, this message translates to:
  /// **'خرج للتوصيل'**
  String get statusOut;

  /// No description provided for @statusDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تم التسليم'**
  String get statusDelivered;

  /// No description provided for @statusPickedUp.
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام'**
  String get statusPickedUp;

  /// No description provided for @statusCancelled.
  ///
  /// In ar, this message translates to:
  /// **'ملغى'**
  String get statusCancelled;

  /// No description provided for @statusAwaitingShop.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار تأكيد المحل'**
  String get statusAwaitingShop;

  /// No description provided for @statusAwaitingPayment.
  ///
  /// In ar, this message translates to:
  /// **'بانتظار الدفع'**
  String get statusAwaitingPayment;

  /// No description provided for @statusPaymentProblem.
  ///
  /// In ar, this message translates to:
  /// **'مشكلة في الدفع'**
  String get statusPaymentProblem;

  /// No description provided for @trackCurrent.
  ///
  /// In ar, this message translates to:
  /// **'الحالة الحالية'**
  String get trackCurrent;

  /// No description provided for @trackAfterPayment.
  ///
  /// In ar, this message translates to:
  /// **'بعد التحقق من الدفع'**
  String get trackAfterPayment;

  /// No description provided for @trackExplainNew.
  ///
  /// In ar, this message translates to:
  /// **'يتصل بك المحل أو يراسلك على واتساب لتأكيد الطلب.'**
  String get trackExplainNew;

  /// No description provided for @trackExplainSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'يتحقق المحل من دفعة شام كاش. يصلك إشعار عند تأكيد الطلب.'**
  String get trackExplainSubmitted;

  /// No description provided for @trackExplainUnpaid.
  ///
  /// In ar, this message translates to:
  /// **'أكمل الدفع بشام كاش قبل انتهاء المهلة، وإلا يُلغى الطلب.'**
  String get trackExplainUnpaid;

  /// No description provided for @trackExplainConfirmed.
  ///
  /// In ar, this message translates to:
  /// **'أكّد المحل طلبك وسيبدأ بتجهيزه قريباً.'**
  String get trackExplainConfirmed;

  /// No description provided for @trackExplainPreparing.
  ///
  /// In ar, this message translates to:
  /// **'يجهّز المحل طلبك الآن حسب الوصفة.'**
  String get trackExplainPreparing;

  /// No description provided for @trackExplainReady.
  ///
  /// In ar, this message translates to:
  /// **'طلبك جاهز.'**
  String get trackExplainReady;

  /// No description provided for @trackExplainReadyPickup.
  ///
  /// In ar, this message translates to:
  /// **'طلبك جاهز للاستلام من الفرع.'**
  String get trackExplainReadyPickup;

  /// No description provided for @trackExplainOut.
  ///
  /// In ar, this message translates to:
  /// **'المندوب في الطريق إليك.'**
  String get trackExplainOut;

  /// No description provided for @trackExplainDone.
  ///
  /// In ar, this message translates to:
  /// **'شكراً لك! نتمنى أن تعجبك.'**
  String get trackExplainDone;

  /// No description provided for @trackExplainCancelled.
  ///
  /// In ar, this message translates to:
  /// **'أُلغي هذا الطلب.'**
  String get trackExplainCancelled;

  /// No description provided for @trackDelivery.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل'**
  String get trackDelivery;

  /// No description provided for @trackPickup.
  ///
  /// In ar, this message translates to:
  /// **'الاستلام'**
  String get trackPickup;

  /// No description provided for @trackCallBefore.
  ///
  /// In ar, this message translates to:
  /// **'اتصل قبل الوصول'**
  String get trackCallBefore;

  /// No description provided for @trackContents.
  ///
  /// In ar, this message translates to:
  /// **'المحتويات'**
  String get trackContents;

  /// No description provided for @trackPayment.
  ///
  /// In ar, this message translates to:
  /// **'الدفع'**
  String get trackPayment;

  /// No description provided for @trackPayNow.
  ///
  /// In ar, this message translates to:
  /// **'ادفع الآن بشام كاش'**
  String get trackPayNow;

  /// No description provided for @trackCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get trackCancel;

  /// No description provided for @trackCancelHint.
  ///
  /// In ar, this message translates to:
  /// **'يمكن الإلغاء من هنا قبل تأكيد الطلب فقط. بعد ذلك تواصل مع المحل.'**
  String get trackCancelHint;

  /// No description provided for @trackCancelAsk.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد إلغاء الطلب {number}؟'**
  String trackCancelAsk(String number);

  /// No description provided for @trackCancelYes.
  ///
  /// In ar, this message translates to:
  /// **'نعم، ألغِ الطلب'**
  String get trackCancelYes;

  /// No description provided for @trackCancelNo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get trackCancelNo;

  /// No description provided for @trackCancelled.
  ///
  /// In ar, this message translates to:
  /// **'أُلغي الطلب'**
  String get trackCancelled;

  /// No description provided for @payStatePending.
  ///
  /// In ar, this message translates to:
  /// **'غير مدفوع'**
  String get payStatePending;

  /// No description provided for @payStateSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'قيد التحقق'**
  String get payStateSubmitted;

  /// No description provided for @payStatePaid.
  ///
  /// In ar, this message translates to:
  /// **'مدفوع'**
  String get payStatePaid;

  /// No description provided for @payStateFailed.
  ///
  /// In ar, this message translates to:
  /// **'لم تُطابق الدفعة'**
  String get payStateFailed;

  /// No description provided for @payStateRefunded.
  ///
  /// In ar, this message translates to:
  /// **'مُسترد'**
  String get payStateRefunded;

  /// No description provided for @payMethodState.
  ///
  /// In ar, this message translates to:
  /// **'{method} · {state}'**
  String payMethodState(String method, String state);

  /// No description provided for @checkoutTodayOver.
  ///
  /// In ar, this message translates to:
  /// **'انتهت مواعيد اليوم. اختر يوماً آخر.'**
  String get checkoutTodayOver;

  /// No description provided for @accountTitle.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get accountTitle;

  /// No description provided for @accountOrdersCurrent.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{لا طلب حالي} =1{طلب حالي} =2{طلبان حاليان} few{{count} طلبات حالية} other{{count} طلباً حالياً}}'**
  String accountOrdersCurrent(int count);

  /// No description provided for @accountAddresses.
  ///
  /// In ar, this message translates to:
  /// **'عناويني'**
  String get accountAddresses;

  /// No description provided for @accountDesigns.
  ///
  /// In ar, this message translates to:
  /// **'تصاميمي'**
  String get accountDesigns;

  /// No description provided for @accountOccasions.
  ///
  /// In ar, this message translates to:
  /// **'مناسباتي'**
  String get accountOccasions;

  /// No description provided for @accountOccasionNext.
  ///
  /// In ar, this message translates to:
  /// **'{when}: {occasion} {person}'**
  String accountOccasionNext(String when, String occasion, String person);

  /// No description provided for @accountSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات واللغة والعملة'**
  String get accountSettings;

  /// No description provided for @accountPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية والشروط'**
  String get accountPrivacy;

  /// No description provided for @accountEditProfile.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف'**
  String get accountEditProfile;

  /// No description provided for @accountDeletionPending.
  ///
  /// In ar, this message translates to:
  /// **'طلبت حذف الحساب. سجّل الدخول خلال 30 يوماً لإلغاء الطلب.'**
  String get accountDeletionPending;

  /// No description provided for @profileTitle.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profileTitle;

  /// No description provided for @profileEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني (اختياري)'**
  String get profileEmail;

  /// No description provided for @profileSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get profileSave;

  /// No description provided for @profileSaved.
  ///
  /// In ar, this message translates to:
  /// **'حُفظت التغييرات'**
  String get profileSaved;

  /// No description provided for @profilePhoneNote.
  ///
  /// In ar, this message translates to:
  /// **'لتغيير رقم الهاتف سجّل الدخول بالرقم الجديد، أو راسل المحل.'**
  String get profilePhoneNote;

  /// No description provided for @addressesDefault.
  ///
  /// In ar, this message translates to:
  /// **'افتراضي'**
  String get addressesDefault;

  /// No description provided for @addressesAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنوان جديد'**
  String get addressesAdd;

  /// No description provided for @addressesOutNote.
  ///
  /// In ar, this message translates to:
  /// **'العناوين خارج مناطق التوصيل تُحفظ لكنها لا تظهر عند الدفع.'**
  String get addressesOutNote;

  /// No description provided for @addressesOutBadge.
  ///
  /// In ar, this message translates to:
  /// **'خارج مناطق التوصيل'**
  String get addressesOutBadge;

  /// No description provided for @addressesMakeDefault.
  ///
  /// In ar, this message translates to:
  /// **'اجعله الافتراضي'**
  String get addressesMakeDefault;

  /// No description provided for @addressesEdit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get addressesEdit;

  /// No description provided for @addressesDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get addressesDelete;

  /// No description provided for @addressesDeleteAsk.
  ///
  /// In ar, this message translates to:
  /// **'حذف العنوان «{label}»؟'**
  String addressesDeleteAsk(String label);

  /// No description provided for @addressesEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لا عناوين محفوظة بعد.'**
  String get addressesEmpty;

  /// No description provided for @addressesSaved.
  ///
  /// In ar, this message translates to:
  /// **'حُفظ العنوان'**
  String get addressesSaved;

  /// No description provided for @addressDefaultToggle.
  ///
  /// In ar, this message translates to:
  /// **'العنوان الافتراضي عند الطلب'**
  String get addressDefaultToggle;

  /// No description provided for @designsPreview.
  ///
  /// In ar, this message translates to:
  /// **'معاينة التصميم'**
  String get designsPreview;

  /// No description provided for @designsStems.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{وردة واحدة} =2{وردتان} few{{count} ورود} other{{count} وردة}}'**
  String designsStems(int count);

  /// No description provided for @designsOpen.
  ///
  /// In ar, this message translates to:
  /// **'فتح'**
  String get designsOpen;

  /// No description provided for @designsNew.
  ///
  /// In ar, this message translates to:
  /// **'تصميم جديد'**
  String get designsNew;

  /// No description provided for @designsPriceNote.
  ///
  /// In ar, this message translates to:
  /// **'تُحدّث الأسعار عند فتح التصميم حسب ورد اليوم. الورد غير المتوفر يظهر مع بديل مقترح.'**
  String get designsPriceNote;

  /// No description provided for @designsUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'بعض الورد غير متوفر اليوم'**
  String get designsUnavailable;

  /// No description provided for @designsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'لم تحفظ أي تصميم بعد. احفظ تصميمك من الخطوة الأخيرة في المصمّم.'**
  String get designsEmpty;

  /// No description provided for @designsDeleteAsk.
  ///
  /// In ar, this message translates to:
  /// **'حذف التصميم «{name}»؟'**
  String designsDeleteAsk(String name);

  /// No description provided for @designSave.
  ///
  /// In ar, this message translates to:
  /// **'احفظ في تصاميمي'**
  String get designSave;

  /// No description provided for @designSaveName.
  ///
  /// In ar, this message translates to:
  /// **'اسم التصميم'**
  String get designSaveName;

  /// No description provided for @designSaved.
  ///
  /// In ar, this message translates to:
  /// **'حُفظ التصميم في تصاميمي'**
  String get designSaved;

  /// No description provided for @designSaveSignIn.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول لتحفظ تصاميمك.'**
  String get designSaveSignIn;

  /// No description provided for @occasionsTitle.
  ///
  /// In ar, this message translates to:
  /// **'مناسباتي'**
  String get occasionsTitle;

  /// No description provided for @occasionsWhen.
  ///
  /// In ar, this message translates to:
  /// **'{date} · {left}'**
  String occasionsWhen(String date, String left);

  /// No description provided for @occasionsToday.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get occasionsToday;

  /// No description provided for @occasionsTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'غداً'**
  String get occasionsTomorrow;

  /// No description provided for @occasionsInDays.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =2{بعد يومين} few{بعد {count} أيام} other{بعد {count} يوماً}}'**
  String occasionsInDays(int count);

  /// No description provided for @occasionsRemind.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =0{تذكير في اليوم نفسه} =1{تذكير قبل يوم} =2{تذكير قبل يومين} few{تذكير قبل {count} أيام} other{تذكير قبل {count} يوماً}}'**
  String occasionsRemind(int count);

  /// No description provided for @occasionsDesign.
  ///
  /// In ar, this message translates to:
  /// **'صمّم باقة'**
  String get occasionsDesign;

  /// No description provided for @occasionsAdd.
  ///
  /// In ar, this message translates to:
  /// **'إضافة مناسبة'**
  String get occasionsAdd;

  /// No description provided for @occasionsPerson.
  ///
  /// In ar, this message translates to:
  /// **'الشخص'**
  String get occasionsPerson;

  /// No description provided for @occasionsPersonHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: ماما'**
  String get occasionsPersonHint;

  /// No description provided for @occasionsType.
  ///
  /// In ar, this message translates to:
  /// **'نوع المناسبة'**
  String get occasionsType;

  /// No description provided for @occasionBirthday.
  ///
  /// In ar, this message translates to:
  /// **'عيد ميلاد'**
  String get occasionBirthday;

  /// No description provided for @occasionAnniversary.
  ///
  /// In ar, this message translates to:
  /// **'ذكرى'**
  String get occasionAnniversary;

  /// No description provided for @occasionGraduation.
  ///
  /// In ar, this message translates to:
  /// **'تخرج'**
  String get occasionGraduation;

  /// No description provided for @occasionOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get occasionOther;

  /// No description provided for @occasionsDate.
  ///
  /// In ar, this message translates to:
  /// **'التاريخ'**
  String get occasionsDate;

  /// No description provided for @occasionsPickDate.
  ///
  /// In ar, this message translates to:
  /// **'اختر التاريخ'**
  String get occasionsPickDate;

  /// No description provided for @occasionsRemindBefore.
  ///
  /// In ar, this message translates to:
  /// **'ذكّرني قبل'**
  String get occasionsRemindBefore;

  /// No description provided for @occasionsDays.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{يوم} =2{يومان} few{{count} أيام} other{{count} يوماً}}'**
  String occasionsDays(int count);

  /// No description provided for @occasionsSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ المناسبة'**
  String get occasionsSave;

  /// No description provided for @occasionsNote.
  ///
  /// In ar, this message translates to:
  /// **'التذكير يصلك كإشعار. يمكنك إيقافه من الإعدادات.'**
  String get occasionsNote;

  /// No description provided for @occasionsEmpty.
  ///
  /// In ar, this message translates to:
  /// **'أضف أعياد الميلاد والذكريات، ونذكّرك قبلها لتطلب باقة في وقتها.'**
  String get occasionsEmpty;

  /// No description provided for @occasionsDeleteAsk.
  ///
  /// In ar, this message translates to:
  /// **'حذف المناسبة «{person}»؟'**
  String occasionsDeleteAsk(String person);

  /// No description provided for @occasionsNeedFields.
  ///
  /// In ar, this message translates to:
  /// **'اكتب الاسم واختر التاريخ.'**
  String get occasionsNeedFields;

  /// No description provided for @settingsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settingsTitle;

  /// No description provided for @settingsDisplay.
  ///
  /// In ar, this message translates to:
  /// **'العرض'**
  String get settingsDisplay;

  /// No description provided for @settingsLanguage.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguage;

  /// No description provided for @settingsCurrency.
  ///
  /// In ar, this message translates to:
  /// **'العملة'**
  String get settingsCurrency;

  /// No description provided for @settingsCurrencySyp.
  ///
  /// In ar, this message translates to:
  /// **'ليرة سورية (ل.س)'**
  String get settingsCurrencySyp;

  /// No description provided for @settingsCurrencyUsd.
  ///
  /// In ar, this message translates to:
  /// **'دولار (\$)'**
  String get settingsCurrencyUsd;

  /// No description provided for @settingsCurrencyNote.
  ///
  /// In ar, this message translates to:
  /// **'الدفع يتم بعملة طريقة الدفع؛ الدولار للعرض وStripe فقط.'**
  String get settingsCurrencyNote;

  /// No description provided for @settingsDigits.
  ///
  /// In ar, this message translates to:
  /// **'شكل الأرقام'**
  String get settingsDigits;

  /// No description provided for @settingsNotifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get settingsNotifications;

  /// No description provided for @settingsOrderStatus.
  ///
  /// In ar, this message translates to:
  /// **'حالة الطلب'**
  String get settingsOrderStatus;

  /// No description provided for @settingsOrderStatusNote.
  ///
  /// In ar, this message translates to:
  /// **'لا يمكن إيقافها أثناء وجود طلب حالي'**
  String get settingsOrderStatusNote;

  /// No description provided for @settingsOccasions.
  ///
  /// In ar, this message translates to:
  /// **'تذكير المناسبات'**
  String get settingsOccasions;

  /// No description provided for @settingsOffers.
  ///
  /// In ar, this message translates to:
  /// **'ورد اليوم والعروض'**
  String get settingsOffers;

  /// No description provided for @settingsWhatsapp.
  ///
  /// In ar, this message translates to:
  /// **'رسائل واتساب'**
  String get settingsWhatsapp;

  /// No description provided for @settingsWhatsappNote.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب والتوصيل'**
  String get settingsWhatsappNote;

  /// No description provided for @settingsPrivacy.
  ///
  /// In ar, this message translates to:
  /// **'الخصوصية'**
  String get settingsPrivacy;

  /// No description provided for @settingsAnalytics.
  ///
  /// In ar, this message translates to:
  /// **'التحليلات وتحسين التطبيق'**
  String get settingsAnalytics;

  /// No description provided for @settingsExport.
  ///
  /// In ar, this message translates to:
  /// **'تصدير بياناتي'**
  String get settingsExport;

  /// No description provided for @settingsExported.
  ///
  /// In ar, this message translates to:
  /// **'جُهّز ملف بياناتك'**
  String get settingsExported;

  /// No description provided for @settingsDelete.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get settingsDelete;

  /// No description provided for @settingsDeleteAsk.
  ///
  /// In ar, this message translates to:
  /// **'نحذف حسابك وعناوينك وتصاميمك ومناسباتك بعد 30 يوماً. إن سجّلت الدخول خلال هذه المدة يبقى حسابك. تبقى الطلبات السابقة لدى المحل دون بياناتك الشخصية.'**
  String get settingsDeleteAsk;

  /// No description provided for @settingsDeleteYes.
  ///
  /// In ar, this message translates to:
  /// **'احذف حسابي'**
  String get settingsDeleteYes;

  /// No description provided for @settingsDeleteNo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get settingsDeleteNo;

  /// No description provided for @settingsDeleted.
  ///
  /// In ar, this message translates to:
  /// **'طلبنا حذف حسابك وسجّلنا خروجك.'**
  String get settingsDeleted;

  /// No description provided for @settingsVersion.
  ///
  /// In ar, this message translates to:
  /// **'الإصدار {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsSignInFor.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول لضبط الإشعارات وبياناتك.'**
  String get settingsSignInFor;
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
    'that was used.',
  );
}
