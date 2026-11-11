import 'dart:async';

import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/network/interceptors.dart';
import 'package:belle_biens/features/auth/domain/session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_controller.g.dart';

/// The signed-in customer, or null for a guest. Browsing and ordering work as a
/// guest (FR-CRT-04); an account adds saved addresses, designs and occasions.
@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  Future<Session?> build() async {
    final stored = await ref.read(tokenStoreProvider).read();
    if (stored == null) return null;
    try {
      return Session.fromJson(stored);
    } on Object {
      // An unreadable session (old format, broken keystore) means signed out.
      await ref.read(tokenStoreProvider).clear();
      return null;
    }
  }

  Session? get current => state.value;

  Future<void> signedIn(AuthSessionDto dto) => _save(Session.fromAuth(dto));

  Future<void> updateUser(MeDto user) async {
    final session = current;
    if (session != null) await _save(session.copyWith(user: user));
  }

  /// Exchanges the refresh token. Returns the new access token, or null when
  /// it could not be refreshed. Only a definite "no" from the server signs the
  /// customer out; being offline keeps the session for the next try.
  Future<String?> refresh() async {
    final session = current;
    if (session == null) return null;
    try {
      final dto = await guardApi(
        () => ref
            .read(plainBelleApiProvider)
            .auth
            .authControllerRefresh(
              body: RefreshDto(refreshToken: session.refreshToken),
            ),
      );
      await signedIn(dto);
      return dto.accessToken;
    } on ApiError catch (error) {
      if (!error.isOffline) await _clear();
      return null;
    }
  }

  Future<void> signOut() async {
    final session = current;
    await _clear();
    if (session != null) {
      // Best effort: ending the server session must not block signing out.
      unawaited(
        guardApi(
          () => ref
              .read(plainBelleApiProvider)
              .auth
              .authControllerLogout(
                body: RefreshDto(refreshToken: session.refreshToken),
              ),
        ).then<void>((_) {}, onError: (_) {}),
      );
    }
  }

  Future<void> _save(Session session) async {
    await ref.read(tokenStoreProvider).write(session.toJson());
    state = AsyncData(session);
  }

  Future<void> _clear() async {
    await ref.read(tokenStoreProvider).clear();
    state = const AsyncData(null);
  }
}

/// Lets the HTTP layer read and refresh tokens without depending on widgets.
class SessionTokenAccess implements TokenAccess {
  new(this._ref);

  final Ref _ref;

  SessionController get _controller =>
      _ref.read(sessionControllerProvider.notifier);

  @override
  String? get accessToken => _controller.current?.accessToken;

  @override
  String? get refreshToken => _controller.current?.refreshToken;

  @override
  Future<String?> refresh() => _controller.refresh();
}
