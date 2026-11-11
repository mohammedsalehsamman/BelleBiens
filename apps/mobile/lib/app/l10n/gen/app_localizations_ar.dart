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
}
