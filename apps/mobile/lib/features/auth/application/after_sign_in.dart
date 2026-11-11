import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';

/// Where to go once signed in: finish the profile first (name and terms),
/// then ask about notifications once (screen 05), then home.
String routeAfterSignIn(MeDto user, AppPreferences prefs) {
  if (!user.profileComplete) return Routes.completeProfile;
  if (!prefs.notificationsAsked) return Routes.notificationPermission;
  return Routes.home;
}
