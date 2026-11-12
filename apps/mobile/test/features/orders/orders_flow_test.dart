import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:belle_biens/features/checkout/data/checkout_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cart_fixtures.dart';
import '../../helpers/fake_checkout.dart';
import '../../helpers/test_app.dart';

void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pumpAndSettle();
}

void _testOrders(String name, Future<void> Function(WidgetTester) body) =>
    testWidgets(name, (tester) async {
      await body(tester);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

/// A guest order already placed on this phone, as checkout leaves it.
Map<String, Object?> _place(
  FixtureServer server,
  MemoryJsonCache cache, {
  String payment = 'CASH',
  bool pickup = true,
}) {
  final order = fakeOrder({
    'lines': [for (final l in readmeCart) l.toJson()],
    'fulfillment': pickup ? 'PICKUP' : 'DELIVERY',
    'customer': {'name': 'سارة', 'phone': '0944123456'},
    'slot': {'date': '2026-11-12', 'start': '18:00'},
    'paymentMethod': payment,
  });
  server.placed['key-${order['number']}'] = order;
  cache.entries[CheckoutRepository.guestOrdersKey] = CacheEntry(
    json: [
      {'number': order['number'], 'phone': '0944123456'},
    ],
    savedAt: DateTime.utc(2026, 11, 11, 12),
  );
  return order;
}

FixtureServer _withShamcashAccount() =>
    FixtureServer()
      ..overrides['/v1/app/config'] = (_) {
        final c = (FixtureServer.fixture('app_config')! as Map)
            .cast<String, Object?>();
        return (
          200,
          {
            ...c,
            'payments': {
              ...(c['payments']! as Map).cast<String, Object?>(),
              'shamcashAccount': '0991234567',
            },
          },
        );
      };

void main() {
  _testOrders('UC-02: pay with Sham Cash, send the receipt, wait for the '
      'shop (screens 23, 24, 25)', (tester) async {
    _tall(tester);
    final server = _withShamcashAccount();
    final t = await pumpTestApp(
      tester,
      cache: cacheWithCart(readmeCart),
      server: server,
    );
    final router = t.container.read(routerProvider);
    t.container.read(checkoutControllerProvider.notifier)
      ..fulfillment(Fulfillment.pickup)
      ..edit(
        (d) => d.copyWith(
          customerName: 'سارة',
          customerPhone: '0944123456',
          recipientIsMe: true,
        ),
      )
      ..day('2026-11-12')
      ..slot('18:00', '20:00');
    router.push('/checkout/payment').ignore();
    await _settle(tester);
    await tapText(tester, 'شام كاش');
    await tapText(tester, 'تأكيد الطلب · \u20687,116 ل.س\u2069');
    await _settle(tester);

    // Screen 24.
    expect(find.text('الدفع بشام كاش'), findsOneWidget);
    expect(find.text('المبلغ المطلوب · طلب رقم BB-1001'), findsOneWidget);
    expect(find.text('7,116 ل.س'), findsOneWidget);
    expect(find.text('أكمل الدفع خلال 01:55:00'), findsOneWidget);
    expect(find.text('0991234567'), findsOneWidget);
    expect(
      (server.to('/v1/orders').single.data as Map)['paymentMethod'],
      'SHAMCASH',
    );
    expect(t.container.read(cartControllerProvider).value, isEmpty);

    await tapText(tester, 'أرسلت الدفعة');
    expect(find.text('اكتب رقم العملية أو أرفق صورة الإيصال.'), findsOneWidget);

    await tester.enterText(fieldBelow('رقم العملية'), '784512');
    await tapText(tester, 'أرفق صورة الإيصال');
    expect(find.text('أُرفق الإيصال'), findsOneWidget);
    await tapText(tester, 'أرسلت الدفعة');
    await _settle(tester);

    final proof =
        server.to('/v1/orders/BB-1001/payment/proof').single.data as Map;
    expect(proof, {
      'phone': '0944123456',
      'reference': '784512',
      'receiptUrl': 'https://media.test/receipts/test.webp',
    });
    // Screen 25 for Sham Cash.
    expect(find.text('استلمنا طلبك'), findsOneWidget);
    expect(find.text('بانتظار التحقق من الدفع'), findsOneWidget);
    expect(
      find.text('يتحقق المحل من دفعتك ويؤكد الطلب. يصلك إشعار عند التأكيد.'),
      findsOneWidget,
    );
  });

  _testOrders('track a guest order, then cancel it before the shop confirms '
      '(screen 27, FR-ORD-04/05)', (tester) async {
    _tall(tester);
    final server = FixtureServer();
    final cache = MemoryJsonCache();
    _place(server, cache);
    final t = await pumpTestApp(tester, server: server, cache: cache);
    t.container.read(routerProvider).push('/orders/BB-1001').ignore();
    await _settle(tester);

    expect(find.text('طلب BB-1001'), findsOneWidget);
    expect(find.text('بانتظار تأكيد المحل'), findsOneWidget);
    expect(find.text('تم استلام الطلب'), findsOneWidget);
    expect(find.text('11 تشرين الثاني · 15:00'), findsOneWidget);
    expect(find.text('غداً 18:00 – 20:00'), findsOneWidget);
    expect(find.text('الدفع عند الاستلام · غير مدفوع'), findsOneWidget);
    // Pickup orders are never "out for delivery".
    expect(find.text('خرج للتوصيل'), findsNothing);
    expect(find.text('تم الاستلام'), findsOneWidget);
    final lookup = server.to('/v1/orders/lookup').last.data as Map;
    expect(lookup, {'number': 'BB-1001', 'phone': '0944123456'});

    await tapText(tester, 'إلغاء الطلب');
    expect(find.text('هل تريد إلغاء الطلب BB-1001؟'), findsOneWidget);
    await tapText(tester, 'نعم، ألغِ الطلب');
    await _settle(tester);
    expect(
      (server.to('/v1/orders/BB-1001/cancel').single.data as Map)['phone'],
      '0944123456',
    );
    expect(find.text('أُلغي هذا الطلب.'), findsOneWidget);
    expect(find.text('إلغاء الطلب'), findsNothing);
  });

  _testOrders('a payment the shop could not match: its note, the time left, '
      'and cash instead (screen 38)', (tester) async {
    _tall(tester);
    final server = FixtureServer();
    final cache = MemoryJsonCache();
    _place(server, cache, payment: 'SHAMCASH')
      ..['paymentStatus'] = 'FAILED'
      ..['paymentNote'] = 'رقم العملية لا يطابق المبلغ';
    final t = await pumpTestApp(tester, server: server, cache: cache);
    t.container.read(routerProvider).push('/orders/BB-1001').ignore();
    await _settle(tester);

    expect(find.text('لم نتمكن من تأكيد الدفعة'), findsOneWidget);
    expect(
      find.text(
        'رقم العملية لا يطابق المبلغ أو الحساب. طلبك محفوظ لمدة 01:55:00.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('ملاحظة المحل: رقم العملية لا يطابق المبلغ'),
      findsOneWidget,
    );
    expect(find.text('مشكلة في الدفع'), findsOneWidget);

    await tapText(tester, 'الدفع عند الاستلام بدلاً من ذلك');
    await _settle(tester);
    expect(server.to('/v1/orders/BB-1001/payment/cash'), hasLength(1));
    expect(find.text('لم نتمكن من تأكيد الدفعة'), findsNothing);
    expect(find.text('بانتظار تأكيد المحل'), findsOneWidget);
  });

  _testOrders('a signed-in customer: current and past orders, and order '
      'again (screen 26, FR-ORD-07)', (tester) async {
    _tall(tester);
    final server = FixtureServer();
    final past = fakeOrder({
      'lines': [readmeCart[1].toJson()],
      'fulfillment': 'PICKUP',
      'customer': {'name': 'سارة', 'phone': '+963944123456'},
      'slot': {'date': '2026-11-02', 'start': '18:00'},
      'paymentMethod': 'CASH',
    }, number: 1000)..['status'] = 'DELIVERED';
    server.placed['past'] = past;
    final current = fakeOrder({
      'lines': [for (final l in readmeCart) l.toJson()],
      'fulfillment': 'PICKUP',
      'customer': {'name': 'سارة', 'phone': '+963944123456'},
      'slot': {'date': '2026-11-12', 'start': '12:00'},
      'paymentMethod': 'SHAMCASH',
    })..['paymentStatus'] = 'SUBMITTED';
    server.placed['current'] = current;
    Map<String, Object?> summary(Map<String, Object?> o) => {
      'number': o['number'],
      'status': o['status'],
      'fulfillment': o['fulfillment'],
      'createdAt': o['createdAt'],
      'slot': o['slot'],
      'totalMinor': (o['syp']! as Map)['totalMinor'],
      'itemCount': (o['lines']! as List).fold<int>(
        0,
        (s, l) => s + ((l as Map)['qty']! as int),
      ),
      'paymentStatus': o['paymentStatus'],
      'paymentMethod': o['paymentMethod'],
      'title': ((o['lines']! as List).first as Map)['title'],
    };
    server.overrides['/v1/me/orders'] = (_) =>
        (200, [summary(current), summary(past)]);

    final t = await pumpTestApp(
      tester,
      server: server,
      storedSession: Session.fromAuth(testSession()).toJson(),
    );
    t.container.read(routerProvider).go('/orders');
    await _settle(tester);

    expect(find.text('الحالية · 1'), findsOneWidget);
    expect(find.text('السابقة · 1'), findsOneWidget);
    expect(find.text('بانتظار التحقق من الدفع'), findsOneWidget);
    expect(find.text('4 قطع · غداً 12:00 – 14:00'), findsOneWidget);
    expect(find.text('7,116 ل.س'), findsOneWidget);
    expect(find.text('تم التسليم'), findsOneWidget);
    expect(find.text('طلبت كضيف؟'), findsNothing);

    await tapText(tester, 'اطلب مجدداً');
    await _settle(tester);
    final lines = t.container.read(cartControllerProvider).value!;
    expect(lines, hasLength(1));
    expect(lines.single.product!.slug, 'iced-rose-matcha-latte');
    expect(lines.single.qty, 2);
    expect(find.text('أُضيفت محتويات الطلب إلى السلة'), findsOneWidget);
  });

  _testOrders('a guest finds an order by number and phone (screen 26)', (
    tester,
  ) async {
    _tall(tester);
    final server = FixtureServer();
    final cache = MemoryJsonCache();
    _place(server, cache);
    cache.entries.remove(CheckoutRepository.guestOrdersKey);
    final t = await pumpTestApp(tester, server: server, cache: cache);
    t.container.read(routerProvider).go('/orders');
    await _settle(tester);
    expect(
      find.text('لا طلبات بعد. حين تطلب، تجد طلبك هنا لتتابعه.'),
      findsOneWidget,
    );

    await tester.enterText(fieldBelow('رقم الطلب'), 'bb-2');
    await tester.enterText(fieldBelow('رقم الهاتف'), '0944123456');
    await tapText(tester, 'عرض الطلب');
    expect(find.text('لم نجد طلباً بهذا الرقم والهاتف.'), findsOneWidget);

    await tester.enterText(fieldBelow('رقم الطلب'), 'bb-1001');
    await tapText(tester, 'عرض الطلب');
    await _settle(tester);
    expect(find.text('طلب BB-1001'), findsOneWidget);
    final guest = await t.container
        .read(checkoutRepositoryProvider)
        .guestOrders();
    expect(guest.single.number, 'BB-1001');
  });

  for (final language in ['ar', 'en']) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('order screens fit 360 dp ($language, text x$scale)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 4000);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final server = _withShamcashAccount();
        final cache = MemoryJsonCache();
        final order = _place(server, cache, payment: 'SHAMCASH', pickup: false);
        final t = await pumpTestApp(
          tester,
          language: language,
          server: server,
          cache: cache,
        );
        final router = t.container.read(routerProvider);
        for (final failed in [false, true]) {
          if (failed) {
            order
              ..['paymentStatus'] = 'FAILED'
              ..['paymentNote'] = 'رقم العملية لا يطابق المبلغ';
          }
          for (final route in [
            '/orders',
            '/orders/BB-1001',
            '/orders/BB-1001/pay',
          ]) {
            router.go(route);
            await _settle(tester);
            expect(
              tester.takeException(),
              isNull,
              reason: '$route ($language, x$scale, failed $failed)',
            );
          }
        }
        // Leave the tracking screen, so its refresh timer stops.
        router.go('/');
        await _settle(tester);
        await tester.pump(const Duration(seconds: 1));
      });
    }
  }
}
