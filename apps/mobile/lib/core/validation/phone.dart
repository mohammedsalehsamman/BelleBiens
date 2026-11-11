import 'package:belle_biens/core/text/digits.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

final _separators = RegExp(r'[\s\-.()]');
final _digitsOnly = RegExp(r'^\+?\d+$');
final _syrianMobile = RegExp(r'^\+9639\d{8}$');

/// Normalizes a phone number to E.164, or returns null when it is not valid
/// (FR-CRT-09). Must give the same answer as the server for every case in
/// `packages/contracts/vectors/phone.json`:
/// - Arabic-Indic digits become 0-9; spaces, dashes, dots and brackets go.
/// - A leading 00 becomes +; numbers without + are read as Syrian.
/// - Syrian numbers must be mobiles: +9639 followed by 8 digits.
String? normalizePhone(String input) {
  var s = westernizeDigits(input).replaceAll(_separators, '');
  if (s.startsWith('00')) s = '+${s.substring(2)}';
  if (!_digitsOnly.hasMatch(s)) return null;

  try {
    final parsed = PhoneNumber.parse(s, callerCountry: IsoCode.SY);
    if (!parsed.isValid()) return null;
    final e164 = '+${parsed.countryCode}${parsed.nsn}';
    if (e164.startsWith('+963') && !_syrianMobile.hasMatch(e164)) return null;
    return e164;
  } on PhoneNumberException {
    return null;
  }
}
