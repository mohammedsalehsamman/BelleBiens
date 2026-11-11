import 'package:belle_biens/app/theme/tokens.dart';
import 'package:flutter/painting.dart';

/// Text styles from the screens' CSS (.h1, .h2, .h3, body, .small, .xs and
/// .price).
/// IBM Plex Sans Arabic for everything; Playfair Display only for the Latin
/// wordmark and editorial lines (DESIGN.md "Typography").
abstract final class BBText {
  static const String _sans = BBFonts.sans;
  static const _tabular = [FontFeature.tabularFigures()];

  static const h1 = TextStyle(
    fontFamily: _sans,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: BBColors.text,
  );
  static const h2 = TextStyle(
    fontFamily: _sans,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: BBColors.text,
  );
  static const h3 = TextStyle(
    fontFamily: _sans,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: BBColors.text,
  );
  static const body = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    height: 1.6,
    color: BBColors.text,
  );
  static const bodyBold = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.6,
    color: BBColors.text,
  );
  static const small = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    height: 1.55,
    color: BBColors.text,
  );
  static const xs = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    height: 1.5,
    color: BBColors.text,
  );
  static const label = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: BBColors.text,
  );
  static const button = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Prices: bold Bordeaux with digits of equal width.
  static const price = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: BBColors.primary,
    fontFeatures: _tabular,
  );

  /// Numbers in tables, counters and timers.
  static const numeric = TextStyle(fontFeatures: _tabular);

  /// "Belle Biens" in the header and on the welcome screen.
  static const wordmark = TextStyle(
    fontFamily: BBFonts.serif,
    fontSize: 24,
    height: 1.25,
    color: BBColors.primaryDeep,
    fontVariations: [FontVariation('wght', 600)],
  );

  /// "BELLE BIENS · DAMASCUS" on the welcome screen.
  static const eyebrow = TextStyle(
    fontFamily: BBFonts.serif,
    fontSize: 15,
    letterSpacing: 1.8,
    color: BBColors.primary,
    fontVariations: [FontVariation('wght', 500)],
  );
}

extension BBTextStyleX on TextStyle {
  TextStyle get muted => copyWith(color: BBColors.textMuted);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w600);
  TextStyle withColor(Color color) => copyWith(color: color);
}
