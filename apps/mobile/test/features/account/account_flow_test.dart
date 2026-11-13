import 'dart:convert';

import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/analytics/analytics.dart';
import 'package:belle_biens/features/account/presentation/settings_screen.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cart_fixtures.dart';
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

void _testAccount(String name, Future<void> Function(WidgetTester) body) =>
    testWidgets(name, (tester) async {
      await body(tester);
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

Map<String, Object?> _zone(String slug) {
  final z = (FixtureServer.fixture('delivery/zones')! as List)
      .cast<Map<String, Object?>>()
      .firstWhere((z) => z['slug'] == slug);
  return {
    for (final k in ['slug', 'name', 'feeMinor', 'eta']) k: z[k],
  };
}

Map<String, Object?> _address(
  String id,
  String label, {
  bool isDefault = false,
  bool inZone = true,
}) => {
  'id': id,
  'label': label,
  'latitude': inZone ? 33.5155 : 33.42,
  'longitude': inZone ? 36.284 : 36.2,
  'area': '',
  'landmark': 'قرب الحديقة',
  'building': '12',
  'floor': '3',
  'details': '',
  'isDefault': isDefault,
  'callBeforeArrival': true,
  if (inZone) 'zone': _zone('abu-rummaneh'),
};

/// A signed-in customer's server: addresses, designs, occasions, profile.
class _Account {
  final addresses = <Map<String, Object?>>[
    _address('5d1f0c3e-0000-4000-8000-000000000001', 'البيت', isDefault: true),
    _address('5d1f0c3e-0000-4000-8000-000000000002', 'المزرعة', inZone: false),
  ];
  final designs = <Map<String, Object?>>[
    {
      'id': '6e2f0c3e-0000-4000-8000-000000000001',
      'name': 'عيد ميلاد لين',
      'spec': readmeSpec,
      'stems': 18,
      'wrap': {'ar': 'ساتان بوردو', 'en': 'Bordeaux satin'},
      'priceMinor': 267_600,
      'available': true,
      'updatedAt': '2026-11-10T12:00:00.000Z',
    },
  ];
  final occasions = <Map<String, Object?>>[
    {
      'id': '7f3f0c3e-0000-4000-8000-000000000001',
      'person': 'ماما',
      'type': 'BIRTHDAY',
      'date': '1965-11-20',
      'remindDaysBefore': 7,
      'next': '2026-11-20',
      'daysLeft': 9,
    },
  ];
  Map<String, Object?> user = testUser().toJson();
  bool deleted = false;

  FixtureServer server() {
    final server = FixtureServer();
    server.overrides['/v1/me/addresses'] = (r) {
      if (r.method == 'POST') {
        final body = Map<String, Object?>.from(r.data as Map);
        addresses.add({
          ..._address(
            '5d1f0c3e-0000-4000-8000-000000000009',
            '${body['label']}',
          ),
          ...body,
        });
        return (201, addresses.last);
      }
      return (200, addresses);
    };
    for (final a in addresses) {
      server.overrides['/v1/me/addresses/${a['id']}'] = (r) {
        if (r.method == 'DELETE') {
          addresses.removeWhere((x) => x['id'] == a['id']);
          return (204, null);
        }
        final body = Map<String, Object?>.from(r.data as Map);
        if (body['isDefault'] == true) {
          for (final x in addresses) {
            x['isDefault'] = x['id'] == a['id'];
          }
        }
        return (200, a);
      };
    }
    server.overrides['/v1/me/designs'] = (r) {
      if (r.method == 'POST') {
        final body = Map<String, Object?>.from(r.data as Map);
        designs.add({...designs.first, 'id': 'new', 'name': body['name']});
        return (201, designs.last);
      }
      return (200, designs);
    };
    server.overrides['/v1/me/occasions'] = (r) {
      if (r.method == 'POST') {
        final body = Map<String, Object?>.from(r.data as Map);
        occasions.add({
          ...body,
          'id': '7f3f0c3e-0000-4000-8000-000000000009',
          'next': '2027-01-05',
          'daysLeft': 55,
        });
        return (201, occasions.last);
      }
      return (200, occasions);
    };
    server.overrides['/v1/me'] = (r) {
      if (r.method == 'DELETE') {
        deleted = true;
        return (204, null);
      }
      if (r.method == 'PATCH') {
        user = {...user, ...Map<String, Object?>.from(r.data as Map)};
      }
      return (200, user);
    };
    server.overrides['/v1/me/export'] = (_) =>
        (200, {'profile': user, 'addresses': addresses, 'orders': <Object>[]});
    server.overrides['/v1/me/orders'] = (_) => (200, <Object>[]);
    return server;
  }
}

Future<TestHarness> _openAccount(
  WidgetTester tester,
  _Account account, {
  String route = '/account',
  List<Object> overrides = const [],
}) async {
  _tall(tester);
  final t = await pumpTestApp(
    tester,
    server: account.server(),
    storedSession: Session.fromAuth(testSession()).toJson(),
    overrides: overrides.cast(),
  );
  t.container.read(routerProvider).go(route);
  await _settle(tester);
  return t;
}

class _CapturingSink implements AnalyticsSink {
  final events = <String>[];

  @override
  void log(String name, Map<String, Object> params) => events.add(name);
}

void main() {
  _testAccount('screen 28: the customer and what is kept for them', (
    tester,
  ) async {
    await _openAccount(tester, _Account());
    expect(find.text('سارة'), findsOneWidget);
    expect(find.text('+963 944 *** 456'), findsOneWidget);
    expect(find.text('لا طلب حالي'), findsOneWidget);
    expect(find.text('عناويني'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('بعد 9 أيام: عيد ميلاد ماما'), findsOneWidget);
    expect(find.text('الإعدادات واللغة والعملة'), findsOneWidget);
  });

  _testAccount('screen 29: the default first, outside the zones flagged, '
      'make default and delete (FR-ACC-04)', (tester) async {
    final account = _Account();
    final t = await _openAccount(tester, account, route: '/account/addresses');
    expect(find.text('البيت'), findsOneWidget);
    expect(find.text('افتراضي'), findsOneWidget);
    expect(find.text('أبو رمانة · 12 · 3'), findsOneWidget);
    expect(find.text('قرب الحديقة · اتصل قبل الوصول'), findsWidgets);
    expect(find.text('خارج مناطق التوصيل'), findsOneWidget);

    await tester.tap(find.byTooltip('تعديل').last);
    await tester.pumpAndSettle();
    await tapText(tester, 'اجعله الافتراضي');
    await _settle(tester);
    final put =
        t.server
                .to('/v1/me/addresses/5d1f0c3e-0000-4000-8000-000000000002')
                .single
                .data
            as Map;
    expect(put['isDefault'], isTrue);
    expect(put['label'], 'المزرعة');

    await tester.tap(find.byTooltip('تعديل').last);
    await tester.pumpAndSettle();
    await tapText(tester, 'حذف');
    expect(find.text('حذف العنوان «المزرعة»؟'), findsOneWidget);
    await tapText(tester, 'حذف', last: true);
    await _settle(tester);
    expect(account.addresses, hasLength(1));
  });

  _testAccount('a new saved address from the map, kept even outside the '
      'zones (screen 29)', (tester) async {
    final account = _Account();
    final t = await _openAccount(tester, account, route: '/account/addresses');
    await tapText(tester, 'إضافة عنوان جديد');
    await _settle(tester);
    expect(find.text('احفظ العنوان لطلباتي القادمة'), findsNothing);
    await tapText(tester, 'العمل');
    await tapText(tester, 'العنوان الافتراضي عند الطلب');
    await tapText(tester, 'حفظ');
    await _settle(tester);
    final body =
        t.server
                .to('/v1/me/addresses')
                .where((r) => r.method == 'POST')
                .single
                .data
            as Map;
    expect(body, containsPair('label', 'العمل'));
    expect(body, containsPair('isDefault', true));
    expect(find.text('عناويني'), findsWidgets);
  });

  _testAccount("screen 30: designs at today's prices, open in the designer "
      '(FR-DSG-12)', (tester) async {
    final t = await _openAccount(tester, _Account(), route: '/account/designs');
    expect(find.text('عيد ميلاد لين'), findsOneWidget);
    expect(find.text('18 وردة · ساتان بوردو'), findsOneWidget);
    expect(find.text('2,676 ل.س'), findsOneWidget);
    await tapText(tester, 'فتح');
    await _settle(tester);
    final spec = t.container.read(designerControllerProvider).value!.spec;
    expect(spec.flowers.map((f) => f.id), ['red_rose', 'white_gypsophila']);
    expect(find.text('الخطوة 2 من 4 · الورد والخضرة'), findsOneWidget);
  });

  _testAccount('screen 31: add an occasion, and design a bouquet for one '
      '(FR-ACC-07)', (tester) async {
    final account = _Account();
    final t = await _openAccount(tester, account, route: '/account/occasions');
    expect(find.text('عيد ميلاد ماما'), findsOneWidget);
    expect(find.text('20 تشرين الثاني · بعد 9 أيام'), findsOneWidget);
    expect(find.text('تذكير قبل 7 أيام'), findsOneWidget);

    await tapText(tester, 'حفظ المناسبة');
    expect(find.text('اكتب الاسم واختر التاريخ.'), findsOneWidget);

    await tester.enterText(fieldBelow('الشخص'), 'لين');
    await tapText(tester, 'تخرج');
    await tapText(tester, 'اختر التاريخ');
    // The picker's confirm button, whatever its label in this language.
    await tester.tap(
      find
          .descendant(
            of: find.byType(DatePickerDialog),
            matching: find.byType(TextButton),
          )
          .last,
    );
    await tester.pumpAndSettle();
    await tapText(tester, '3 أيام');
    await tapText(tester, 'حفظ المناسبة');
    await _settle(tester);
    final body =
        t.server
                .to('/v1/me/occasions')
                .where((r) => r.method == 'POST')
                .single
                .data
            as Map;
    expect(body, containsPair('person', 'لين'));
    expect(body, containsPair('type', 'GRADUATION'));
    expect(body, containsPair('remindDaysBefore', 3));
    expect(account.occasions, hasLength(2));

    await tapText(tester, 'صمّم باقة');
    await _settle(tester);
    expect(
      t.container.read(designerControllerProvider).value!.spec.occasion,
      'birthday',
    );
  });

  _testAccount('screen 33: notification switches save to the profile; order '
      'status stays on (FR-NTF-05)', (tester) async {
    final account = _Account();
    final t = await _openAccount(tester, account, route: '/account/settings');
    expect(find.text('لا يمكن إيقافها أثناء وجود طلب حالي'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('تذكير المناسبات'));
    await _settle(tester);
    expect(t.server.to('/v1/me').where((r) => r.method == 'PATCH').last.data, {
      'notifyOccasions': false,
    });
    expect(
      t.container.read(sessionControllerProvider).value!.user.notifyOccasions,
      isFalse,
    );
    await tester.tap(
      find.bySemanticsLabel('رسائل واتساب. تأكيد الطلب والتوصيل'),
    );
    await _settle(tester);
    expect(account.user['notifyWhatsapp'], isFalse);

    // Order status has no switch to turn off.
    final locked = find.bySemanticsLabel(
      'حالة الطلب. لا يمكن إيقافها أثناء وجود طلب حالي',
    );
    await tester.tap(locked);
    await _settle(tester);
    expect(
      t.server.to('/v1/me').where((r) => r.method == 'PATCH'),
      hasLength(2),
    );
  });

  _testAccount('screen 33: Arabic-Indic digits everywhere (FR-LOC-02)', (
    tester,
  ) async {
    final t = await _openAccount(
      tester,
      _Account(),
      route: '/account/settings',
    );
    await tapText(tester, '١، ٢، ٣');
    t.container.read(routerProvider).go('/account/designs');
    await _settle(tester);
    expect(find.text('٢٬٦٧٦ ل.س'), findsOneWidget);
    expect(
      t.server.to('/v1/me').where((r) => r.method == 'PATCH').single.data,
      {'numerals': 'arabic'},
    );
  });

  _testAccount('screen 33: export my data to share, and delete the account '
      '(FR-ACC-08)', (tester) async {
    final account = _Account();
    String? shared;
    final t = await _openAccount(
      tester,
      account,
      route: '/account/settings',
      overrides: [
        fileSharerProvider.overrideWithValue(
          (name, content) async => shared = '$name $content',
        ),
      ],
    );
    await tapText(tester, 'تصدير بياناتي');
    await _settle(tester);
    expect(shared, startsWith('belle-biens-my-data.json {'));
    expect(shared, contains('"addresses"'));
    expect(find.text('جُهّز ملف بياناتك'), findsOneWidget);

    await tapText(tester, 'حذف الحساب');
    expect(find.textContaining('بعد 30 يوماً'), findsOneWidget);
    await tapText(tester, 'احذف حسابي');
    await _settle(tester);
    expect(account.deleted, isTrue);
    expect(t.container.read(sessionControllerProvider).value, isNull);
    expect(t.tokens.value, isNull);
  });

  _testAccount('analytics only with consent (FR-ANL-01/02)', (tester) async {
    final sink = _CapturingSink();
    final t = await _openAccount(
      tester,
      _Account(),
      route: '/p/red-rose-bouquet',
      overrides: [analyticsSinkProvider.overrideWithValue(sink)],
    );
    expect(sink.events, isEmpty);

    t.container.read(routerProvider).go('/account/settings');
    await _settle(tester);
    await tester.tap(find.bySemanticsLabel('التحليلات وتحسين التطبيق'));
    await _settle(tester);
    expect(t.prefs.values['analytics.consent'], isTrue);

    t.container.read(routerProvider).go('/p/iced-rose-matcha-latte');
    await _settle(tester);
    expect(sink.events, ['product_view']);
  });

  _testAccount('the designer saves a design to my designs (FR-DSG-12)', (
    tester,
  ) async {
    final account = _Account();
    final t = await _openAccount(tester, account, route: '/designer');
    await t.container
        .read(designerControllerProvider.notifier)
        .startFrom(
          Map<String, Object?>.from(jsonDecode(jsonEncode(readmeSpec)) as Map),
        );
    await t.container
        .read(designerControllerProvider.notifier)
        .goTo(DesignerStep.cardAndPreview);
    await _settle(tester);
    await tapText(tester, 'احفظ في تصاميمي');
    await tester.enterText(fieldBelow('اسم التصميم'), 'لماما');
    await tapText(tester, 'حفظ', last: true);
    await _settle(tester);
    final body =
        t.server
                .to('/v1/me/designs')
                .where((r) => r.method == 'POST')
                .single
                .data
            as Map;
    expect(body['name'], 'لماما');
    expect((body['spec'] as Map)['size'], 'medium');
    expect(find.text('حُفظ التصميم في تصاميمي'), findsOneWidget);
  });

  for (final language in ['ar', 'en']) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('account screens fit 360 dp ($language, text x$scale)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 4000);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final t = await pumpTestApp(
          tester,
          language: language,
          server: _Account().server(),
          storedSession: Session.fromAuth(testSession()).toJson(),
        );
        final router = t.container.read(routerProvider);
        for (final route in [
          '/account',
          '/account/profile',
          '/account/addresses',
          '/account/addresses/new',
          '/account/designs',
          '/account/occasions',
          '/account/settings',
        ]) {
          router.go(route);
          await _settle(tester);
          expect(
            tester.takeException(),
            isNull,
            reason: '$route ($language, x$scale)',
          );
        }
        await tester.pump(const Duration(seconds: 1));
      });
    }
  }
}
