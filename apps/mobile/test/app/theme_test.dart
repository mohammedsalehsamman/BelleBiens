import 'package:belle_biens/app/theme/bb_theme.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/core/a11y/contrast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BBTheme', () {
    final theme = BBTheme.light();

    test('uses the brand colors from DESIGN.md', () {
      expect(theme.colorScheme.primary, const Color(0xFF872341));
      expect(theme.scaffoldBackgroundColor, const Color(0xFFFFF8F6));
      expect(theme.colorScheme.onSurface, const Color(0xFF2C2422));
    });

    test('exposes the badge palette as a theme extension', () {
      expect(theme.extension<BBPalette>(), BBPalette.light);
    });

    test('primary buttons are pills at least 48 dp tall (NFR-INT-03)', () {
      final style = theme.filledButtonTheme.style!;
      final size = style.minimumSize!.resolve({})!;
      expect(size.height, greaterThanOrEqualTo(48));
      expect(style.shape!.resolve({}), isA<StadiumBorder>());
    });
  });

  group('Text contrast stays at WCAG AA, 4.5:1 or more (NFR-INT-02)', () {
    const pairs = <String, (Color, Color)>{
      'body text on canvas': (BBColors.text, BBColors.canvas),
      'muted text on canvas': (BBColors.textMuted, BBColors.canvas),
      'muted text on white': (BBColors.textMuted, BBColors.surface),
      'white on primary button': (BBColors.onPrimary, BBColors.primary),
      'price on white card': (BBColors.primary, BBColors.surface),
      'blush badge': (BBColors.onBlush, BBColors.blush),
      'sage badge': (BBColors.onSage, BBColors.sage),
      'amber badge': (BBColors.onAmber, BBColors.amber),
      'green badge': (BBColors.onGreen, BBColors.green),
      'red badge': (BBColors.onRed, BBColors.red),
      'gray badge': (BBColors.onGray, BBColors.gray),
      'white on WhatsApp button': (BBColors.onPrimary, BBColors.whatsapp),
    };

    for (final MapEntry(key: name, value: (fg, bg)) in pairs.entries) {
      test(name, () {
        expect(contrastRatio(fg, bg), greaterThanOrEqualTo(4.5));
      });
    }
  });

  test('contrastRatio matches known WCAG values', () {
    expect(
      contrastRatio(const Color(0xFF000000), const Color(0xFFFFFFFF)),
      closeTo(21, 0.01),
    );
    expect(
      contrastRatio(const Color(0xFF777777), const Color(0xFFFFFFFF)),
      closeTo(4.48, 0.01),
    );
  });
}
