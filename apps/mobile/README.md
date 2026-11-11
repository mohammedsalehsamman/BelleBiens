# Belle Biens app (Flutter)

The customer app for Android 9+ and iOS 15+. Its 39 screens are designed in [docs/design/mobile-screens](../../docs/design/mobile-screens) (open `index.html`), and plan section 4.8 maps each screen to a route and a sprint.

## Run

```bash
flutter pub get
dart run build_runner build -d          # Riverpod and l10n code
flutter run --flavor dev --dart-define-from-file=env/dev.json
```

The dev flavor calls the API at `http://10.0.2.2:3000/v1` (your machine, seen from the Android emulator). The flavors are `dev`, `stg` and `prod`; iOS has no flavors yet (ADR 0009).

## Layout

```
lib/
  main.dart            reads env, starts Sentry when a DSN is given
  app/                 app widget, env, router (5-tab shell), theme tokens, l10n (ar is the template)
  core/                shared code: a11y helpers, design-system widgets; later network, storage, money
  features/<feature>/  data / domain / presentation, added sprint by sprint
test/                  unit and widget tests (golden tests start in S1)
env/                   non-secret build settings per flavor
```

## Rules

- Every user-facing string goes in `lib/app/l10n/app_ar.arb` and `app_en.arb` (EI-UI-01).
- Colors, radii and spacing come from `lib/app/theme/tokens.dart`. Text pairs must stay at 4.5:1 or more; `test/app/theme_test.dart` checks this.
- Touch targets are at least 48 dp, and layouts must fit 360 dp without overflow. The widget tests check both.
- Directional icons mirror in Arabic; universal icons (search, cart, camera) do not (FR-LOC-01).

## Checks

```bash
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```
