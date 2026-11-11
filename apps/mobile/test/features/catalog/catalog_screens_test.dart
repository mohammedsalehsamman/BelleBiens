import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

Future<void> _go(TestHarness t, WidgetTester tester, String path) async {
  t.container.read(routerProvider).go(path);
  await tester.pumpAndSettle();
}

Future<void> _push(TestHarness t, WidgetTester tester, String path) async {
  t.container.read(routerProvider).push(path).ignore();
  await tester.pumpAndSettle();
}

void main() {
  group('home (screen 06)', () {
    testWidgets('currency switch puts dollars first and is remembered', (
      tester,
    ) async {
      final t = await pumpTestApp(tester);
      expect(find.text('2,400 ل.س'), findsWidgets);

      await tapText(tester, r'$');
      expect(find.text(r'$20.00'), findsWidgets);
      expect(t.prefs.values[AppPreferences.displayCurrencyKey], 'usd');
      // Dollars are now the big price; pounds the small one.
      final big = tester.widget<Text>(find.text(r'$20.00').first);
      expect(big.style?.fontSize, greaterThan(14));
    });

    testWidgets('offline: the last saved home shows with a notice '
        '(screen 39)', (tester) async {
      final cache = MemoryJsonCache();
      await pumpTestApp(tester, cache: cache);
      expect(cache.entries.keys, contains('home'));

      await tester.pumpWidget(const SizedBox());
      final offline = FixtureServer()..offline = true;
      await pumpTestApp(tester, cache: cache, server: offline);
      expect(find.text('أنت غير متصل. نعرض آخر نسخة محفوظة.'), findsOneWidget);
      expect(find.text('باقة الجوري الأحمر'), findsWidgets);
    });

    testWidgets('offline with nothing saved: error and retry', (tester) async {
      final server = FixtureServer()..offline = true;
      await pumpTestApp(tester, server: server);
      expect(
        find.text('لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.'),
        findsOneWidget,
      );
      server.offline = false;
      await tapText(tester, 'إعادة المحاولة');
      expect(find.text('باقة الجوري الأحمر'), findsWidgets);
    });

    testWidgets('a category opens the shop filtered', (tester) async {
      final t = await pumpTestApp(tester);
      await tapText(tester, 'كيك وحلويات');
      expect(find.text('المتجر'), findsWidgets);
      final sent = t.server.to('/v1/products').last.uri.queryParameters;
      expect(sent['category'], 'cakes');
    });

    testWidgets('English text and SYP (EI-UI-01)', (tester) async {
      await pumpTestApp(tester, language: 'en');
      expect(find.text('Design your own bouquet'), findsOneWidget);
      expect(find.text('Red rose bouquet'), findsWidgets);
      expect(find.text('2,400 SYP'), findsWidgets);
    });
  });

  group('shop and filters (screens 07, 09)', () {
    testWidgets('lists products with the count and sort', (tester) async {
      final t = await pumpTestApp(tester);
      await _go(t, tester, '/shop');
      expect(find.text('20 منتجاً · مرتبة حسب: الأكثر طلباً'), findsOneWidget);
      expect(find.text('باقة الجوري الأحمر'), findsOneWidget);
      expect(find.text('من 2,280 ل.س'), findsOneWidget);

      await tapText(tester, '20 منتجاً · مرتبة حسب: الأكثر طلباً');
      await tapText(tester, 'السعر: من الأقل');
      final sent = t.server.to('/v1/products').last.uri.queryParameters;
      expect(sent['sort'], 'price_asc');
    });

    testWidgets('filters show the live count and apply on confirm', (
      tester,
    ) async {
      final t = await pumpTestApp(tester);
      t.server.overrides['/v1/products'] = (request) {
        final colors = request.uri.queryParametersAll['colors'] ?? const [];
        final countOnly = request.uri.queryParameters['pageSize'] == '0';
        final page = FixtureServer.fixture('products')! as Map;
        return (
          200,
          {
            ...page,
            if (countOnly) 'items': <Object>[],
            'total': colors.contains('red') ? 3 : 20,
          },
        );
      };
      await _go(t, tester, '/shop');
      await tapText(tester, 'الفلاتر');
      expect(find.text('عرض 20 منتجاً'), findsOneWidget);

      await tapText(tester, 'أحمر');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('عرض 3 منتجات'), findsOneWidget);

      await tapText(tester, 'عرض 3 منتجات');
      expect(find.text('الفلاتر · 1'), findsOneWidget);
      final applied = t.server.to('/v1/products').last.uri;
      expect(applied.queryParametersAll['colors'], ['red']);
      expect(applied.queryParameters['pageSize'], '20');
    });
  });

  group('search (screen 08, FR-CAT-04)', () {
    testWidgets('results as you type, tabs, and recent searches', (
      tester,
    ) async {
      final t = await pumpTestApp(tester);
      await _push(t, tester, '/search');
      await tester.enterText(find.byType(EditableText), 'جوري');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(t.server.to('/v1/search').single.uri.queryParameters['q'], 'جوري');
      expect(find.text('الكل · 3'), findsOneWidget);
      expect(find.text('ورد وباقات · 3'), findsOneWidget);
      expect(find.text('باقة الجوري الفاخرة'), findsOneWidget);

      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(t.prefs.values[AppPreferences.recentSearchesKey], '["جوري"]');
    });

    testWidgets('no results says so', (tester) async {
      final t = await pumpTestApp(tester);
      t.server.overrides['/v1/search'] = (r) => (
        200,
        {
          'query': r.uri.queryParameters['q'],
          'total': 0,
          'facets': <Object>[],
          'items': <Object>[],
        },
      );
      await _push(t, tester, '/search');
      await tester.enterText(find.byType(EditableText), 'دبدوب أزرق');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(
        find.text('لم نجد نتائج لـ «دبدوب أزرق». جرّب كلمة أخرى.'),
        findsOneWidget,
      );
    });
  });

  group("today's flowers (screen 10)", () {
    testWidgets('products with what is left, and stems for the designer', (
      tester,
    ) async {
      final t = await pumpTestApp(tester);
      await _push(t, tester, '/today');
      expect(
        find.text(
          'يحدّث المحل هذه القائمة يومياً. تنتهي صلاحيتها منتصف الليل '
          'بتوقيت دمشق.',
        ),
        findsOneWidget,
      );
      expect(find.text('متبقٍ 8 قطع'), findsOneWidget);
      expect(find.text('متوفرة'), findsOneWidget);
      expect(find.text('جوري أحمر · 120'), findsOneWidget);
      // Fillers count as stems; greens show their name only.
      expect(find.text('جيبسوفيلا (بيبي بريث) · 6'), findsOneWidget);
      expect(find.text('أوكاليبتوس'), findsOneWidget);
      expect(find.text('صمّم باقة من ورد اليوم'), findsOneWidget);
    });
  });

  group('occasion (screen 11)', () {
    testWidgets('tabs narrow the products', (tester) async {
      final t = await pumpTestApp(tester);
      await _push(t, tester, '/occasions/birthday');
      expect(find.text('هدايا عيد الميلاد'), findsOneWidget);
      expect(find.text('شمعة عيد ميلاد'), findsOneWidget);

      await tapText(tester, 'كيك');
      expect(find.text('كيكة الورد والفستق'), findsOneWidget);
      expect(find.text('شمعة عيد ميلاد'), findsNothing);
    });
  });

  group('branch (screen 34)', () {
    testWidgets('directions and Instagram open other apps; missing '
        'numbers are explained', (tester) async {
      final t = await pumpTestApp(tester);
      await _push(t, tester, '/branch');
      expect(find.text('زقاق الكرامة، أبو رمانة، دمشق'), findsOneWidget);
      expect(find.text('نتواجد أيضاً على Movo · BeeOrder'), findsOneWidget);
      expect(
        find.text('يضيف المحل رقم الهاتف وواتساب قريباً.'),
        findsOneWidget,
      );

      await tapText(tester, 'الاتجاهات');
      expect(t.links.opened.single.scheme, 'geo');
      expect(t.links.opened.single.path, '33.5155,36.284');

      await tapText(tester, 'سياسة التوصيل');
      expect(find.textContaining('يكتب المحل سياسة التوصيل'), findsOneWidget);
    });
  });
}
