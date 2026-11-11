import 'package:belle_biens/app/router/router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

/// Every catalog screen must lay out at 360 dp wide, in both languages, at
/// normal and at double text size, with no overflow or layout error
/// (NFR-INT-04, plan 5.1). The window is tall so whole pages get laid out,
/// not just the first screenful.
const _routes = [
  '/',
  '/shop',
  '/search',
  '/today',
  '/occasions/birthday',
  '/p/red-rose-bouquet',
  '/p/rose-pistachio-cake',
  '/p/iced-rose-matcha-latte',
  '/branch',
  '/pages/delivery',
  '/account/favorites',
];

void main() {
  for (final language in ['ar', 'en']) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('catalog screens fit 360 dp ($language, text x$scale)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 4000);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final t = await pumpTestApp(tester, language: language);
        final router = t.container.read(routerProvider);
        for (final route in _routes) {
          router.go(route);
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '$route ($language, x$scale)',
          );
        }
        // Each page really loaded its data, so the sweep measured content.
        for (final path in [
          '/v1/home',
          '/v1/products',
          '/v1/daily-flowers',
          '/v1/occasions/birthday',
          '/v1/products/red-rose-bouquet',
          '/v1/products/rose-pistachio-cake',
          '/v1/products/iced-rose-matcha-latte',
          '/v1/branch',
          '/v1/pages/delivery',
        ]) {
          expect(t.server.to(path), isNotEmpty, reason: path);
        }
      });
    }
  }
}
