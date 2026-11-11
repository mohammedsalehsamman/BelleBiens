import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

Future<TestHarness> openProduct(
  WidgetTester tester,
  String slug, {
  String? storedSession,
}) async {
  tallWindow(tester);
  final t = await pumpTestApp(tester, storedSession: storedSession);
  t.container.read(routerProvider).push('/p/$slug').ignore();
  await tester.pumpAndSettle();
  return t;
}

/// Product pages are long; a tall window builds all of a page at once.
void tallWindow(WidgetTester tester) {
  tester.view.physicalSize = const Size(400, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// The add button's label, which carries the total.
Finder addButton(String total) => find.text('أضف · $total');

void main() {
  testWidgets('bouquet: sizes, included wraps, gift card and quantity '
      'change the total (screen 12)', (tester) async {
    await openProduct(tester, 'red-rose-bouquet');

    expect(find.text('باقة جاهزة'), findsOneWidget);
    expect(find.text('الحجم المختار: متوسطة'), findsOneWidget);
    expect(find.text('(مشمول بالسعر)'), findsOneWidget);
    expect(find.text('أقرب توصيل: اليوم'), findsOneWidget);
    expect(find.text('خصّصها'), findsOneWidget);
    // Size rows show their full price, like the screen: 1,800 / 2,400 / 3,360.
    expect(find.text('1,800 ل.س'), findsOneWidget);
    expect(find.text('3,360 ل.س'), findsOneWidget);
    expect(addButton('2,400 ل.س'), findsOneWidget);

    await tapText(tester, 'فاخرة');
    expect(find.text('الحجم المختار: فاخرة'), findsOneWidget);
    expect(addButton('3,360 ل.س'), findsOneWidget);

    await tapText(tester, 'بطاقة إهداء');
    expect(addButton('3,480 ل.س'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('+ باقة الجوري الأحمر'));
    await tester.pumpAndSettle();
    expect(addButton('6,960 ل.س'), findsOneWidget);

    // Pairings: "add to your gift".
    expect(find.text('أضف إلى هديتك'), findsOneWidget);
    expect(find.text('ماكرون 6 قطع'), findsOneWidget);
  });

  testWidgets('drink: oat milk adds 60 (screen 14)', (tester) async {
    await openProduct(tester, 'iced-rose-matcha-latte');
    expect(addButton('540 ل.س'), findsOneWidget);
    expect(find.text('يناسب مع مشروبك'), findsOneWidget);

    await tapText(tester, 'حليب الشوفان');
    expect(addButton('600 ل.س'), findsOneWidget);
  });

  testWidgets('cake: allergens and tomorrow (FR-CKE-05, FR-DLV-05)', (
    tester,
  ) async {
    await openProduct(tester, 'rose-pistachio-cake');
    expect(
      find.text('مسببات الحساسية: مكسرات، حليب، بيض، غلوتين'),
      findsOneWidget,
    );
    expect(find.text('أقرب توصيل: غداً'), findsOneWidget);
    expect(find.text('يُطلب قبل 24 ساعة'), findsWidgets);
  });

  testWidgets('add to cart says the cart is coming (S4)', (tester) async {
    await openProduct(tester, 'iced-rose-matcha-latte');
    await tester.tap(addButton('540 ل.س'));
    await tester.pumpAndSettle();
    expect(
      find.text('السلة قيد التجهيز وتصل في التحديث القادم.'),
      findsOneWidget,
    );
  });

  testWidgets('a guest is asked to sign in to save a favorite', (tester) async {
    final t = await openProduct(tester, 'red-rose-bouquet');
    await tester.tap(find.bySemanticsLabel('أضف إلى المفضلة'));
    await tester.pumpAndSettle();
    expect(find.text('سجّل الدخول لتحفظ منتجاتك المفضلة.'), findsOneWidget);
    expect(t.server.to('/v1/me/favorites/red-rose-bouquet'), isEmpty);
  });

  testWidgets('a signed-in customer saves and sees it in favorites '
      '(screen 32, FR-ACC-06)', (tester) async {
    final session = Session.fromAuth(testSession()).toJson();
    final server = FixtureServer();
    final saved = <String>[];
    server.overrides['/v1/me/favorites'] = (_) => (
      200,
      [
        for (final slug in saved)
          ((FixtureServer.fixture('products')! as Map)['items'] as List)
              .firstWhere((c) => (c as Map)['slug'] == slug),
      ],
    );
    server.overrides['/v1/me/favorites/red-rose-bouquet'] = (request) {
      if (request.method == 'PUT') saved.add('red-rose-bouquet');
      if (request.method == 'DELETE') saved.remove('red-rose-bouquet');
      return (204, null);
    };

    tallWindow(tester);
    final t = await pumpTestApp(tester, storedSession: session, server: server);
    t.container.read(routerProvider).push('/p/red-rose-bouquet').ignore();
    await tester.pumpAndSettle();

    await tester.tap(find.bySemanticsLabel('أضف إلى المفضلة'));
    await tester.pumpAndSettle();
    expect(saved, ['red-rose-bouquet']);
    expect(find.bySemanticsLabel('أزل من المفضلة'), findsOneWidget);

    t.container.read(routerProvider).go('/account/favorites');
    await tester.pumpAndSettle();
    expect(find.text('المفضلة'), findsWidgets);
    expect(find.text('باقة الجوري الأحمر'), findsOneWidget);
  });

  testWidgets('a missing product shows the server message', (tester) async {
    await openProduct(tester, 'no-such-product');
    expect(find.text('لم نجد ما تبحث عنه.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
