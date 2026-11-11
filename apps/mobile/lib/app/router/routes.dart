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

  /// Routes reachable before the welcome screen was seen.
  static bool isPreOnboarding(String location) =>
      location == onboarding ||
      location.startsWith('/auth/') ||
      location.startsWith('/permissions/');
}
