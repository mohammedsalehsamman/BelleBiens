import 'package:flutter/painting.dart';

/// Design tokens taken from `docs/design/mobile-screens/DESIGN.md` and the CSS
/// shared by the 39 HTML screens. Text colors use the darker values from the
/// screens' README so they pass WCAG AA (4.5:1) on the cream background.
abstract final class BBColors {
  // Brand
  /// Deep Velvet Bordeaux: CTAs, prices, active states.
  static const primary = Color(0xFF872341);
  static const primaryPressed = Color(0xFF6E1B32);
  static const primaryDeep = Color(0xFF68082B); // wordmark in the header
  static const onPrimary = Color(0xFFFFFFFF);

  // Surfaces
  static const canvas = Color(0xFFFFF8F6); // page background
  static const surface = Color(0xFFFFFFFF); // cards, inputs, sheets
  static const surfaceLow = Color(0xFFFFF1ED); // notices, stepper buttons
  /// Image placeholders and the segmented control track.
  static const surfaceMuted = Color(0xFFF4E5E1);
  static const track = Color(0xFFEEDFDC); // step bars, progress track
  static const previewWash = Color(0xFFFBEFEC); // designer preview background

  // Lines
  static const border = Color(0xFFEFE8E1); // hairline card borders
  static const borderStrong = Color(0xFFE2D6D0); // inputs, chips, steppers
  static const outline = Color(0xFF887175); // unselected radio and checkbox

  // Text
  static const text = Color(0xFF2C2422); // Roasted Espresso
  static const textMuted = Color(0xFF605856);
  static const textVariant = Color(0xFF554245);

  // Badges: background / foreground pairs
  static const blush = Color(0xFFFCEAEB);
  static const onBlush = Color(0xFF7A1E3A);
  static const sage = Color(0xFFE4ECE1);
  static const onSage = Color(0xFF3D5238);
  static const amber = Color(0xFFFDF3E3);
  static const onAmber = Color(0xFF7E5210);
  static const green = Color(0xFFE6F4ED);
  static const onGreen = Color(0xFF22603F);
  static const red = Color(0xFFFBE7E8);
  static const onRed = Color(0xFF8E2229);
  static const gray = Color(0xFFF0EFEB);
  static const onGray = Color(0xFF514A48);

  // Semantic
  static const success = Color(0xFF2D7A58); // timeline "done"
  static const whatsapp = Color(0xFF1F6E43);
  static const error = Color(0xFFBA1A1A);
  static const scrim = Color(0x592C2422); // rgba(44,36,34,.35)

  // Selection states
  static const optionSelected = Color(0xFFFFF5F6);
  static const toggleOff = Color(0xFFDCC0C3);

  // Notices: background, border, text (CSS .notice and its ok / warn / err)
  static const noticeInfoBg = Color(0xFFFFF1ED);
  static const noticeInfoBorder = Color(0xFFF2DCD6);
  static const noticeInfoText = Color(0xFF554245);
  static const noticeOkBg = Color(0xFFEEF6F1);
  static const noticeOkBorder = Color(0xFFCFE6D8);
  static const noticeOkText = Color(0xFF22603F);
  static const noticeWarnBg = Color(0xFFFDF6EA);
  static const noticeWarnBorder = Color(0xFFF1DDB8);
  static const noticeWarnText = Color(0xFF6B4A0F);
  static const noticeErrBg = Color(0xFFFDF0F0);
  static const noticeErrBorder = Color(0xFFF3CDCF);
  static const noticeErrText = Color(0xFF8E2229);
}

/// Shadows from DESIGN.md "Elevation & Depth".
abstract final class BBShadows {
  /// Tier 1: resting cards.
  static const card = [
    BoxShadow(
      color: Color(0x0A872341),
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  /// Tier 2: bottom bars and floating controls.
  static const bar = [
    BoxShadow(
      color: Color(0x1F2C2422),
      blurRadius: 24,
      offset: Offset(0, -8),
      spreadRadius: -12,
    ),
  ];

  /// The floating cart capsule.
  static const capsule = [
    BoxShadow(
      color: Color(0x2E2C2422),
      blurRadius: 32,
      offset: Offset(0, 12),
      spreadRadius: -4,
    ),
  ];
}

abstract final class BBRadius {
  static const sm = 4.0;
  static const md = 8.0;
  static const input = 10.0;
  static const thumb = 12.0;
  static const option = 14.0;
  static const card = 16.0;
  static const sheet = 24.0;
  static const pill = 999.0;
}

abstract final class BBSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const gutter = 12.0;
  static const md = 16.0;
  static const section = 20.0;
  static const lg = 24.0;
  static const xl = 40.0;

  /// Side margin of every screen at phone width.
  static const page = 16.0;
}

abstract final class BBSizes {
  /// NFR-INT-03: 48 dp touch targets in the app.
  static const minTouch = 48.0;
  static const buttonHeight = 48.0;
  static const iconButton = 44.0;
  static const stepperButton = 40.0;
  static const navCenter = 56.0;
}

abstract final class BBFonts {
  /// Arabic and Latin UI text. Bundled in S1 (plan 4.1); until then the
  /// platform font is used.
  static const sans = 'IBMPlexSansArabic';

  /// Latin brand and editorial headlines.
  static const serif = 'PlayfairDisplay';
}
