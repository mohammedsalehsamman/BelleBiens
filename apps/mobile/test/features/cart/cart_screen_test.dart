import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/cart/data/cart_repository.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cart_fixtures.dart';
import '../../helpers/fake_cart_quote.dart';
import '../../helpers/test_app.dart';

void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Opens the cart and lets the 400 ms quote debounce run.
Future<TestHarness> _openCart(
  WidgetTester tester, {
  List<CartLine> lines = readmeCart,
  FixtureServer? server,
  String? storedSession,
}) async {
  _tall(tester);
  final t = await pumpTestApp(
    tester,
    cache: cacheWithCart(lines),
    server: server,
    storedSession: storedSession,
  );
  t.container.read(routerProvider).push('/cart').ignore();
  await _settle(tester);
  return t;
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pumpAndSettle();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pumpAndSettle();
}

/// Ends with the quote debounce run out, so no timer is left.
void _testCart(String name, Future<void> Function(WidgetTester) body) =>
    testWidgets(name, (tester) async {
      await body(tester);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

void main() {
  _testCart('the README cart: lines, 7,116 SYP and USD, and why it is '
      'tomorrow (screen 20)', (tester) async {
    final t = await _openCart(tester);
    expect(find.text('السلة · 4 قطع'), findsOneWidget);
    expect(find.text('باقتك المصمّمة'), findsOneWidget);
    expect(find.text('بطاقة: «كل عام وأنتِ أجمل يا لين»'), findsOneWidget);
    expect(find.text('لاتيه الورد بالماتشا المثلج'), findsOneWidget);
    expect(find.text('كيكة الورد والفستق'), findsOneWidget);
    expect(find.text('2,676 ل.س'), findsOneWidget);
    expect(find.text('1,080 ل.س'), findsOneWidget);
    expect(find.text('3,360 ل.س'), findsOneWidget);
    expect(find.text('7,116 ل.س'), findsWidgets);
    expect(find.text(r'≈ $59.30'), findsOneWidget);
    expect(find.text('يُحسب حسب المنطقة'), findsOneWidget);
    expect(
      find.text(
        'يحتاج بعض ما في سلتك 24 ساعة للتجهيز، لذلك أقرب موعد للطلب '
        'كاملاً هو غداً 15:00.',
      ),
      findsOneWidget,
    );
    expect(find.text('قد يعجبك أيضاً'), findsOneWidget);
    expect(find.text('ماكرون 6 قطع'), findsOneWidget);

    final sent = t.server.to('/v1/cart/quote').last.data as Map;
    expect((sent['lines'] as List).map((l) => (l as Map)['id']), [
      'l1',
      'l2',
      'l3',
    ]);
  });

  _testCart('quantities change the cart and its price; 0 removes', (
    tester,
  ) async {
    final t = await _openCart(tester);
    await tester.tap(find.bySemanticsLabel('+ لاتيه الورد بالماتشا المثلج'));
    await _settle(tester);
    expect(find.text('1,620 ل.س'), findsOneWidget);
    expect(find.text('7,656 ل.س'), findsWidgets);

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.bySemanticsLabel('− لاتيه الورد بالماتشا المثلج'));
      await tester.pump();
    }
    await _settle(tester);
    final lines = t.container.read(cartControllerProvider).value!;
    expect(lines.map((l) => l.id), ['l1', 'l3']);
    // Kept on the phone (FR-CRT-03).
    expect((t.cache.entries[CartRepository.linesKey]!.json! as List).length, 2);
  });

  _testCart('a coupon applies; a wrong one says so (FR-CRT-07)', (
    tester,
  ) async {
    await _openCart(tester);
    await tester.enterText(fieldBelow('كوبون خصم'), 'welcome10');
    await tapText(tester, 'تطبيق');
    await _settle(tester);
    expect(find.text('تم تطبيق WELCOME10'), findsOneWidget);
    expect(find.text('الخصم'), findsOneWidget);
    expect(find.text('6,404.40 ل.س'), findsWidgets);

    await tester.tap(
      find.byWidgetPredicate(
        (w) => w is BBIconButton && w.tooltip == 'إزالة الكوبون',
      ),
    );
    await _settle(tester);
    await tester.enterText(fieldBelow('كوبون خصم'), 'NOPE');
    await tapText(tester, 'تطبيق');
    await _settle(tester);
    expect(find.text('هذا الكوبون غير صحيح.'), findsOneWidget);
  });

  _testCart('line problems show on the line and stop checkout', (tester) async {
    final server = FixtureServer();
    server.overrides['/v1/cart/quote'] = (request) {
      final quote = fakeCartQuote(request.data! as Map);
      (quote['lines']! as List<Map<String, Object?>>)[1]['issues'] = [
        {'code': 'STOCK_INSUFFICIENT', 'requested': 2, 'available': 1},
      ];
      return (200, {...quote, 'orderable': false});
    };
    await _openCart(tester, server: server);
    expect(find.text('المتوفر الآن 1 فقط.'), findsOneWidget);
    await tapText(tester, 'متابعة للتوصيل');
    expect(find.text('عدّل ما في السلة قبل المتابعة.'), findsOneWidget);
  });

  _testCart('"edit the design" puts it back in its line', (tester) async {
    final t = await _openCart(tester);
    await tapText(tester, 'تعديل التصميم');
    final state = t.container.read(designerControllerProvider).value!;
    expect(state.editingLineId, 'l1');
    expect(state.step, DesignerStep.flowers);
    expect(find.text('الخطوة 2 من 4 · الورد والخضرة'), findsOneWidget);

    await t.container
        .read(designerControllerProvider.notifier)
        .goTo(DesignerStep.cardAndPreview);
    await _settle(tester);
    await tapText(tester, 'حدّث الباقة في السلة');
    expect(find.text('حُدّثت الباقة في السلة'), findsOneWidget);
    final lines = t.container.read(cartControllerProvider).value!;
    expect(lines.map((l) => l.id), ['l1', 'l2', 'l3']);
  });

  _testCart('empty cart (screen 35)', (tester) async {
    await _openCart(tester, lines: const []);
    expect(find.text('سلتك فارغة'), findsOneWidget);
    await tapText(tester, 'تصفّح ورد اليوم');
    expect(find.text('ورد اليوم'), findsWidgets);
  });

  _testCart('the capsule on home shows the count and the total, and opens '
      'the cart', (tester) async {
    _tall(tester);
    await pumpTestApp(tester, cache: cacheWithCart(readmeCart));
    await _settle(tester);
    expect(find.text('السلة · 4 قطع'), findsOneWidget);
    expect(find.text('7,116 ل.س'), findsOneWidget);
    await tapText(tester, 'إتمام الطلب');
    expect(find.text('باقتك المصمّمة'), findsOneWidget);
  });

  _testCart('signing in merges the phone cart into the account '
      '(FR-CRT-03)', (tester) async {
    final server = FixtureServer()
      ..savedCart = [
        const CartLine(
          id: 'acc',
          kind: CartItemKind.product,
          qty: 1,
          product: ProductChoice(slug: 'glass-vase'),
        ).toJson(),
      ];
    final t = await _openCart(
      tester,
      server: server,
      storedSession: Session.fromAuth(testSession()).toJson(),
    );
    final lines = t.container.read(cartControllerProvider).value!;
    expect(lines.map((l) => l.id), ['acc', 'l1', 'l2', 'l3']);
    // The merged cart went back to the account.
    expect(server.savedCart.map((l) => (l! as Map)['id']), [
      'acc',
      'l1',
      'l2',
      'l3',
    ]);
  });
}
