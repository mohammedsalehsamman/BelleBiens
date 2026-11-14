# Build environments

Pass one of these files with `--dart-define-from-file`, together with the matching Android flavor:

```bash
flutter run --flavor dev --dart-define-from-file=env/dev.json
flutter build appbundle --flavor prod --dart-define-from-file=env/prod.json
flutter build ipa --dart-define-from-file=env/prod.json   # iOS has no flavors yet (see docs/adr/0009)
```

Only non-secret values belong here (NFR-SEC-05). `SENTRY_DSN` is added by CI as an extra `--dart-define`.
The staging and production hosts are placeholders until the hosting provider is chosen (OI-04).

`UPDATE_URL` (optional) is where the "update the app" screen sends people when the API no longer serves their version (NFR-CMP-01). Without it, Android opens the app's Play Store page and iOS asks people to get the new version from the shop. Set it to the App Store page once the app is listed, or to a signed APK on the shop's site if Play is not reachable in Syria (plan section 9).
