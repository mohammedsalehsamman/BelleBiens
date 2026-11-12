import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

Future<TestHarness> _openBox(WidgetTester tester) async {
  tester.view.physicalSize = const Size(420, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final t = await pumpTestApp(tester);
  t.container.read(routerProvider).push('/box').ignore();
  await tester.pumpAndSettle();
  return t;
}

void main() {
  testWidgets('starts like the design: 9 roses and 6 sweets for 2,520 '
      '(screen 19)', (tester) async {
    await _openBox(tester);
    expect(find.text('مربع · ركنان'), findsOneWidget);
    expect(find.text('من \u20682,520 ل.س\u2069'), findsOneWidget);
    expect(find.text('من \u20683,600 ل.س\u2069'), findsOneWidget);
    expect(find.text('حتى 12'), findsOneWidget);
    expect(find.text('6 من 6'), findsOneWidget);
    expect(find.text('2,520 ل.س'), findsOneWidget);
  });

  testWidgets('the long box adds a gift part', (tester) async {
    await _openBox(tester);
    await tapText(tester, 'مستطيل · 3 أركان');
    expect(find.text('ركن الهدية'), findsOneWidget);
    expect(find.text('3,600 ل.س'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('+ دبدوب صغير'));
    await tester.pumpAndSettle();
    expect(find.text('4,560 ل.س'), findsOneWidget);
  });

  testWidgets('a compartment stops at its capacity (FR-BOX-02)', (
    tester,
  ) async {
    await _openBox(tester);
    // The sweets part is already full: another sweet cannot go in.
    await tester.tap(find.bySemanticsLabel('+ شوكولا محشوة'));
    await tester.pumpAndSettle();
    expect(find.text('6 من 6'), findsOneWidget);
    expect(find.text('2,520 ل.س'), findsOneWidget);
  });

  testWidgets('add to cart sends a BoxSpec v1', (tester) async {
    final t = await _openBox(tester);
    await tapText(tester, 'أضف إلى السلة');
    expect(find.text('أُضيف مربع · ركنان إلى السلة'), findsOneWidget);
    final line = t.container.read(cartControllerProvider).value!.single;
    expect(line.kind, CartItemKind.box);
    expect(line.spec, {
      'schemaVersion': 1,
      'boxType': 'square_two',
      'compartments': [
        {
          'index': 0,
          'items': [
            {'id': 'red_rose', 'qty': 9},
          ],
        },
        {
          'index': 1,
          'items': [
            {'id': 'macaron_piece', 'qty': 6},
          ],
        },
      ],
    });
    await tester.pump(const Duration(seconds: 1));
  });
}
