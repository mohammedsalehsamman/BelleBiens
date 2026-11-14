import 'package:belle_biens/app/router/router.dart';
import 'package:belle_biens/core/version/update_required.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_app.dart';

/// What the API answers an app it no longer serves (NFR-CMP-01).
(int, Object?) _tooOld(Object? _) => (
  426,
  {
    'type': 'https://errors.bellebiens.local/UPGRADE_REQUIRED',
    'title': 'حدّث التطبيق لتتابع.',
    'status': 426,
    'code': 'UPGRADE_REQUIRED',
    'minSupportedVersion': '1.2.0',
  },
);

void main() {
  testWidgets('a 426 from the server shows only the update screen, which '
      'opens the store (NFR-CMP-01)', (tester) async {
    final server = FixtureServer();
    server.overrides['/v1/home'] = _tooOld;
    final t = await pumpTestApp(
      tester,
      server: server,
      overrides: [isAndroidProvider.overrideWithValue(true)],
    );

    expect(find.text('يوجد إصدار أحدث من Belle Biens'), findsOneWidget);

    // No way around it: other routes come back here.
    t.container.read(routerProvider).go(Routes.cart);
    await tester.pumpAndSettle();
    expect(find.text('يوجد إصدار أحدث من Belle Biens'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('يوجد إصدار أحدث من Belle Biens'), findsOneWidget);

    await tester.tap(find.text('حدّث الآن'));
    expect(
      t.links.opened.single.toString(),
      'https://play.google.com/store/apps/details?id=com.bellebiens.app',
    );
  });

  testWidgets('without a store page the screen says to ask the shop', (
    tester,
  ) async {
    final server = FixtureServer();
    server.overrides['/v1/home'] = _tooOld;
    await pumpTestApp(
      tester,
      server: server,
      overrides: [isAndroidProvider.overrideWithValue(false)],
    );
    expect(find.text('اطلب رابط الإصدار الجديد من المحل.'), findsOneWidget);
    expect(find.text('حدّث الآن'), findsNothing);
  });

  testWidgets('other errors leave the app alone', (tester) async {
    final server = FixtureServer();
    server.overrides['/v1/home'] = (_) => (500, {'code': 'INTERNAL'});
    await pumpTestApp(tester, server: server);
    expect(find.text('يوجد إصدار أحدث من Belle Biens'), findsNothing);
    // Still the shell with its tabs.
    expect(find.text('الرئيسية'), findsOneWidget);
  });
}
