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

  @override
  String get currencySyp => 'SYP';

  @override
  String get currencyUsd => '\$';

  @override
  String homeDeliveryTo(String area) {
    return 'Delivering to: $area';
  }

  @override
  String get homeSearchHint => 'Search bouquets, cakes, gifts…';

  @override
  String get homeDesignerEyebrow => 'Bouquet designer';

  @override
  String get homeDesignerTitle => 'Design your own bouquet';

  @override
  String get homeDesignerBody =>
      'Pick the flowers, wrap and extras, and see the bouquet and its price before you order.';

  @override
  String get homeDesignerCta => 'Start designing';

  @override
  String get homeOrderNow => 'Order now';

  @override
  String get homeOrderNowSub => 'Delivery or pickup';

  @override
  String get homeWhatsapp => 'WhatsApp';

  @override
  String get homeWhatsappSub => 'Ask the shop';

  @override
  String get homeCategories => 'Categories';

  @override
  String get homeTodayTitle => 'Today\'s flowers';

  @override
  String get homeTodaySub => 'What is fresh in the shop today';

  @override
  String get homeCakesTitle => 'Cakes & sweets';

  @override
  String get homeCakesSub => 'Made daily in the shop kitchen';

  @override
  String get seeAll => 'See all';

  @override
  String get shopOpenNow => 'Open now';

  @override
  String get shopBusyNow => 'Busy right now';

  @override
  String get shopClosedNow => 'Closed now';

  @override
  String shopUntil(String time) {
    return 'Until $time';
  }

  @override
  String shopOpensAt(String time) {
    return 'Opens $time';
  }

  @override
  String get branchHoursLabel => 'Opening hours';

  @override
  String branchHoursDaily(String open, String close) {
    return 'Daily $open – $close';
  }

  @override
  String get branchMap => 'Map';

  @override
  String get branchInstagram => 'Instagram';

  @override
  String get branchTitle => 'Branch & contact';

  @override
  String get branchDirections => 'Directions';

  @override
  String get branchCall => 'Call';

  @override
  String get branchPolicies => 'Policies';

  @override
  String branchPartners(String list) {
    return 'Also on $list';
  }

  @override
  String get branchContactSoon =>
      'The shop will add its phone and WhatsApp numbers soon.';

  @override
  String get badgeBestSeller => 'Best seller';

  @override
  String get badgeSeasonal => 'Seasonal';

  @override
  String get badgeToday => 'Today\'s flowers';

  @override
  String get badgeTodayOnly => 'Today only';

  @override
  String get badgeLimited => 'Limited';

  @override
  String get badgeUnavailable => 'Not available today';

  @override
  String priceFrom(String price) {
    return 'From $price';
  }

  @override
  String priceApprox(String price) {
    return '≈ $price';
  }

  @override
  String get shopTitle => 'Shop';

  @override
  String get shopSearchHint => 'Search the shop';

  @override
  String get shopFilters => 'Filters';

  @override
  String shopFiltersCount(int count) {
    return 'Filters · $count';
  }

  @override
  String get shopAll => 'All';

  @override
  String shopResultsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String shopSortedBy(String sort) {
    return 'Sorted by: $sort';
  }

  @override
  String get sortPopular => 'Most ordered';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortPriceAsc => 'Price: low to high';

  @override
  String get sortPriceDesc => 'Price: high to low';

  @override
  String get shopSortTitle => 'Sort products';

  @override
  String get shopOpenForOrders => 'Open for orders';

  @override
  String get shopLoadMore => 'Show more';

  @override
  String get shopEmpty => 'No products match these filters.';

  @override
  String get shopClearFilters => 'Clear filters';

  @override
  String get filtersOccasion => 'Occasion';

  @override
  String get filtersColor => 'Color';

  @override
  String get filtersFlowerType => 'Flower type';

  @override
  String filtersPrice(String currency) {
    return 'Price ($currency)';
  }

  @override
  String get filtersAvailableToday => 'Available today only';

  @override
  String get filtersDeliverableToday => 'Can be delivered today';

  @override
  String get filtersClearAll => 'Clear all';

  @override
  String filtersShowCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count products',
      one: 'Show 1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String get filtersShowResults => 'Show results';

  @override
  String get searchRecent => 'Recent searches';

  @override
  String get searchClear => 'Clear';

  @override
  String searchTab(String name, int count) {
    return '$name · $count';
  }

  @override
  String searchNoResults(String query) {
    return 'No results for “$query”. Try another word.';
  }

  @override
  String get searchOfflineNote =>
      'You are offline. Searching products saved on this phone.';

  @override
  String get todayNotice =>
      'The shop updates this list every day. It expires at midnight, Damascus time.';

  @override
  String todayLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count left',
      one: '1 left',
    );
    return '$_temp0';
  }

  @override
  String get todayAvailable => 'Available';

  @override
  String get todayStemsTitle => 'Flowers for the designer today';

  @override
  String todayStem(String name, String count) {
    return '$name · $count';
  }

  @override
  String get todayDesignCta => 'Design a bouquet from today\'s flowers';

  @override
  String get todayEmpty =>
      'The shop has not posted today\'s list yet. Check back later.';

  @override
  String get occasionTabFlowers => 'Flowers';

  @override
  String get occasionTabCakes => 'Cakes';

  @override
  String get occasionTabExtras => 'Extras';

  @override
  String occasionDesignCta(String occasion) {
    return 'Design a $occasion bouquet';
  }

  @override
  String occasionDesignSub(String occasion) {
    return 'Starts with “$occasion” already chosen';
  }

  @override
  String get productReadyBouquet => 'Ready-made bouquet';

  @override
  String productSelected(String group, String option) {
    return 'Selected $group: $option';
  }

  @override
  String get productCustomizeTitle => 'Want a personal touch?';

  @override
  String get productCustomizeBody =>
      'Open this bouquet in the designer and change the flowers and colors.';

  @override
  String get productCustomize => 'Customize';

  @override
  String get productIncluded => '(included)';

  @override
  String get optionIncluded => 'Included';

  @override
  String productEarliest(String when) {
    return 'Earliest delivery: $when';
  }

  @override
  String get whenToday => 'today';

  @override
  String get whenTomorrow => 'tomorrow';

  @override
  String whenInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
    );
    return '$_temp0';
  }

  @override
  String get productDeliveryNote =>
      'Delivery inside Damascus by area, or free pickup at the Abu Rummaneh branch.';

  @override
  String get productDeliveryPolicy => 'Delivery policy';

  @override
  String get productDisclaimer =>
      'The final bouquet may differ slightly depending on the fresh flowers available.';

  @override
  String get productPairingsGift => 'Add to your gift';

  @override
  String get productPairingsDrink => 'Goes well with your drink';

  @override
  String productAllergens(String list) {
    return 'Allergens: $list';
  }

  @override
  String get allergenNuts => 'nuts';

  @override
  String get allergenMilk => 'milk';

  @override
  String get allergenEggs => 'eggs';

  @override
  String get allergenGluten => 'gluten';

  @override
  String productLeadTime(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'Order $hours hours ahead',
      one: 'Order 1 hour ahead',
    );
    return '$_temp0';
  }

  @override
  String get productAskTitle => 'Have a question?';

  @override
  String get productAskBody => 'Message the shop on WhatsApp';

  @override
  String get productTotal => 'Total';

  @override
  String get productAddToCart => 'Add to cart';

  @override
  String productAddWithTotal(String price) {
    return 'Add · $price';
  }

  @override
  String get productCartSoon => 'The cart arrives in the next update.';

  @override
  String get productUnavailable =>
      'Not available today. Save it and order later.';

  @override
  String get productFavoriteAdd => 'Save to favorites';

  @override
  String get productFavoriteRemove => 'Remove from favorites';

  @override
  String get productQuantity => 'Quantity';

  @override
  String get favoriteSignIn => 'Sign in to save your favorites.';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty =>
      'Nothing saved yet. Tap the heart on a product page.';

  @override
  String get offlineBanner => 'You are offline. Showing the last saved copy.';

  @override
  String get loadFailed => 'Could not load.';

  @override
  String imagePlaceholder(String name) {
    return 'Photo of $name';
  }

  @override
  String get designerTitle => 'Design your bouquet';

  @override
  String designerStepCaption(int current, String name) {
    return 'Step $current of 4 · $name';
  }

  @override
  String get designerStepOccasion => 'Occasion and size';

  @override
  String get designerStepFlowers => 'Flowers and greens';

  @override
  String get designerStepWrap => 'Wrap and extras';

  @override
  String get designerStepCard => 'Card and preview';

  @override
  String get designerPreviewLabel => 'Live bouquet preview';

  @override
  String get designerLive => 'Live';

  @override
  String designerStems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stems',
      one: '1 stem',
      zero: 'No stems',
    );
    return '$_temp0';
  }

  @override
  String get designerPickFlowers => 'Choose flowers to see the price';

  @override
  String get designerOccasion => 'Occasion';

  @override
  String get designerSize => 'Size';

  @override
  String designerSizeRange(int min, int max) {
    return '$min – $max stems';
  }

  @override
  String get designerSizeNote =>
      'The shop sets how many stems each size holds.';

  @override
  String get designerPalette => 'Color palette';

  @override
  String get designerOptional => '(optional)';

  @override
  String get designerNextFlowers => 'Next: choose flowers';

  @override
  String get designerNextWrap => 'Next: wrap';

  @override
  String get designerNextCard => 'Next: card and preview';

  @override
  String get designerPrevious => 'Back';

  @override
  String designerStemsRange(String stems, int min, int max) {
    return '$stems of $min – $max';
  }

  @override
  String designerSizeName(String size) {
    return '$size size';
  }

  @override
  String get designerMainFlowers => 'Main flowers';

  @override
  String get designerPerStem => 'Price per stem';

  @override
  String designerAvailableCount(String price, String count) {
    return '$price · $count available';
  }

  @override
  String designerAvailable(String price) {
    return '$price · available';
  }

  @override
  String get designerUnavailable => 'Not available today';

  @override
  String get designerSuggest => 'Suggest a substitute';

  @override
  String get designerFillersGreens => 'Fillers and greens';

  @override
  String designerPerSprig(String price) {
    return '$price a sprig';
  }

  @override
  String get designerStockNote =>
      'Prices and quantities come from the shop\'s daily flower list.';

  @override
  String designerTooFew(int min) {
    return 'This size needs at least $min stems.';
  }

  @override
  String designerTooMany(int max) {
    return 'This size holds at most $max stems.';
  }

  @override
  String get designerFitsPalette => 'Fits your palette';

  @override
  String get designerWrap => 'Wrap';

  @override
  String get designerRibbon => 'Ribbon';

  @override
  String designerRibbonNote(String price) {
    return 'Satin ribbon · $price';
  }

  @override
  String get designerExtras => 'Extras';

  @override
  String get designerMode3d => '3D';

  @override
  String get designerModeAi => 'Realistic AI';

  @override
  String get designerModeSoon =>
      '3D and realistic previews arrive in release 3; until then the preview is 2D.';

  @override
  String get designerCard => 'Gift card';

  @override
  String get designerRecipient => 'Recipient\'s name';

  @override
  String get designerMessage => 'Message';

  @override
  String designerMessageCount(int count, int max) {
    return '$count / $max';
  }

  @override
  String get designerNoCard => 'No card';

  @override
  String get designerSummary => 'Bouquet summary';

  @override
  String designerLineQty(String name, int qty) {
    return '$name × $qty';
  }

  @override
  String designerWrapLine(String name) {
    return '$name wrap';
  }

  @override
  String designerRibbonLine(String name) {
    return '$name ribbon';
  }

  @override
  String get designerAssemblyFee => 'Arranging fee';

  @override
  String get designerSave => 'Save to my designs';

  @override
  String get designerSaveSoon =>
      'Saving designs to your account is coming soon. Your design is kept on this phone.';

  @override
  String get designerSend => 'Send to the shop';

  @override
  String get designerSendNoNumber =>
      'The shop will add its WhatsApp number soon.';

  @override
  String get designerWhatsappIntro =>
      'Hello, I designed this bouquet in the Belle Biens app:';

  @override
  String designerWhatsappTotal(String total) {
    return 'Total: $total';
  }

  @override
  String designerWhatsappPreview(String link) {
    return 'Preview: $link';
  }

  @override
  String get designerAddToCart => 'Add the bouquet to the cart';

  @override
  String get designerUndo => 'Undo';

  @override
  String get designerRedo => 'Redo';

  @override
  String get designerRestart => 'Start over';

  @override
  String get designerIssueBanner =>
      'Some flowers just ran out. See the substitutes.';

  @override
  String get designerFixStems => 'Adjust the stems to fit the size.';

  @override
  String get substituteTitle => 'Some flowers just ran out';

  @override
  String substituteBody(int available, String name, int qty) {
    return 'Only $available $name left; your design needs $qty.';
  }

  @override
  String substituteBodyNone(String name, int qty) {
    return '$name is not available today; your design needs $qty.';
  }

  @override
  String get substituteChoose => 'Choose a substitute';

  @override
  String get substituteSamePrice => 'Same price';

  @override
  String get substituteManual => 'Edit by hand';

  @override
  String get substituteApply => 'Apply the substitute';

  @override
  String get substituteNone =>
      'No substitute is available right now. Lower the quantity or pick another flower.';

  @override
  String substituteOption(String items) {
    return '$items';
  }

  @override
  String get cartTitle => 'Cart';

  @override
  String cartTitleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cart · $count items',
      one: 'Cart · 1 item',
      zero: 'Cart',
    );
    return '$_temp0';
  }

  @override
  String get cartOpen => 'Cart';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyBody =>
      'Start with a bouquet from today\'s flowers, or design your own.';

  @override
  String get cartBrowseToday => 'Browse today\'s flowers';

  @override
  String get cartEditDesign => 'Edit the design';

  @override
  String cartCardMessage(String message) {
    return 'Card: “$message”';
  }

  @override
  String cartRemove(String name) {
    return 'Remove $name';
  }

  @override
  String cartLeadNotice(int hours, String when) {
    return 'Some items need $hours hours to prepare, so the earliest time for the whole order is $when.';
  }

  @override
  String cartWhenToday(String time) {
    return 'today $time';
  }

  @override
  String cartWhenTomorrow(String time) {
    return 'tomorrow $time';
  }

  @override
  String cartWhenDate(String date, String time) {
    return '$date $time';
  }

  @override
  String get cartCoupon => 'Discount code';

  @override
  String get cartCouponApply => 'Apply';

  @override
  String get cartCouponRemove => 'Remove code';

  @override
  String cartCouponApplied(String code) {
    return '$code applied';
  }

  @override
  String get cartCouponNotFound => 'This code is not valid.';

  @override
  String get cartCouponExpired => 'This code has expired.';

  @override
  String get cartCouponUsedUp => 'This code has been used up.';

  @override
  String cartCouponMinOrder(String amount) {
    return 'This code works on orders of $amount or more.';
  }

  @override
  String get cartProducts => 'Products';

  @override
  String get cartDiscount => 'Discount';

  @override
  String get cartDelivery => 'Delivery';

  @override
  String get cartDeliveryLater => 'Set by your area';

  @override
  String get cartRounding => 'Rounding';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartSuggestions => 'You may also like';

  @override
  String get cartContinue => 'Continue to delivery';

  @override
  String get cartFixIssues => 'Fix the items in your cart before continuing.';

  @override
  String get cartAdded => 'Added to the cart';

  @override
  String get cartView => 'View cart';

  @override
  String get cartUpdated => 'Bouquet updated in the cart';

  @override
  String get cartUpdateDesign => 'Update the bouquet in the cart';

  @override
  String get issueProductUnavailable => 'Not available right now.';

  @override
  String get issueOptionUnavailable =>
      'One of the choices is no longer offered.';

  @override
  String issueStock(int count) {
    return 'Only $count available now.';
  }

  @override
  String get issueItemUnavailable => 'Something in this bouquet ran out.';

  @override
  String get issueStems => 'The stem count does not fit the size.';

  @override
  String get issueBox => 'The box contents do not fit its parts.';

  @override
  String get issueInscription => 'A message is not accepted for this product.';

  @override
  String get boxTitle => 'Flowers and sweets box';

  @override
  String get boxHomeBody => 'Flowers in one part, sweets in the other.';

  @override
  String get boxHomeCta => 'Build your box';

  @override
  String get boxType => 'Box type';

  @override
  String boxUpTo(int count) {
    return 'Up to $count';
  }

  @override
  String boxFilled(int count, int capacity) {
    return '$count of $capacity';
  }

  @override
  String get boxPiece => 'piece';

  @override
  String get boxLeadNote =>
      'Preparation takes as long as the slowest item in the box; the earliest time is worked out for you.';

  @override
  String boxSummary(String name, String total) {
    return '$name · $total';
  }

  @override
  String get cakeMessage => 'Message on the cake';

  @override
  String cakeMessageCount(int count, int max) {
    return '$count / $max';
  }

  @override
  String get cakePhoto => 'Attach a photo of the design you want';

  @override
  String get cakePhotoHint => 'Optional · JPG or PNG';

  @override
  String get cakePhotoAttached => 'Photo attached';

  @override
  String get cakePhotoRemove => 'Remove photo';

  @override
  String get cakePhotoFailed => 'The photo could not be uploaded. Try again.';

  @override
  String productAdded(String name) {
    return '$name added to the cart';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutStep1 => '1 of 2 · Delivery and time';

  @override
  String get checkoutStep2 => '2 of 2 · Payment and review';

  @override
  String get checkoutHowTitle => 'How you get it';

  @override
  String get checkoutDelivery => 'Delivery in Damascus';

  @override
  String get checkoutDeliveryHint => 'The fee depends on the area';

  @override
  String get checkoutPickup => 'Pickup at the branch';

  @override
  String get checkoutPickupFree => 'Free';

  @override
  String checkoutPickupFreeAt(String address) {
    return 'Free · $address';
  }

  @override
  String get checkoutAddressTitle => 'Delivery address';

  @override
  String get checkoutAddressChange => 'Change';

  @override
  String get checkoutAddressSet => 'Set the address on the map';

  @override
  String checkoutInZone(String fee) {
    return 'Inside the delivery area · $fee';
  }

  @override
  String get checkoutYouTitle => 'Your details';

  @override
  String get checkoutYourName => 'Your name';

  @override
  String get checkoutYourPhone => 'Your phone';

  @override
  String get checkoutRecipientTitle => 'Recipient';

  @override
  String get checkoutRecipientMe => 'It is for me';

  @override
  String get checkoutRecipientOther => 'Someone else';

  @override
  String get checkoutRecipientName => 'Recipient\'s name';

  @override
  String get checkoutRecipientPhone => 'Recipient\'s phone';

  @override
  String get checkoutHideSender => 'Do not show my name to the recipient';

  @override
  String get checkoutDayTitle => 'Delivery day';

  @override
  String get checkoutPickupDayTitle => 'Pickup day';

  @override
  String get checkoutToday => 'Today';

  @override
  String get checkoutTomorrow => 'Tomorrow';

  @override
  String get checkoutOtherDate => 'Another date';

  @override
  String checkoutUpToDays(int days) {
    return 'Up to $days days';
  }

  @override
  String get checkoutUnavailable => 'Not available';

  @override
  String checkoutTodayTooSoon(int hours) {
    return '“Today” is not available because your order needs $hours hours to prepare.';
  }

  @override
  String get checkoutDayClosed => 'The shop does not deliver on this day.';

  @override
  String get checkoutTimeTitle => 'Time';

  @override
  String checkoutSlot(String start, String end) {
    return '$start – $end';
  }

  @override
  String checkoutSlotFull(String start, String end) {
    return '$start – $end · full';
  }

  @override
  String get checkoutNoSlots =>
      'No times left on this day. Choose another day.';

  @override
  String get checkoutCallBefore => 'Call before arriving';

  @override
  String get checkoutNotes => 'Notes for the shop';

  @override
  String checkoutNotesCount(int count) {
    return '$count / 300';
  }

  @override
  String get checkoutWithDelivery => 'With delivery';

  @override
  String get checkoutToPayment => 'Continue to payment';

  @override
  String get checkoutNeedAddress => 'Set the delivery address first.';

  @override
  String get checkoutNeedSlot => 'Choose the day and the time.';

  @override
  String get checkoutNeedName => 'Write the name.';

  @override
  String get checkoutPickDate => 'Choose the date';

  @override
  String get addressTitle => 'Delivery address';

  @override
  String addressZoneBadge(String zone) {
    return 'Area: $zone';
  }

  @override
  String get addressSearch => 'Search for an area';

  @override
  String get addressNoArea => 'No delivery area with this name.';

  @override
  String addressInZone(String zone, String fee, String eta) {
    return 'This address is in the $zone delivery area · fee $fee · about $eta.';
  }

  @override
  String get addressOutOfZone => 'This point is outside our delivery areas.';

  @override
  String get addressChecking => 'Checking the area…';

  @override
  String get addressMapHint =>
      'Move the map so the pin sits on the delivery spot.';

  @override
  String get addressMapLabel =>
      'Map. The pin in the middle is the delivery spot.';

  @override
  String get addressSavedTitle => 'My addresses';

  @override
  String get addressLandmark => 'Nearest landmark';

  @override
  String get addressBuilding => 'Building';

  @override
  String get addressFloor => 'Floor';

  @override
  String get addressDetails => 'Street and other details';

  @override
  String get addressLabel => 'Address name';

  @override
  String get addressHome => 'Home';

  @override
  String get addressWork => 'Work';

  @override
  String get addressOther => 'Other';

  @override
  String get addressSave => 'Save this address for my next orders';

  @override
  String get addressConfirm => 'Confirm the address';

  @override
  String get paymentMethodTitle => 'Payment method';

  @override
  String get paymentCash => 'Cash on delivery';

  @override
  String get paymentCashHint =>
      'Cash to the driver or at the shop. The shop calls you to confirm the order.';

  @override
  String get paymentShamcash => 'Sham Cash';

  @override
  String get paymentShamcashHint =>
      'Pay in the Sham Cash app, then enter the transaction number or a receipt photo.';

  @override
  String get paymentStripe => 'International card (Stripe)';

  @override
  String get paymentStripeBadge => 'From abroad · USD';

  @override
  String get paymentStripeHint =>
      'You go to Stripe\'s secure page. We never keep your card details.';

  @override
  String get paymentSoon => 'Coming soon';

  @override
  String paymentWhenWhere(String when, String where) {
    return '$when · $where';
  }

  @override
  String get paymentPickupWhere => 'Pickup at the branch';

  @override
  String paymentRecipient(String name) {
    return 'Recipient: $name';
  }

  @override
  String paymentRecipientHidden(String name) {
    return 'Recipient: $name · sender hidden';
  }

  @override
  String get paymentInvoice => 'Invoice';

  @override
  String paymentProducts(int count) {
    return 'Products ($count)';
  }

  @override
  String paymentDeliveryZone(String zone) {
    return 'Delivery · $zone';
  }

  @override
  String get paymentTotal => 'Total';

  @override
  String paymentUsdNote(String usd) {
    return '≈ $usd · the rate is fixed when you confirm';
  }

  @override
  String get paymentWhatsapp => 'I prefer to confirm on WhatsApp';

  @override
  String get paymentWhatsappHint =>
      'We send the order number and summary to the shop';

  @override
  String get paymentTermsLead => 'By placing the order you agree to the ';

  @override
  String get paymentTermsLink => 'terms of sale and cancellation policy';

  @override
  String paymentConfirm(String total) {
    return 'Place order · $total';
  }

  @override
  String get paymentCartChanged =>
      'Something in your cart changed. Review the cart, then check out.';

  @override
  String get confirmTitle => 'We have your order';

  @override
  String get confirmNumber => 'Order number';

  @override
  String get confirmPendingShop => 'Waiting for the shop to confirm';

  @override
  String get confirmWhen => 'Time';

  @override
  String get confirmWhere => 'Address';

  @override
  String get confirmPickup => 'Pickup';

  @override
  String get confirmPayment => 'Payment';

  @override
  String get confirmNextTitle => 'What happens next?';

  @override
  String get confirmNextCash =>
      'The shop calls or messages you on WhatsApp to confirm. You are notified when it is confirmed.';

  @override
  String get confirmNextDelivery =>
      'The shop prepares your order, then sends it out on time.';

  @override
  String get confirmNextPickup =>
      'The shop prepares your order and has it ready for pickup on time.';

  @override
  String get confirmTrack => 'Track the order';

  @override
  String get confirmWhatsapp => 'Message the shop on WhatsApp';

  @override
  String get confirmContinue => 'Continue shopping';

  @override
  String get confirmGuestTitle => 'Ordered as a guest?';

  @override
  String get confirmGuestBody =>
      'Create an account with the same number to keep this order and your addresses.';

  @override
  String get confirmGuestAction => 'Create an account';

  @override
  String orderWhatsappMessage(
    String number,
    String summary,
    String total,
    String when,
  ) {
    return 'Hello, I ordered in the Belle Biens app.\nOrder number: $number\n$summary\nTotal: $total\nTime: $when\nPlease confirm the order.';
  }

  @override
  String get outZoneHeadline =>
      'This address is outside our delivery areas for now.';

  @override
  String get outZoneBody =>
      'We deliver inside Damascus, in the areas shown on the map.';

  @override
  String get outZoneWhatsapp => 'Ask the shop on WhatsApp';

  @override
  String get outZonePickup => 'Pick it up at the branch';

  @override
  String get outZoneOther => 'Choose another address';

  @override
  String outZoneMessage(String link) {
    return 'Hello, do you deliver to this address? $link';
  }

  @override
  String get shopBusyTitle => 'The shop is very busy right now';

  @override
  String shopBusyBody(String time) {
    return 'We take orders for times from $time today, or for any later day.';
  }

  @override
  String get shopClosedTitle => 'The shop is not taking orders right now';

  @override
  String get shopClosedBody =>
      'Browse and fill your cart, then order when we are back.';

  @override
  String get shamcashTitle => 'Pay with Sham Cash';

  @override
  String shamcashAmountFor(String number) {
    return 'Amount due · order $number';
  }

  @override
  String shamcashPayWithin(String time) {
    return 'Pay within $time';
  }

  @override
  String get shamcashExpired =>
      'The time to pay has passed. The order is cancelled unless a receipt arrived.';

  @override
  String get shamcashSteps => 'Steps';

  @override
  String get shamcashStep1 =>
      'Open the Sham Cash app and choose \"Transfer\" or \"Pay a merchant\".';

  @override
  String get shamcashStep2 => 'Send the amount to the shop\'s account:';

  @override
  String get shamcashNoAccount =>
      'Ask the shop for its account number on WhatsApp.';

  @override
  String get shamcashStep3 =>
      'Enter the transaction number or attach a photo of the receipt here.';

  @override
  String get shamcashCopy => 'Copy';

  @override
  String get shamcashCopied => 'Account number copied';

  @override
  String get shamcashReference => 'Transaction number';

  @override
  String get shamcashAttach => 'Attach the receipt photo';

  @override
  String get shamcashAttachHint => 'JPG or PNG · up to 5 MB';

  @override
  String get shamcashAttached => 'Receipt attached';

  @override
  String get shamcashAfter =>
      'After you send it, the shop checks the payment and confirms your order. If Sham Cash confirms automatically, the order is confirmed at once.';

  @override
  String get shamcashChangeMethod => 'Change payment method';

  @override
  String get shamcashSent => 'I have paid';

  @override
  String get shamcashNeedProof =>
      'Enter the transaction number or attach the receipt.';

  @override
  String get confirmPendingPayment => 'Waiting for the payment check';

  @override
  String get confirmNextShamcash =>
      'The shop checks your payment and confirms the order. You are notified when it is confirmed.';

  @override
  String get payFailTitle => 'We could not confirm the payment';

  @override
  String payFailBody(String time) {
    return 'The transaction does not match the amount or the account. Your order is kept for $time.';
  }

  @override
  String payFailNote(String note) {
    return 'The shop\'s note: $note';
  }

  @override
  String get payFailResend => 'Send the receipt again';

  @override
  String get payFailCash => 'Pay on delivery instead';

  @override
  String get payFailContact => 'Contact the shop';

  @override
  String orderTitle(String number) {
    return 'Order $number';
  }

  @override
  String get ordersTitle => 'My orders';

  @override
  String ordersCurrent(int count) {
    return 'Current · $count';
  }

  @override
  String ordersPast(int count) {
    return 'Past · $count';
  }

  @override
  String get ordersPastTitle => 'Past';

  @override
  String get ordersEmpty =>
      'No orders yet. When you order, you will find it here to follow.';

  @override
  String ordersPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get ordersTrack => 'Track the order';

  @override
  String get ordersAgain => 'Order again';

  @override
  String get ordersAgainDone => 'The order\'s items were added to the cart';

  @override
  String get ordersGuestTitle => 'Ordered as a guest?';

  @override
  String get ordersGuestBody =>
      'Enter the order number and the phone number you ordered with.';

  @override
  String get ordersNumber => 'Order number';

  @override
  String get ordersShow => 'Show the order';

  @override
  String get ordersNotFound => 'No order with this number and phone.';

  @override
  String get statusNew => 'Order received';

  @override
  String get statusConfirmed => 'Order confirmed';

  @override
  String get statusPreparing => 'Being prepared';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusOut => 'Out for delivery';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusPickedUp => 'Picked up';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusAwaitingShop => 'Waiting for the shop';

  @override
  String get statusAwaitingPayment => 'Waiting for payment';

  @override
  String get statusPaymentProblem => 'Payment problem';

  @override
  String get trackCurrent => 'Current status';

  @override
  String get trackAfterPayment => 'After the payment check';

  @override
  String get trackExplainNew =>
      'The shop calls or messages you on WhatsApp to confirm the order.';

  @override
  String get trackExplainSubmitted =>
      'The shop is checking the Sham Cash payment. You are notified when the order is confirmed.';

  @override
  String get trackExplainUnpaid =>
      'Finish paying with Sham Cash before the time runs out, or the order is cancelled.';

  @override
  String get trackExplainConfirmed =>
      'The shop confirmed your order and will start preparing it soon.';

  @override
  String get trackExplainPreparing => 'The shop is preparing your order now.';

  @override
  String get trackExplainReady => 'Your order is ready.';

  @override
  String get trackExplainReadyPickup =>
      'Your order is ready to pick up at the branch.';

  @override
  String get trackExplainOut => 'The driver is on the way.';

  @override
  String get trackExplainDone => 'Thank you! We hope you love it.';

  @override
  String get trackExplainCancelled => 'This order was cancelled.';

  @override
  String get trackDelivery => 'Delivery';

  @override
  String get trackPickup => 'Pickup';

  @override
  String get trackCallBefore => 'Call before arriving';

  @override
  String get trackContents => 'Contents';

  @override
  String get trackPayment => 'Payment';

  @override
  String get trackPayNow => 'Pay now with Sham Cash';

  @override
  String get trackCancel => 'Cancel the order';

  @override
  String get trackCancelHint =>
      'You can cancel here only before the order is confirmed. After that, contact the shop.';

  @override
  String trackCancelAsk(String number) {
    return 'Cancel order $number?';
  }

  @override
  String get trackCancelYes => 'Yes, cancel it';

  @override
  String get trackCancelNo => 'Keep it';

  @override
  String get trackCancelled => 'The order was cancelled';

  @override
  String get payStatePending => 'Not paid';

  @override
  String get payStateSubmitted => 'Being checked';

  @override
  String get payStatePaid => 'Paid';

  @override
  String get payStateFailed => 'Payment not matched';

  @override
  String get payStateRefunded => 'Refunded';

  @override
  String payMethodState(String method, String state) {
    return '$method · $state';
  }

  @override
  String get checkoutTodayOver =>
      'Today has no times left. Choose another day.';
}
