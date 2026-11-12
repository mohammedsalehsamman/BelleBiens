/// Route paths (plan 4.8). Screens replace placeholders sprint by sprint.
abstract final class Routes {
  // Tabs
  static const home = '/';
  static const shop = '/shop';
  static const designer = '/designer';
  static const orders = '/orders';
  static const account = '/account';

  // Sign-in (screens 01 to 05)
  static const onboarding = '/onboarding';
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const otp = '/auth/otp';
  static const completeProfile = '/auth/complete-profile';
  static const notificationPermission = '/permissions/notifications';

  // Catalog (screens 06 to 14, 32, 34)
  static const search = '/search';
  static const today = '/today';
  static const branch = '/branch';
  static const favorites = '/account/favorites';

  // Cart (screens 19, 20, 35)
  static const cart = '/cart';
  static const box = '/box';

  // Checkout (screens 21-23, 25, 36)
  static const checkout = '/checkout';
  static const checkoutAddress = '/checkout/address';
  static const checkoutPayment = '/checkout/payment';
  static const checkoutOutOfZone = '/checkout/out-of-zone';
  static String orderConfirmed(String number) => '/orders/$number/confirmed';

  static String product(String slug) => '/p/$slug';
  static String occasion(String slug) => '/occasions/$slug';
  static String page(String slug) => '/pages/$slug';

  /// Routes reachable before the welcome screen was seen.
  static bool isPreOnboarding(String location) =>
      location == onboarding ||
      location.startsWith('/auth/') ||
      location.startsWith('/permissions/');
}
