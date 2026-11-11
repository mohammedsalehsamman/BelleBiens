import 'package:belle_biens/app/app.dart';
import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _devEnv = AppEnv(
  flavor: AppFlavor.dev,
  apiBaseUrl: Uri.parse('http://localhost:3000/v1'),
);

const _tabLabelsAr = ['الرئيسية', 'المتجر', 'صمّم باقتك', 'طلباتي', 'حسابي'];

Future<ProviderContainer> _pumpApp(WidgetTester tester) async {
  final container = ProviderContainer(
    overrides: [appEnvProvider.overrideWithValue(_devEnv)],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const BelleApp()),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('starts in Arabic, laid out right to left (FR-LOC-01)', (
    tester,
  ) async {
    await _pumpApp(tester);

    final context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.rtl);
    expect(Localizations.localeOf(context), const Locale('ar'));

    for (final label in _tabLabelsAr) {
      expect(find.text(label), findsWidgets, reason: label);
    }
  });

  testWidgets('switching to English flips to left to right (EI-UI-01)', (
    tester,
  ) async {
    final container = await _pumpApp(tester);

    container.read(appLocaleProvider.notifier).select(const Locale('en'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold).first);
    expect(Directionality.of(context), TextDirection.ltr);
    expect(find.text('Shop'), findsWidgets);
  });

  testWidgets('tabs navigate and keep the bottom bar', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('طلباتي').last);
    await tester.pumpAndSettle();
    expect(find.text('هذه الشاشة تُبنى في سبرنت S6.'), findsOneWidget);

    await tester.tap(find.text('صمّم باقتك').last);
    await tester.pumpAndSettle();
    expect(find.text('هذه الشاشة تُبنى في سبرنت S3.'), findsOneWidget);
  });

  testWidgets('shows the environment badge outside production', (tester) async {
    await _pumpApp(tester);
    expect(find.text('بيئة: dev'), findsOneWidget);
  });

  testWidgets('bottom bar meets tap target and label guidelines (NFR-INT-03)', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await _pumpApp(tester);

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('no overflow at 360 dp wide (NFR-INT-04)', (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await _pumpApp(tester);
    expect(tester.takeException(), isNull);
  });
}
