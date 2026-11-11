# Build environments

Pass one of these files with `--dart-define-from-file`, together with the matching Android flavor:

```bash
flutter run --flavor dev --dart-define-from-file=env/dev.json
flutter build appbundle --flavor prod --dart-define-from-file=env/prod.json
flutter build ipa --dart-define-from-file=env/prod.json   # iOS has no flavors yet (see docs/adr/0009)
```

Only non-secret values belong here (NFR-SEC-05). `SENTRY_DSN` is added by CI as an extra `--dart-define`.
The staging and production hosts are placeholders until the hosting provider is chosen (OI-04).
