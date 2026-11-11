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
}
