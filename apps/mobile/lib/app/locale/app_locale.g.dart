// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_locale.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The customer's chosen language, kept on the device. Switching it keeps the
/// cart and the bouquet in progress (EI-UI-01): both live in their own
/// providers, so only the widgets that read text rebuild.

@ProviderFor(AppLocale)
final appLocaleProvider = AppLocaleProvider._();

/// The customer's chosen language, kept on the device. Switching it keeps the
/// cart and the bouquet in progress (EI-UI-01): both live in their own
/// providers, so only the widgets that read text rebuild.
final class AppLocaleProvider extends $NotifierProvider<AppLocale, Locale> {
  /// The customer's chosen language, kept on the device. Switching it keeps the
  /// cart and the bouquet in progress (EI-UI-01): both live in their own
  /// providers, so only the widgets that read text rebuild.
  AppLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLocaleHash();

  @$internal
  @override
  AppLocale create() => AppLocale();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale>(value),
    );
  }
}

String _$appLocaleHash() => r'8ed2258ce8e0ec3e20a89d9e675d78b6f01c15d9';

/// The customer's chosen language, kept on the device. Switching it keeps the
/// cart and the bouquet in progress (EI-UI-01): both live in their own
/// providers, so only the widgets that read text rebuild.

abstract class _$AppLocale extends $Notifier<Locale> {
  Locale build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Locale, Locale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale, Locale>,
              Locale,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
