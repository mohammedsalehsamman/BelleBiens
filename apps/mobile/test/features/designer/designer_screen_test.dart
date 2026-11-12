import 'dart:convert';

import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:belle_biens/features/designer/data/designer_repository.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

/// The designer's pages are long; a tall window builds each step whole.
void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 2600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<TestHarness> _openDesigner(
  WidgetTester tester, {
  MemoryJsonCache? cache,
  FixtureServer? server,
}) async {
  _tall(tester);
  final t = await pumpTestApp(tester, cache: cache, server: server);
  await tapText(tester, 'صمّم باقتك', last: true);
  return t;
}

DesignerController _controller(TestHarness t) =>
    t.container.read(designerControllerProvider.notifier);

BouquetSpec _spec(TestHarness t) =>
    t.container.read(designerControllerProvider).value!.spec;

Future<void> _plus(WidgetTester tester, String item, {int times = 1}) async {
  for (var i = 0; i < times; i++) {
    await tester.tap(find.bySemanticsLabel('+ $item'));
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// Waits out the 400 ms debounce of the server quote. The first frame
/// builds the new quote request; then its timer runs.
Future<void> _settleQuote(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 450));
  await tester.pumpAndSettle();
}

/// A widget test that ends by letting the quote's 400 ms debounce run out,
/// so no timer is left when the test finishes.
void _testDesigner(String name, Future<void> Function(WidgetTester) body) =>
    testWidgets(name, (tester) async {
      await body(tester);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

void main() {
  _testDesigner('step 1: occasions, sizes with their limits, optional palette '
      '(screen 15)', (tester) async {
    final t = await _openDesigner(tester);
    expect(find.text('الخطوة 1 من 4 · المناسبة والحجم'), findsOneWidget);
    expect(find.text('بدون مناسبة'), findsOneWidget);
    expect(find.text('15 – 30 وردة'), findsOneWidget);
    expect(find.text('51 – 100 وردة'), findsOneWidget);
    expect(find.text('اختر الورد ليظهر السعر'), findsOneWidget);

    await tapText(tester, 'عيد ميلاد');
    await tapText(tester, 'أحمر رومانسي');
    expect(_spec(t).occasion, 'birthday');
    expect(_spec(t).palette, 'romantic_red');
    // A second tap clears the optional palette.
    await tapText(tester, 'أحمر رومانسي');
    expect(_spec(t).palette, isNull);
  });

  _testDesigner('steps 2-4 build the README bouquet: 18 stems, 1,560 then '
      '2,676 (screens 16-18)', (tester) async {
    final t = await _openDesigner(tester);
    await tapText(tester, 'التالي: اختيار الورد');
    expect(find.text('الخطوة 2 من 4 · الورد والخضرة'), findsOneWidget);
    expect(find.text('90 ل.س · متوفر 120'), findsOneWidget);
    expect(find.text('غير متوفر اليوم'), findsWidgets);
    expect(find.text('اقترح بديلاً'), findsWidgets);

    await _plus(tester, 'جوري أحمر', times: 12);
    await _plus(tester, 'جيبسوفيلا (بيبي بريث)', times: 6);
    await _plus(tester, 'أوكاليبتوس', times: 3);
    expect(find.text('18 وردة من 15 – 30'), findsOneWidget);
    // Flowers and greens 1,560 (screen 16), plus the default kraft wrap (60)
    // and pink ribbon (36): a bouquet always has a wrap, so it is priced.
    expect(find.text('1,656 ل.س'), findsOneWidget);
    expect(find.text(r'≈ $13.80'), findsOneWidget);

    await tapText(tester, 'التالي: التغليف');
    await tapText(tester, 'ساتان');
    await _plus(tester, 'دبدوب صغير');
    expect(find.text('شريط ساتان · \u2066+36\u2069'), findsOneWidget);
    expect(_spec(t).wrap, 'satin_bordeaux');

    await tapText(tester, 'التالي: البطاقة والمعاينة');
    await _settleQuote(tester);
    expect(find.text('ملخص الباقة'), findsOneWidget);
    expect(find.text('جوري أحمر × 12'), findsOneWidget);
    expect(find.text('1,080 ل.س'), findsOneWidget);
    expect(find.text('تغليف ساتان'), findsOneWidget);
    expect(find.text('2,676 ل.س'), findsWidgets);

    final quote = t.server.to('/v1/designer/quote').last;
    final sent = (quote.data as Map)['spec'] as Map;
    expect(sent['flowers'], [
      {'id': 'red_rose', 'qty': 12},
      {'id': 'white_gypsophila', 'qty': 6},
    ]);
    expect(sent['extras'], [
      {'id': 'teddy_bear_small', 'qty': 1},
    ]);

    await tapText(tester, 'أضف الباقة إلى السلة');
    expect(
      find.text('السلة قيد التجهيز وتصل في التحديث القادم.'),
      findsOneWidget,
    );
  });

  _testDesigner('the stepper stops at what is left today (FR-DSG-03)', (
    tester,
  ) async {
    final t = await _openDesigner(tester);
    await tapText(tester, 'التالي: اختيار الورد');
    await _plus(tester, 'جيبسوفيلا (بيبي بريث)', times: 8);
    expect(_spec(t).qty(SpecList.flowers, 'white_gypsophila'), 6);
  });

  _testDesigner('next is off until the stems fit the size', (tester) async {
    final t = await _openDesigner(tester);
    await tapText(tester, 'التالي: اختيار الورد');
    await _plus(tester, 'جوري أحمر', times: 3);
    expect(find.text('هذا الحجم يحتاج 15 وردة على الأقل.'), findsOneWidget);
    await tapText(tester, 'التالي: التغليف');
    expect(find.text('الخطوة 2 من 4 · الورد والخضرة'), findsOneWidget);

    await _controller(t)
        .edit((s) => s.withQty(SpecList.flowers, 'red_rose', 15));
    await tester.pumpAndSettle();
    await tapText(tester, 'التالي: التغليف');
    expect(find.text('الخطوة 3 من 4 · التغليف والإضافات'), findsOneWidget);
  });

  _testDesigner('undo and redo (FR-DSG-10)', (tester) async {
    final t = await _openDesigner(tester);
    await tapText(tester, 'التالي: اختيار الورد');
    await _plus(tester, 'جوري أحمر', times: 2);
    expect(_spec(t).stems, 2);

    await tester.tap(find.bySemanticsLabel('تراجع'));
    await tester.pumpAndSettle();
    expect(_spec(t).stems, 1);
    await tester.tap(find.bySemanticsLabel('إعادة'));
    await tester.pumpAndSettle();
    expect(_spec(t).stems, 2);
  });

  _testDesigner('the draft survives closing the app (FR-DSG-11)', (
    tester,
  ) async {
    final cache = MemoryJsonCache();
    final t = await _openDesigner(tester, cache: cache);
    await tapText(tester, 'التالي: اختيار الورد');
    await _plus(tester, 'جوري وردي', times: 3);
    final draft = cache.entries[DesignerRepository.draftKey]!.json! as Map;
    expect(draft['step'], 'flowers');
    expect(jsonEncode(draft['spec']), contains('pink_rose'));
    expect(
      t.container.read(designerControllerProvider).value!.step,
      DesignerStep.flowers,
    );

    await tester.pumpWidget(const SizedBox());
    await _openDesigner(tester, cache: cache);
    expect(find.text('الخطوة 2 من 4 · الورد والخضرة'), findsOneWidget);
    expect(find.text('3 ورود'), findsWidgets);
  });

  _testDesigner('"Customize" opens a ready bouquet in the designer '
      '(FR-CAT-07)', (tester) async {
    _tall(tester);
    final t = await pumpTestApp(tester);
    t.container.read(routerProvider).push('/p/red-rose-bouquet').ignore();
    await tester.pumpAndSettle();
    await tapText(tester, 'خصّصها');

    expect(find.text('الخطوة 2 من 4 · الورد والخضرة'), findsOneWidget);
    expect(_spec(t).qty(SpecList.flowers, 'red_rose'), 25);
    expect(_spec(t).wrap, 'satin_bordeaux');
    expect(find.text('25 وردة'), findsWidgets);
  });

  _testDesigner('a flower that ran out: banner, substitutes, apply '
      '(screen 37)', (tester) async {
    final server = FixtureServer();
    server.overrides['/v1/designer/quote'] = (_) => (
      200,
      {
        ...(FixtureServer.fixture('designer/quote_readme')! as Map),
        'orderable': false,
        'issues': [
          {
            'code': 'STOCK_INSUFFICIENT',
            'itemId': 'pink_rose',
            'requested': 8,
            'available': 4,
            'alternatives': <Object>[],
          },
        ],
      },
    );
    final t = await _openDesigner(tester, server: server);
    await _controller(t).edit(
      (s) => s
          .withQty(SpecList.flowers, 'red_rose', 10)
          .withQty(SpecList.flowers, 'pink_rose', 8),
    );
    await _settleQuote(tester);

    await tapText(tester, 'بعض الورد نفد للتو. راجع البدائل.');
    expect(find.text('بقي 4 من جوري وردي، وتصميمك يحتاج 8.'), findsOneWidget);
    // Keep the 4 left and add 4 of the best substitute; or replace them all.
    expect(find.text('جوري وردي 4 + جوري أحمر 4'), findsOneWidget);
    expect(find.text('جوري أبيض 8'), findsOneWidget);
    expect(find.text('نفس السعر'), findsWidgets);

    await tapText(tester, 'تطبيق البديل');
    expect(_spec(t).flowers, const [
      SpecLine('red_rose', 14),
      SpecLine('pink_rose', 4),
    ]);
    expect(_spec(t).stems, 18);
  });

  _testDesigner('the card message counts characters, not bytes', (
    tester,
  ) async {
    final t = await _openDesigner(tester);
    await _controller(t)
        .edit((s) => s.withQty(SpecList.flowers, 'red_rose', 15));
    await _controller(t).goTo(DesignerStep.cardAndPreview);
    await tester.pumpAndSettle();
    final message = fieldBelow('الرسالة');
    await tester.enterText(message, 'كل عام وأنتِ أجمل 🌹');
    await _settleQuote(tester);
    expect(find.text('19 / 200'), findsOneWidget);
    expect(_spec(t).cardMessage, 'كل عام وأنتِ أجمل 🌹');
  });

  _testDesigner('"Send to the shop" uploads the preview and opens WhatsApp '
      'with the summary (FR-DSG-13)', (tester) async {
    final server = FixtureServer();
    final branch = Map<String, Object?>.from(
      FixtureServer.fixture('branch')! as Map,
    )..['whatsapp'] = '+963944000000';
    server.overrides['/v1/branch'] = (_) => (200, branch);
    final t = await _openDesigner(tester, server: server);
    await _controller(t)
        .edit((s) => s.withQty(SpecList.flowers, 'red_rose', 15));
    await _controller(t).goTo(DesignerStep.cardAndPreview);
    await _settleQuote(tester);

    // Drawing the PNG needs real async work (image encoding).
    await tester.runAsync(() async {
      await tester.tap(find.text('أرسل للمحل'));
      for (var i = 0; i < 50 && t.links.opened.isEmpty; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    });
    await tester.pumpAndSettle();

    expect(t.server.to('/v1/designer/preview-image'), hasLength(1));
    final link = t.links.opened.single;
    expect(link.host, 'wa.me');
    expect(link.path, '/963944000000');
    final text = link.queryParameters['text']!;
    expect(text, contains('جوري أحمر × 15'));
    expect(text, contains('https://media.test/previews/test.webp'));
  });

  _testDesigner("without the shop's WhatsApp number, says so", (tester) async {
    final t = await _openDesigner(tester);
    await _controller(t)
        .edit((s) => s.withQty(SpecList.flowers, 'red_rose', 15));
    await _controller(t).goTo(DesignerStep.cardAndPreview);
    await _settleQuote(tester);
    await tapText(tester, 'أرسل للمحل');
    expect(find.text('يضيف المحل رقم واتساب قريباً.'), findsOneWidget);
    expect(t.links.opened, isEmpty);
  });
}
