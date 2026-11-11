# Belle Biens app (Flutter)

The customer app for Android 9+ and iOS 15+. Its 39 screens are designed in [docs/design/mobile-screens](../../docs/design/mobile-screens) (open `index.html`), and plan section 4.8 maps each screen to a route and a sprint.

## Run

```bash
flutter pub get
dart run build_runner build -d          # Riverpod and l10n code
flutter run --flavor dev --dart-define-from-file=env/dev.json
```

The dev flavor calls the API at `http://10.0.2.2:3000` (your machine, seen from the Android emulator; the generated client adds `/v1`). Load the catalog first: `pnpm --filter @belle/api seed`. The flavors are `dev`, `stg` and `prod`; iOS has no flavors yet (ADR 0009).

## Layout

```
lib/
  main.dart            reads env, starts Sentry when a DSN is given
  app/                 app widget, env, router (5-tab shell), theme tokens, l10n (ar is the template)
  core/                shared code: API client and network, storage (secure tokens, JSON cache),
                       money, Arabic search text, design-system widgets, links to other apps
  features/<feature>/  data / domain / presentation, added sprint by sprint
test/                  unit, widget and golden tests (goldens: flutter test --update-goldens --tags golden)
  fixtures/catalog/    real API answers from the seed, served by test/helpers/fixture_server.dart
integration_test/      end-to-end on a device against the local API
env/                   non-secret build settings per flavor
```

## Rules

- Every user-facing string goes in `lib/app/l10n/app_ar.arb` and `app_en.arb` (EI-UI-01).
- Colors, radii and spacing come from `lib/app/theme/tokens.dart`. Text pairs must stay at 4.5:1 or more; `test/app/theme_test.dart` checks this.
- Touch targets are at least 48 dp, and layouts must fit 360 dp without overflow. The widget tests check both.
- Directional icons mirror in Arabic; universal icons (search, cart, camera) do not (FR-LOC-01). Use `BBIcons.forward` / `BBIcons.back`, not left/right.
- Screen text from the API comes as `{ar, en}`; show it with `.of(context)` (ADR 0013).
- `test/features/catalog/catalog_layout_test.dart` opens every catalog route at 360 dp in both languages and at double text size. Add new routes to it.

## Test fixtures

When API responses change, record them again from the seeded local API:

```bash
bash tool/record_fixtures.sh      # API=http://localhost:3000/v1 by default
```

The script fixes the shop's open state so tests do not depend on the time of recording. The list of files and their paths is in `test/helpers/fixture_server.dart`.

## End-to-end on an emulator

Runs the real sign-in against the local API (`integration_test/sign_in_flow_test.dart`):

```bash
# terminal 1 (apps/api): every code becomes 4827, development only
OTP_FIXED_CODE=4827 pnpm start:dev
# terminal 2 (apps/mobile)
flutter emulators --launch flutter_emulator
flutter test integration_test/sign_in_flow_test.dart --flavor dev --dart-define-from-file=env/dev.json
```

The test build replaces the installed app; run `flutter run` again afterwards.

## Checks

```bash
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```
