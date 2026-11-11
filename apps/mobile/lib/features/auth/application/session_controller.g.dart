// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in customer, or null for a guest. Browsing and ordering work as a
/// guest (FR-CRT-04); an account adds saved addresses, designs and occasions.

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerProvider._();

/// The signed-in customer, or null for a guest. Browsing and ordering work as a
/// guest (FR-CRT-04); an account adds saved addresses, designs and occasions.
final class SessionControllerProvider
    extends $AsyncNotifierProvider<SessionController, Session?> {
  /// The signed-in customer, or null for a guest. Browsing and ordering work as a
  /// guest (FR-CRT-04); an account adds saved addresses, designs and occasions.
  SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  SessionController create() => SessionController();
}

String _$sessionControllerHash() => r'710c1da25eaa80f2cfa6dfbe0c2831f6e7839586';

/// The signed-in customer, or null for a guest. Browsing and ordering work as a
/// guest (FR-CRT-04); an account adds saved addresses, designs and occasions.

abstract class _$SessionController extends $AsyncNotifier<Session?> {
  FutureOr<Session?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Session?>, Session?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Session?>, Session?>,
              AsyncValue<Session?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
