import 'package:belle_biens/app/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Badge and semantic colors that Material's ColorScheme has no slot for.
@immutable
class BBPalette extends ThemeExtension<BBPalette> {
  const new({
    required this.canvas,
    required this.border,
    required this.borderStrong,
    required this.textMuted,
    required this.blush,
    required this.onBlush,
    required this.sage,
    required this.onSage,
    required this.amber,
    required this.onAmber,
    required this.green,
    required this.onGreen,
    required this.red,
    required this.onRed,
    required this.success,
    required this.whatsapp,
  });

  static const light = BBPalette(
    canvas: BBColors.canvas,
    border: BBColors.border,
    borderStrong: BBColors.borderStrong,
    textMuted: BBColors.textMuted,
    blush: BBColors.blush,
    onBlush: BBColors.onBlush,
    sage: BBColors.sage,
    onSage: BBColors.onSage,
    amber: BBColors.amber,
    onAmber: BBColors.onAmber,
    green: BBColors.green,
    onGreen: BBColors.onGreen,
    red: BBColors.red,
    onRed: BBColors.onRed,
    success: BBColors.success,
    whatsapp: BBColors.whatsapp,
  );

  final Color canvas;
  final Color border;
  final Color borderStrong;
  final Color textMuted;
  final Color blush;
  final Color onBlush;
  final Color sage;
  final Color onSage;
  final Color amber;
  final Color onAmber;
  final Color green;
  final Color onGreen;
  final Color red;
  final Color onRed;
  final Color success;
  final Color whatsapp;

  @override
  BBPalette copyWith() => this;

  @override
  BBPalette lerp(BBPalette? other, double t) => this;
}

extension BBThemeContext on BuildContext {
  BBPalette get bb => Theme.of(this).extension<BBPalette>()!;
}

abstract final class BBTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: BBColors.primary,
      onPrimary: BBColors.onPrimary,
      primaryContainer: BBColors.blush,
      onPrimaryContainer: BBColors.onBlush,
      secondary: Color(0xFF7C5357),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFFDC7CB),
      onSecondaryContainer: Color(0xFF795154),
      tertiary: Color(0xFF293628),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: BBColors.sage,
      onTertiaryContainer: BBColors.onSage,
      error: BBColors.error,
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF93000A),
      surface: BBColors.surface,
      onSurface: BBColors.text,
      onSurfaceVariant: BBColors.textVariant,
      surfaceContainerLowest: BBColors.surface,
      surfaceContainerLow: BBColors.surfaceLow,
      surfaceContainer: Color(0xFFFAEBE7),
      surfaceContainerHigh: BBColors.surfaceMuted,
      surfaceContainerHighest: BBColors.track,
      outline: BBColors.outline,
      outlineVariant: BBColors.borderStrong,
      scrim: BBColors.scrim,
      inverseSurface: Color(0xFF372E2C),
      onInverseSurface: Color(0xFFFDEDEA),
      inversePrimary: Color(0xFFFFB1C0),
    );

    const pill = StadiumBorder();
    const textTheme = TextTheme(
      headlineSmall: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.35,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.45,
      ),
      bodyLarge: TextStyle(fontSize: 15, height: 1.6),
      bodyMedium: TextStyle(fontSize: 15, height: 1.6),
      bodySmall: TextStyle(fontSize: 13, height: 1.55),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: BBFonts.sans,
      textTheme: textTheme.apply(
        bodyColor: BBColors.text,
        displayColor: BBColors.text,
      ),
      scaffoldBackgroundColor: BBColors.canvas,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: const [BBPalette.light],
      appBarTheme: const AppBarTheme(
        backgroundColor: BBColors.canvas,
        foregroundColor: BBColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: BBFonts.sans,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: BBColors.text,
        ),
        shape: Border(bottom: BorderSide(color: BBColors.border)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: BBColors.primary,
          foregroundColor: BBColors.onPrimary,
          minimumSize: const Size(BBSizes.minTouch, BBSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: pill,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BBColors.primary,
          backgroundColor: BBColors.surface,
          minimumSize: const Size(BBSizes.minTouch, BBSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          side: const BorderSide(color: BBColors.primary, width: 1.5),
          shape: pill,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: const CardThemeData(
        color: BBColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(BBRadius.card)),
          side: BorderSide(color: BBColors.border),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: BBColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: TextStyle(color: BBColors.textMuted),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(BBRadius.input)),
          borderSide: BorderSide(color: BBColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(BBRadius.input)),
          borderSide: BorderSide(color: BBColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(BBRadius.input)),
          borderSide: BorderSide(color: BBColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(BBRadius.input)),
          borderSide: BorderSide(color: BBColors.error, width: 1.5),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: BBColors.surface,
        selectedColor: BBColors.primary,
        side: BorderSide(color: BBColors.borderStrong),
        shape: StadiumBorder(),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: BBColors.text,
        ),
        secondaryLabelStyle: TextStyle(fontSize: 14, color: BBColors.onPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: BBColors.border,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
