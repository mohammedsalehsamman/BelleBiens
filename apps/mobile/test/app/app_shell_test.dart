import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

const _tabLabelsAr = ['الرئيسية', 'المتجر', 'صمّم باقتك', 'طلباتي', 'حسابي'];

void main() {
  testWidgets('the welcome screen comes first, once (screen 01)', (
    tester,
  ) async {
    final t = await pumpTestApp(tester, onboardingSeen: false);
    expect(find.text('أهلاً بك في Belle Biens'), findsOneWidget);

    await tester.ensureVisible(find.text('المتابعة كضيف'));
    await tester.tap(find.text('المتابعة كضيف'));
    await tester.pumpAndSettle();
    expect(t.prefs.values['onboarding.seen'], true);
    expect(find.text('صمّم باقتك على ذوقك'), findsOneWidget);
  });

  testWidgets('the language chosen on the welcome screen is kept '
      '(EI-UI-01, FR-LOC-01)', (tester) async {
    final t = await pumpTestApp(tester, onboardingSeen: false);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Belle Biens'), findsOneWidget);
    final context = tester.element(find.text('Welcome to Belle Biens'));
    expect(Directionality.of(context), TextDirection.ltr);
    expect(t.prefs.values['locale.language'], 'en');
  });

  testWidgets('starts in Arabic, laid out right to left (FR-LOC-01)', (
    tester,
  ) async {
    await pumpTestApp(tester);
    final context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.rtl);
    expect(Localizations.localeOf(context), const Locale('ar'));
    for (final label in _tabLabelsAr) {
      expect(find.text(label), findsWidgets, reason: label);
    }
  });

  testWidgets('a saved English choice is restored at start', (tester) async {
    await pumpTestApp(tester, language: 'en');
    expect(find.text('Shop'), findsWidgets);
  });

  testWidgets('switching language flips to left to right', (tester) async {
    final t = await pumpTestApp(tester);
    t.container.read(appLocaleProvider.notifier).select(const Locale('en'));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.ltr);
    expect(find.text('Shop'), findsWidgets);
  });

  testWidgets('tabs navigate and keep the bottom bar', (tester) async {
    await pumpTestApp(tester);
    await tester.tap(find.text('طلباتي').last);
    await tester.pumpAndSettle();
    // A guest with no orders yet: the empty list and the lookup (screen 26).
    expect(find.text('طلبت كضيف؟'), findsOneWidget);

    await tester.tap(find.text('صمّم باقتك').last);
    await tester.pumpAndSettle();
    expect(find.text('الخطوة 1 من 4 · المناسبة والحجم'), findsOneWidget);
  });

  testWidgets('shows the environment badge outside production', (tester) async {
    await pumpTestApp(tester);
    expect(find.text('بيئة: dev'), findsOneWidget);
  });

  testWidgets('screens meet tap target and label guidelines (NFR-INT-03)', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpTestApp(tester, onboardingSeen: false);
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

    await tester.ensureVisible(find.text('تسجيل الدخول'));
    await tester.tap(find.text('تسجيل الدخول'));
    await tester.pumpAndSettle();
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });

  for (final language in ['ar', 'en']) {
    testWidgets('no overflow at 360 dp wide, large text ($language) '
        '(NFR-INT-04, NFR-INT-02)', (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await pumpTestApp(tester, onboardingSeen: false, language: language);
      expect(tester.takeException(), isNull);

      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -3000),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
