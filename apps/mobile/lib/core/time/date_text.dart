import 'package:belle_biens/core/text/digits.dart';
import 'package:intl/intl.dart' show DateFormat;

/// The Levantine month names the screens use ("11 تشرين الثاني",
/// FR-LOC-03). intl's Arabic gives the Egyptian names and Arabic-Indic
/// digits, which are not how the shop writes dates.
const _levantineMonths = [
  'كانون الثاني',
  'شباط',
  'آذار',
  'نيسان',
  'أيار',
  'حزيران',
  'تموز',
  'آب',
  'أيلول',
  'تشرين الأول',
  'تشرين الثاني',
  'كانون الأول',
];

/// "11 تشرين الثاني" or "November 11" for a YYYY-MM-DD date, with the
/// customer's digits (FR-LOC-02).
String dayMonthText(
  String language,
  String date, {
  Numerals numerals = Numerals.western,
}) {
  final day = DateTime.parse(date);
  if (language == 'en') return DateFormat.MMMMd('en').format(day);
  return localizeDigits(
    '${day.day} ${_levantineMonths[day.month - 1]}',
    numerals,
  );
}
