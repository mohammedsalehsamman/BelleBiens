import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cart_fixtures.dart';
import '../../helpers/fake_checkout.dart';
import '../../helpers/test_app.dart';

/// Screen 25 lays out at 360 dp in both languages, at x1 and x2 text, for a
/// delivery and a pickup (NFR-INT-04).
void main() {
  for (final language in ['ar', 'en']) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('order received fits 360 dp ($language, text x$scale)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 2400);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final t = await pumpTestApp(tester, language: language);
        final router = t.container.read(routerProvider);
        for (final pickup in [false, true]) {
          final order = OrderDto.fromJson(
            fakeOrder({
              'lines': [for (final l in readmeCart) l.toJson()],
              'fulfillment': pickup ? 'PICKUP' : 'DELIVERY',
              'customer': {'name': 'سارة', 'phone': '+963944123456'},
              if (!pickup)
                'address': {
                  'latitude': 33.5155,
                  'longitude': 36.284,
                  'label': 'البيت',
                },
              'slot': {'date': '2026-11-12', 'start': '18:00'},
              'paymentMethod': 'CASH',
            }),
          );
          router.go(Routes.orderConfirmed(order.number), extra: order);
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(
            find.text(language == 'ar' ? 'استلمنا طلبك' : 'We have your order'),
            findsOneWidget,
          );
        }
      });
    }
  }
}
