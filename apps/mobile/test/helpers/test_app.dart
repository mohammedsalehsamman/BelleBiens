import 'package:belle_biens/app/app.dart';
import 'package:belle_biens/app/bootstrap.dart';
import 'package:belle_biens/app/env.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/map/map_tiles.dart';
import 'package:belle_biens/core/media/image_picker.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/core/storage/token_store.dart';
import 'package:belle_biens/features/auth/data/auth_repository.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/notifications/notification_permission.dart';
import 'package:belle_biens/features/orders/application/orders_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'fixture_server.dart';

export 'fixture_server.dart';

class MockAuthRepository extends Mock implements AuthRepository;

class FakeNotificationPermission implements NotificationPermission {
  int requests = 0;

  @override
  Future<bool> request() async {
    requests += 1;
    return true;
  }
}

final testEnv = AppEnv(
  flavor: AppFlavor.dev,
  apiBaseUrl: Uri.parse('http://localhost:3000'),
);

/// Everything a widget test may want to inspect after pumping the app.
class TestHarness {
  new({
    required this.container,
    required this.prefs,
    required this.tokens,
    required this.auth,
    required this.permission,
    required this.server,
    required this.cache,
    required this.links,
  });

  final ProviderContainer container;
  final MemoryPreferencesBackend prefs;
  final MemoryTokenStore tokens;
  final MockAuthRepository auth;
  final FakeNotificationPermission permission;

  /// Serves catalog calls from test/fixtures/catalog.
  final FixtureServer server;
  final MemoryJsonCache cache;
  final FakeExternalLinks links;
}

/// Pumps the whole app with fakes: no network, no device storage.
Future<TestHarness> pumpTestApp(
  WidgetTester tester, {
  bool onboardingSeen = true,
  bool notificationsAsked = false,
  String? language,
  String? storedSession,
  FixtureServer? server,
  MemoryJsonCache? cache,
  Map<String, Object>? preferences,
  List<Override> overrides = const [],
}) async {
  final prefs = MemoryPreferencesBackend({
    AppPreferences.onboardingSeenKey: onboardingSeen,
    AppPreferences.notificationsAskedKey: notificationsAsked,
    AppPreferences.languageKey: ?language,
    ...?preferences,
  });
  final tokens = MemoryTokenStore()..value = storedSession;
  final auth = MockAuthRepository();
  final permission = FakeNotificationPermission();
  final fixtures = server ?? FixtureServer();
  final memory = cache ?? MemoryJsonCache();
  final links = FakeExternalLinks();
  final api = BelleApi(
    Dio(BaseOptions(baseUrl: 'http://localhost:3000'))
      ..httpClientAdapter = fixtures,
  );

  final container = ProviderContainer(
    retry: appRetry,
    overrides: [
      appEnvProvider.overrideWithValue(testEnv),
      appPreferencesProvider.overrideWithValue(AppPreferences(prefs)),
      appVersionProvider.overrideWithValue('1.0.0+1'),
      tokenStoreProvider.overrideWithValue(tokens),
      authRepositoryProvider.overrideWithValue(auth),
      notificationPermissionProvider.overrideWithValue(permission),
      belleApiProvider.overrideWithValue(api),
      jsonCacheProvider.overrideWithValue(memory),
      externalLinksProvider.overrideWithValue(links),
      // No map tiles: tests never reach the network.
      mapTilesProvider.overrideWithValue(null),
      // 15:05 in Damascus on 11 November 2026, as in the API tests.
      clockProvider.overrideWithValue(() => DateTime.utc(2026, 11, 11, 12, 5)),
      ...overrides,
      // A small photo instead of the gallery.
      imagePickerProvider.overrideWithValue(
        () async => (bytes: Uint8List.fromList([1, 2, 3]), name: 'cake.jpg'),
      ),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const BelleApp()),
  );
  await tester.pumpAndSettle();
  return TestHarness(
    container: container,
    prefs: prefs,
    tokens: tokens,
    auth: auth,
    permission: permission,
    server: fixtures,
    cache: memory,
    links: links,
  );
}

/// A server profile for tests.
MeDto testUser({
  String name = 'سارة',
  bool profileComplete = true,
  String phone = '+963944123456',
}) => MeDto(
  id: '7c1e1f8e-0000-4000-8000-000000000001',
  name: name,
  phone: phone,
  email: null,
  role: MeDtoRole.customer,
  language: MeDtoLanguage.ar,
  numerals: MeDtoNumerals.western,
  marketingOptIn: false,
  notifyOccasions: true,
  notifyWhatsapp: true,
  homeArea: null,
  termsAccepted: profileComplete,
  profileComplete: profileComplete,
  createdAt: DateTime.utc(2026, 11, 11),
);

AuthSessionDto testSession({MeDto? user, bool isNewUser = false}) =>
    AuthSessionDto(
      accessToken: 'access-1',
      accessTokenExpiresIn: 900,
      refreshToken: 'refresh-1',
      refreshTokenExpiresAt: DateTime.utc(2026, 12, 11),
      isNewUser: isNewUser,
      user: user ?? testUser(),
    );

OtpRequestedDto testOtpRequested({bool whatsapp = false}) => OtpRequestedDto(
  phone: '+963944123456',
  maskedPhone: '+963 944 *** 456',
  channel: whatsapp
      ? OtpRequestedDtoChannel.whatsapp
      : OtpRequestedDtoChannel.sms,
  codeLength: 4,
  expiresInSeconds: 300,
  resendAfterSeconds: 60,
);

/// Finds a field by its visible label (BBTextField puts the label above it).
Finder fieldBelow(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(Column)).first,
  matching: find.byType(EditableText),
);

/// Scrolls the text into view, taps it, and waits for the UI to settle.
Future<void> tapText(
  WidgetTester tester,
  String text, {
  bool last = false,
}) async {
  final finder = last ? find.text(text).last : find.text(text).first;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
