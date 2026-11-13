import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:belle_biens/features/checkout/domain/checkout_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cart_fixtures.dart';
import '../../helpers/fake_checkout.dart';
import '../../helpers/test_app.dart';

const _fsi = '\u2068';
const _pdi = '\u2069';

void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Lets the 400 ms quote debounce and the map's zone check run.
Future<void> _settle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pumpAndSettle();
}

/// The README cart on the phone, opened at checkout (screen 21).
Future<TestHarness> _openCheckout(
  WidgetTester tester, {
  FixtureServer? server,
  String? storedSession,
}) async {
  _tall(tester);
  final t = await pumpTestApp(
    tester,
    cache: cacheWithCart(readmeCart),
    server: server,
    storedSession: storedSession,
  );
  final router = t.container.read(routerProvider);
  router.push('/cart').ignore();
  await _settle(tester);
  await tapText(tester, 'متابعة للتوصيل');
  await _settle(tester);
  return t;
}

Future<void> _type(WidgetTester tester, String label, String text) async {
  final field = fieldBelow(label);
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await tester.pump();
}

/// Screen 22 with the map left on the branch, in Abu Rummaneh.
Future<void> _setAddress(WidgetTester tester) async {
  await tapText(tester, 'حدّد العنوان على الخريطة');
  await _settle(tester);
  await _type(tester, 'أقرب معلم', 'قرب حديقة الجاحظ');
  await _type(tester, 'الطابق', '3');
  await tapText(tester, 'تأكيد العنوان');
  await _settle(tester);
}

Future<void> _fillPeople(WidgetTester tester) async {
  await _type(tester, 'اسمك', 'سارة');
  await _type(tester, 'رقم هاتفك', '0944123456');
  await _type(tester, 'اسم المستلم', 'لين');
  await _type(tester, 'رقم هاتف المستلم', '0933765432');
}

