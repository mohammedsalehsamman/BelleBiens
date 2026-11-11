// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Belle Biens';

  @override
  String get navHome => 'Home';

  @override
  String get navShop => 'Shop';

  @override
  String get navDesigner => 'Design';

  @override
  String get navOrders => 'My orders';

  @override
  String get navAccount => 'Account';

  @override
  String get comingSoon => 'Under construction';

  @override
  String comingSoonBody(String sprint) {
    return 'This screen is built in sprint $sprint.';
  }

  @override
  String environmentBadge(String name) {
    return 'Environment: $name';
  }

  @override
  String get commonBack => 'Back';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonOr => 'or';

  @override
  String get commonLater => 'Later';

  @override
  String get commonRetry => 'Try again';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorTimeout =>
      'The connection is slow. Please try again in a moment.';

  @override
  String get errorGeneric =>
      'Something went wrong. Please try again in a moment.';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get onboardingBrowseAsGuest => 'Browse as guest';

  @override
  String get onboardingPhotoLabel => 'Photo: a bouquet from the shop';

  @override
  String get onboardingBadge => 'Flowers · Sweets · Coffee · Gifts';

  @override
  String get onboardingEyebrow => 'BELLE BIENS · DAMASCUS';

  @override
  String get onboardingTitle => 'Welcome to Belle Biens';

  @override
  String get onboardingBody =>
      'Fresh flowers, cakes and sweets, coffee and matcha, and gifts from our Abu Rummaneh branch.';

  @override
  String get onboardingDesignTitle => 'Design your own bouquet';

  @override
  String get onboardingDesignBody =>
      'Pick the flowers and wrap, and see the bouquet and its price as you go.';

  @override
  String get onboardingDeliveryTitle => 'Delivery in Damascus or pickup';

  @override
  String get onboardingDeliveryBody =>
      'Today, tomorrow or on the day of your occasion.';

  @override
  String get onboardingWhatsappTitle => 'WhatsApp is always open';

  @override
  String get onboardingWhatsappBody =>
      'Ask the shop or confirm your order by message.';

  @override
  String get onboardingCreateAccount => 'Create account';

  @override
  String get onboardingSignIn => 'Sign in';

  @override
  String get onboardingContinueAsGuest => 'Continue as guest';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginHeading => 'Welcome back';

  @override
  String get loginBody =>
      'Enter your phone number and we will text you a code, or sign in with email.';

  @override
  String get loginTabPhone => 'Phone number';

  @override
  String get loginTabEmail => 'Email';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '0944 123 456';

  @override
  String get phoneHelper =>
      '09XXXXXXXX, +9639XXXXXXXX, or an international number if you live abroad.';

  @override
  String get phoneInvalid =>
      'This phone number is not valid. Use 09XXXXXXXX, +9639XXXXXXXX or an international number starting with +.';

  @override
  String get loginSendCode => 'Send code';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'name@example.com';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get loginWithEmail => 'Sign in';

  @override
  String get loginGoogle => 'Continue with Google';

  @override
  String get loginNoAccount => 'No account yet?';

  @override
  String get loginBrowseAsGuest => 'Browse as guest';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerHeading => 'Create your account';

  @override
  String get registerBody =>
      'Save your addresses and designs, follow your orders, and remember the occasions of the people you love.';

  @override
  String get nameLabel => 'Full name';

  @override
  String get nameHint => 'e.g. Sara Al-Ahmad';

  @override
  String get nameRequired => 'Enter your name.';

  @override
  String get mobileLabel => 'Mobile number';

  @override
  String get mobileHint => '09XX XXX XXX';

  @override
  String get mobileHelper => 'We will send a code to confirm the number.';

  @override
  String get emailOptionalLabel => 'Email (optional)';

  @override
  String get areaLabel => 'Your area in Damascus (to suggest delivery)';

  @override
  String get areaHelper => 'The list comes from the shop\'s delivery zones.';

  @override
  String get areaAbuRummaneh => 'Abu Rummaneh';

  @override
  String get areaMalki => 'Malki';

  @override
  String get areaMazzeh => 'Mazzeh';

  @override
  String get areaShaalan => 'Shaalan';

  @override
  String get areaQassaa => 'Qassaa';

  @override
  String get areaOther => 'Another area';

  @override
  String get termsAccept => 'I accept the terms of use and the privacy policy.';

  @override
  String get termsRequired =>
      'Please accept the terms of use and the privacy policy to create an account.';

  @override
  String get marketingOptIn =>
      'Send me offers and occasion reminders (you can turn this off later).';

  @override
  String get registerSubmit => 'Create account and verify';

  @override
  String get registerGoogle => 'Sign up with Google';

  @override
  String get registerHaveAccount => 'Already have an account?';

  @override
  String get otpTitle => 'Verification code';

  @override
  String get otpHeading => 'Enter the code we sent you';

  @override
  String otpSentSms(int length) {
    return 'We sent a $length-digit code by SMS to';
  }

  @override
  String otpSentWhatsapp(int length) {
    return 'We sent a $length-digit code on WhatsApp to';
  }

  @override
  String get otpFieldLabel => 'Verification code';

  @override
  String otpResendIn(String time) {
    return 'You can ask for a new code in $time';
  }

  @override
  String get otpResendSms => 'Send a new code';

  @override
  String get otpSendWhatsapp => 'Send the code on WhatsApp instead of SMS';

  @override
  String get otpConfirm => 'Confirm';

  @override
  String get otpNotice =>
      'The code works for 5 minutes and you have 5 tries. Didn\'t get it? Message us on WhatsApp.';

  @override
  String otpAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tries left.',
      one: '1 try left.',
    );
    return '$_temp0';
  }

  @override
  String get completeTitle => 'Finish your account';

  @override
  String get completeHeading => 'One last step';

  @override
  String get completeBody =>
      'Tell us your name and accept the terms so we can save your orders and addresses.';

  @override
  String get completeSubmit => 'Save and continue';

  @override
  String get notifyLater => 'Later';

  @override
  String get notifyHeading => 'Stay up to date with your orders';

  @override
  String get notifyBody =>
      'Turn on notifications to follow your order and get reminders for your occasions. We only send offers if you agree.';

  @override
  String get notifyOrderTitle => 'Order status';

  @override
  String get notifyOrderBody =>
      'When your order is confirmed, out for delivery, and delivered.';

  @override
  String get notifyOccasionTitle => 'Occasion reminders';

  @override
  String get notifyOccasionBody =>
      'Before the birthdays and anniversaries you save.';

  @override
  String get notifyOffersTitle => 'Today\'s flowers and offers';

  @override
  String get notifyOffersBody => 'Optional; you can turn it off in settings.';

  @override
  String get notifyEnable => 'Turn on notifications';

  @override
  String get notifySystemHint => 'Your phone will then ask for permission.';

  @override
  String get accountGuestTitle => 'You are browsing as a guest';

  @override
  String get accountGuestBody =>
      'Sign in to save your addresses and designs and follow your orders.';

  @override
  String accountHello(String name) {
    return 'Hello, $name';
  }

  @override
  String get accountSignOut => 'Sign out';

  @override
  String get accountLanguage => 'Language';
}
