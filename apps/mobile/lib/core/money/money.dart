import 'package:belle_biens/core/text/digits.dart';
import 'package:intl/intl.dart';

/// Which currency the customer reads first (the ل.س / $ switch on screens 06
/// and 07). Prices are always SYP on the server (ADR 0011); dollars are shown
/// converted with the shop's rate (FR-PAY-05).
enum DisplayCurrency { syp, usd }

/// Converts SYP minor units (1/100 pound) to US cents with the shop's rate
/// ("SYP per 1 USD", a decimal string), rounding half up, exactly as the
/// server does (contracts/vectors/pricing.json). Integer maths only.
int sypMinorToUsdCents(int sypMinor, String usdRate) {
  final rate = usdRate.trim();
  final dot = rate.indexOf('.');
  final decimals = dot < 0 ? 0 : rate.length - dot - 1;
  final scaledRate = BigInt.parse(rate.replaceFirst('.', ''));
  if (scaledRate <= BigInt.zero) {
    throw ArgumentError.value(usdRate, 'usdRate', 'must be positive');
  }
  // cents = sypMinor / rate, with rate = scaledRate / 10^decimals.
  final numerator = BigInt.from(sypMinor) * BigInt.from(10).pow(decimals);
  final negative = numerator.isNegative;
  final abs = numerator.abs();
  var cents = abs ~/ scaledRate;
  if ((abs % scaledRate) * BigInt.two >= scaledRate) cents += BigInt.one;
  return (negative ? -cents : cents).toInt();
}

/// Formats prices for display (FR-LOC-02: Western digits by default,
/// Arabic-Indic as a setting). Amounts are grouped "2,400" as in the screens.
class MoneyFormat {
  const new({
    required this.usdRate,
    this.numerals = Numerals.western,
    this.currency = DisplayCurrency.syp,
    this.sypSymbol = 'ل.س',
  });

  final String usdRate;
  final Numerals numerals;
  final DisplayCurrency currency;

  /// "ل.س" in Arabic, "SYP" in English.
  final String sypSymbol;

  static final _whole = NumberFormat('#,##0', 'en');
  static final _cents = NumberFormat('#,##0.00', 'en');

  String _digits(String text) => localizeDigits(text, numerals);

  /// "2,400 ل.س". Fractions of a pound show only when there are any.
  String syp(int minor) {
    final amount = minor % 100 == 0
        ? _whole.format(minor ~/ 100)
        : _cents.format(minor / 100);
    return _digits('$amount $sypSymbol');
  }

  /// "$20.00", converted from SYP minor units.
  String usd(int sypMinor) => _digits(
    '\$${_cents.format(sypMinorToUsdCents(sypMinor, usdRate) / 100)}',
  );

  /// The amount in the chosen currency.
  String primary(int sypMinor) =>
      currency == DisplayCurrency.syp ? syp(sypMinor) : usd(sypMinor);

  /// The other currency, shown smaller beside the price.
  String secondary(int sypMinor) =>
      currency == DisplayCurrency.syp ? usd(sypMinor) : syp(sypMinor);

  /// A price change such as "+120", kept left-to-right inside Arabic text
  /// (U+2066..U+2069 isolate, so it never reads "120+").
  String change(int sypMinor) {
    final sign = sypMinor < 0 ? '\u2212' : '+';
    final abs = sypMinor.abs();
    final amount = currency == DisplayCurrency.syp
        ? (abs % 100 == 0
              ? _whole.format(abs ~/ 100)
              : _cents.format(abs / 100))
        : '\$${_cents.format(sypMinorToUsdCents(abs, usdRate) / 100)}';
    return '\u2066${_digits('$sign$amount')}\u2069';
  }

  /// A plain count, "120", in the customer's digits.
  String count(int value) => _digits(_whole.format(value));
}