void _testCheckout(String name, Future<void> Function(WidgetTester) body) =>
    testWidgets(name, (tester) async {
      await body(tester);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

FixtureServer _withWhatsapp() => FixtureServer()
  ..overrides['/v1/branch'] = (_) => (
    200,
    {
      ...(FixtureServer.fixture('branch')! as Map).cast<String, Object?>(),
      'whatsapp': '+963944000000',
    },
  );

void main() {
  _testCheckout('UC-01: the README order by a guest, cash on delivery, '
      'tomorrow 18:00 to Abu Rummaneh (screens 21, 22, 23, 25)', (
    tester,
  ) async {
    final t = await _openCheckout(tester);
    expect(find.text('1 من 2 · التوصيل والموعد'), findsOneWidget);

    // FR-DLV-05: the cake needs 24 hours, so today is out and tomorrow's
    // early slots too; tomorrow 16:00 is full (screen 21).
    expect(find.text('غير متاح'), findsOneWidget);
    expect(
      find.text('«اليوم» غير متاح لأن طلبك يحتاج 24 ساعة للتجهيز.'),
      findsOneWidget,
    );
    expect(find.text('12:00 – 14:00'), findsNothing);
    expect(find.text('16:00 – 18:00 · ممتلئ'), findsOneWidget);
    expect(find.text('18:00 – 20:00'), findsOneWidget);

    await _setAddress(tester);
    expect(find.text('البيت · أبو رمانة'), findsOneWidget);
    expect(find.text('3، قرب حديقة الجاحظ'), findsOneWidget);
    expect(
      find.text('داخل منطقة التوصيل · ${_fsi}150 ل.س$_pdi'),
      findsOneWidget,
    );

    await _fillPeople(tester);
    await tapText(tester, 'لا تُظهر اسمي للمستلم');
    await tapText(tester, '18:00 – 20:00');
    await tapText(tester, 'اتصل قبل الوصول');
    await _settle(tester);
    expect(find.text('مع التوصيل'), findsOneWidget);
    expect(find.text('7,266 ل.س'), findsOneWidget);

    await tapText(tester, 'متابعة للدفع');
    await _settle(tester);
    expect(t.server.to('/v1/delivery/slot-holds'), hasLength(1));

    // Screen 23: the invoice with the zone fee, priced by the server.
    expect(find.text('2 من 2 · الدفع والمراجعة'), findsOneWidget);
    expect(find.text('المنتجات (4)'), findsOneWidget);
    expect(find.text('7,116 ل.س'), findsOneWidget);
    expect(find.text('التوصيل · أبو رمانة'), findsOneWidget);
    expect(find.text('150 ل.س'), findsOneWidget);
    expect(find.text('7,266 ل.س'), findsOneWidget);
    expect(
      find.text(r'≈ $60.55 · سعر الصرف يُثبّت عند تأكيد الطلب'),
      findsOneWidget,
    );
    expect(find.text('غداً 18:00 – 20:00 · البيت · أبو رمانة'), findsOneWidget);
    expect(find.text('المستلم: لين · بدون إظهار المرسل'), findsOneWidget);
    // Sham Cash is offered (S6); Stripe is off in the shop's settings.
    expect(find.text('شام كاش'), findsOneWidget);
    expect(find.text('قريباً'), findsNothing);
    final quote = t.server.to('/v1/cart/quote').last.data as Map;
    expect(quote['zone'], 'abu-rummaneh');

    await tapText(tester, 'تأكيد الطلب · ${_fsi}7,266 ل.س$_pdi');
    await _settle(tester);

    // Screen 25.
    expect(find.text('استلمنا طلبك'), findsOneWidget);
    expect(find.textContaining('BB-1001', findRichText: true), findsOneWidget);
    expect(find.text('بانتظار تأكيد المحل'), findsOneWidget);
    expect(find.text('غداً 18:00 – 20:00'), findsOneWidget);
    expect(find.text('الدفع عند الاستلام'), findsOneWidget);
    expect(find.text('طلبت كضيف؟'), findsOneWidget);

    // What the server was sent: choices only, never a price (NFR-SEC-06).
    final sent = t.server.to('/v1/orders').single;
    expect(sent.headers['Idempotency-Key'], hasLength(32));
    final body = sent.data as Map;
    expect(body, isNot(contains('totalMinor')));
    expect(body['fulfillment'], 'DELIVERY');
    expect(body['customer'], {'name': 'سارة', 'phone': '0944123456'});
    expect(body['recipient'], {'name': 'لين', 'phone': '0933765432'});
    expect(body['hideSender'], isTrue);
    expect(body['callBeforeArrival'], isTrue);
    expect(body['slot'], {'date': '2026-11-12', 'start': '18:00'});
    expect(body['slotHoldId'], isNotNull);
    expect(body['paymentMethod'], 'CASH');
    expect((body['address'] as Map)['landmark'], 'قرب حديقة الجاحظ');
    expect(body['lines'] as List, hasLength(3));

    // The cart is empty; the guest's order is kept on the phone (FR-ORD-04).
    expect(t.container.read(cartControllerProvider).value, isEmpty);
    final guest = await t.container
        .read(checkoutRepositoryProvider)
        .guestOrders();
    expect(guest.single, (number: 'BB-1001', phone: '0944123456'));
  });

  _testCheckout('a lost answer is retried with the same key, so the order '
      'is placed once (FR-CRT-10)', (tester) async {
    final t = await _openCheckout(tester);
    t.container
        .read(checkoutControllerProvider.notifier)
        .fulfillment(Fulfillment.pickup);
    await _settle(tester);
    await _fillPeople(tester);
    await tapText(tester, 'أنا المستلم');
    await tapText(tester, '18:00 – 20:00');
    await tapText(tester, 'متابعة للدفع');
    await _settle(tester);

    t.server.offline = true;
    await tapText(tester, 'تأكيد الطلب · ${_fsi}7,116 ل.س$_pdi');
    await _settle(tester);
    expect(find.text('استلمنا طلبك'), findsNothing);
    expect(t.container.read(cartControllerProvider).value, hasLength(3));

    t.server.offline = false;
    await tapText(tester, 'تأكيد الطلب · ${_fsi}7,116 ل.س$_pdi');
    await _settle(tester);
    expect(find.text('استلمنا طلبك'), findsOneWidget);
    final keys = t.server
        .to('/v1/orders')
        .map((r) => r.headers['Idempotency-Key'])
        .toSet();
    expect(keys, hasLength(1));
    expect(t.server.placed, hasLength(1));
    // Pickup: no slot hold, no address, no fee.
    final body = t.server.to('/v1/orders').last.data as Map;
    expect(body['fulfillment'], 'PICKUP');
    expect(body, isNot(contains('address')));
    expect(body, isNot(contains('recipient')));
    expect(t.server.to('/v1/delivery/slot-holds'), isEmpty);
  });

  _testCheckout('outside the zones: WhatsApp the shop, or pick it up '
      '(screen 36, FR-DLV-01)', (tester) async {
    final t = await _openCheckout(tester, server: _withWhatsapp());
    t.container
        .read(checkoutControllerProvider.notifier)
        .address(const DraftAddress(latitude: 33.42, longitude: 36.2));
    await _settle(tester);
    expect(find.text('هذه النقطة خارج مناطق التوصيل.'), findsOneWidget);
    await _fillPeople(tester);
    await tapText(tester, '18:00 – 20:00');
    await tapText(tester, 'متابعة للدفع');
    await _settle(tester);

    expect(
      find.text(
        'هذا العنوان خارج مناطق التوصيل حالياً. نوصل داخل دمشق فقط في '
        'المناطق المحددة.',
      ),
      findsOneWidget,
    );
    await tapText(tester, 'اسأل المحل على واتساب');
    final link = t.links.opened.single;
    expect(link.host, 'wa.me');
    expect(link.queryParameters['text'], contains('openstreetmap.org'));

    await tapText(tester, 'استلم من الفرع');
    await _settle(tester);
    expect(
      t.container.read(checkoutControllerProvider).fulfillment,
      Fulfillment.pickup,
    );
    expect(find.text('يوم الاستلام'), findsOneWidget);
  });

  _testCheckout('the slot filled meanwhile: back to choose another '
      '(FR-DLV-04)', (tester) async {
    final server = FixtureServer();
    server.overrides['/v1/orders'] = (_) => (
      409,
      {
        'type': 'https://errors.bellebiens.local/SLOT_FULL',
        'title': 'هذا الموعد امتلأ. اختر موعداً آخر.',
        'status': 409,
        'code': 'SLOT_FULL',
      },
    );
    await _openCheckout(tester, server: server);
    await _setAddress(tester);
    await _fillPeople(tester);
    await tapText(tester, '20:00 – 22:00');
    await tapText(tester, 'متابعة للدفع');
    await _settle(tester);
    await tapText(tester, 'تأكيد الطلب · ${_fsi}7,266 ل.س$_pdi');
    await _settle(tester);
    expect(find.text('هذا الموعد امتلأ. اختر موعداً آخر.'), findsOneWidget);
    expect(find.text('1 من 2 · التوصيل والموعد'), findsOneWidget);
  });

  _testCheckout('fields are checked before payment (FR-CRT-09)', (
    tester,
  ) async {
    await _openCheckout(tester);
    await tapText(tester, 'متابعة للدفع');
    expect(find.text('حدّد عنوان التوصيل أولاً.'), findsOneWidget);
    await _setAddress(tester);
    await _type(tester, 'رقم هاتفك', '12345');
    await tapText(tester, 'متابعة للدفع');
    await _settle(tester);
    expect(find.textContaining('رقم الهاتف غير صحيح'), findsWidgets);
    expect(find.text('اكتب الاسم.'), findsWidgets);
    expect(find.text('2 من 2 · الدفع والمراجعة'), findsNothing);
  });

  _testCheckout('a signed-in customer: name and phone filled, saved '
      'addresses, and "save this address" (FR-ACC-04)', (tester) async {
    final server = FixtureServer()
      ..savedAddresses = [
        {
          'id': '5d1f0c3e-0000-4000-8000-000000000010',
          'label': 'العمل',
          'latitude': 33.5155,
          'longitude': 36.284,
          'area': '',
          'landmark': 'قرب المكتبة',
          'building': '7',
          'floor': '2',
          'details': '',
          'isDefault': true,
          'callBeforeArrival': false,
          'zone': zoneOf('abu-rummaneh'),
        },
      ];
    final t = await _openCheckout(
      tester,
      server: server,
      storedSession: Session.fromAuth(testSession()).toJson(),
    );
    expect(
      t.container.read(checkoutControllerProvider).customerPhone,
      '+963944123456',
    );
    await tapText(tester, 'حدّد العنوان على الخريطة');
    await _settle(tester);
    expect(find.text('احفظ العنوان لطلباتي القادمة'), findsOneWidget);
    await tapText(tester, 'العمل · أبو رمانة');
    await _settle(tester);
    expect(find.text('قرب المكتبة'), findsOneWidget);
    await tapText(tester, 'تأكيد العنوان');
    await _settle(tester);
    expect(find.text('العمل · أبو رمانة'), findsOneWidget);
  });

  _testCheckout('late in the evening with nothing to prepare: today is '
      'simply over', (tester) async {
    final server = FixtureServer();
    server.overrides['/v1/delivery/dates'] = (_) {
      final calendar = fakeCalendar(0);
      ((calendar['days']! as List).first as Map)
        ..['available'] = false
        ..['problem'] = 'TOO_SOON';
      return (200, calendar);
    };
    _tall(tester);
    final t = await pumpTestApp(
      tester,
      cache: cacheWithCart([readmeCart[1]]),
      server: server,
    );
    t.container.read(routerProvider).push('/checkout').ignore();
    await _settle(tester);
    expect(find.text('انتهت مواعيد اليوم. اختر يوماً آخر.'), findsOneWidget);
    expect(find.textContaining('يحتاج 0 ساعة'), findsNothing);
  });

  _testCheckout('busy and closed shop (screen 39, FR-ADM-12)', (tester) async {
    final server = FixtureServer();
    Map<String, Object?> config(String mode) {
      final c = (FixtureServer.fixture('app_config')! as Map)
          .cast<String, Object?>();
      return {
        ...c,
        'shop': {
          ...(c['shop']! as Map).cast<String, Object?>(),
          'mode': mode,
          if (mode == 'busy') 'acceptsFrom': '20:00',
          'message': {'ar': 'عندنا طلبات كثيرة اليوم', 'en': 'Busy today'},
        },
      };
    }

    var mode = 'busy';
    server.overrides['/v1/app/config'] = (_) => (200, config(mode));
    _tall(tester);
    final t = await pumpTestApp(
      tester,
      cache: cacheWithCart(readmeCart),
      server: server,
    );
    await _settle(tester);
    expect(find.text('المحل مشغول حالياً'), findsOneWidget);
    expect(
      find.text('نستقبل الطلبات لمواعيد تبدأ من 20:00 اليوم أو لأي يوم لاحق.'),
      findsOneWidget,
    );
    expect(find.text('عندنا طلبات كثيرة اليوم'), findsOneWidget);

    mode = 'closed';
    t.container.invalidate(appConfigProvider);
    t.container.read(routerProvider).push('/checkout').ignore();
    await _settle(tester);
    expect(find.text('المحل لا يستقبل طلبات الآن'), findsOneWidget);
    final button = find.ancestor(
      of: find.text('متابعة للدفع'),
      matching: find.byType(InkWell),
    );
    expect(tester.widget<InkWell>(button.first).onTap, isNull);
  });
}

/// A zone as the API gives it on an address.
Map<String, Object?> zoneOf(String slug) {
  final z = (FixtureServer.fixture('delivery/zones')! as List)
      .cast<Map<String, Object?>>()
      .firstWhere((z) => z['slug'] == slug);
  return {
    for (final k in ['slug', 'name', 'feeMinor', 'eta']) k: z[k],
  };
}
