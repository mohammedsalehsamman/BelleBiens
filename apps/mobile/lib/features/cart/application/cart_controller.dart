import 'dart:async';
import 'dart:convert';

import 'package:belle_biens/core/analytics/analytics.dart';
import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/cart/data/cart_repository.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) =>
      CartRepository(ref.watch(belleApiProvider), ref.watch(jsonCacheProvider)),
);

/// The cart (screens 19, 20, 35). Kept on the phone for everyone; for a
/// signed-in customer also on the server, and a guest cart joins the
/// account's at sign-in (FR-CRT-03).
class CartController extends AsyncNotifier<List<CartLine>> {
  CartRepository get _repo => ref.read(cartRepositoryProvider);

  bool get _signedIn => ref.read(sessionControllerProvider).value != null;

  @override
  Future<List<CartLine>> build() async {
    final session = await ref.watch(sessionControllerProvider.future);
    final local = await _repo.readLocal();
    if (session == null) return local;
    try {
      final merged = mergeCarts(await _repo.readAccount(), local);
      await _repo.saveLocal(merged);
      unawaited(_pushToAccount(merged));
      return merged;
    } on ApiError {
      // Offline: the phone's cart now, the account's next time.
      return local;
    }
  }

  Future<List<CartLine>> get _current async => state.value ?? await future;

  Future<void> _pushToAccount(List<CartLine> lines) async {
    if (!_signedIn) return;
    try {
      await _repo.saveAccount(lines);
    } on ApiError {
      // Kept on the phone; sent again with the next change.
    }
  }

  Future<void> _set(List<CartLine> lines) async {
    state = AsyncData(lines);
    await _repo.saveLocal(lines);
    unawaited(_pushToAccount(lines));
  }

  Future<void> add(CartLine line) async {
    await _set(addLine(await _current, line));
    ref.read(analyticsProvider).log(AnalyticsEvent.addToCart, {
      'kind': line.kind.name,
      'qty': line.qty,
    });
  }

  Future<void> setQty(String id, int qty) async {
    final lines = await _current;
    if (qty <= 0) return await remove(id);
    final clamped = qty.clamp(1, CartLine.maxQty);
    await _set(
      lines.map((l) => l.id == id ? l.copyWith(qty: clamped) : l).toList(),
    );
  }

  Future<void> remove(String id) async => await _set([
    for (final l in await _current)
      if (l.id != id) l,
  ]);

  /// Puts an edited design or box back in its place ("تعديل التصميم").
  Future<void> replace(String id, CartLine line) async {
    final lines = await _current;
    final index = lines.indexWhere((l) => l.id == id);
    if (index < 0) return await add(line);
    await _set([...lines]..[index] = line);
  }

  Future<void> clear() => _set(const []);
}

final cartControllerProvider =
    AsyncNotifierProvider<CartController, List<CartLine>>(CartController.new);

/// Pieces in the cart, for the badge and the capsule ("السلة · 4 قطع").
final cartCountProvider = Provider<int>(
  (ref) =>
      ref
          .watch(cartControllerProvider)
          .value
          ?.fold<int>(0, (s, l) => s + l.qty) ??
      0,
);

/// The coupon the customer typed (FR-CRT-07). Kept until they remove it.
class CouponController extends Notifier<String?> {
  @override
  String? build() => null;

  void apply(String? code) =>
      state = code == null || code.trim().isEmpty ? null : code.trim();
}

final couponProvider = NotifierProvider<CouponController, String?>(
  CouponController.new,
);

/// The key [cartQuoteProvider] uses: the lines, the coupon, and at checkout
/// the delivery zone whose fee is added.
String cartQuoteKey(List<CartLine> lines, String? coupon, {String? zone}) =>
    jsonEncode({
      'lines': [for (final l in lines) l.toJson()],
      'coupon': coupon,
      'zone': ?zone,
    });

/// The server's price for the cart, 400 ms after the last change; a newer
/// cart cancels an older request. Null for an empty cart.
final FutureProviderFamily<CartQuoteDto?, String> cartQuoteProvider =
    FutureProvider.autoDispose.family<CartQuoteDto?, String>((ref, key) async {
      final wait = Completer<bool>();
      final timer = Timer(
        const Duration(milliseconds: 400),
        () => wait.complete(true),
      );
      ref.onDispose(() {
        timer.cancel();
        if (!wait.isCompleted) wait.complete(false);
      });
      if (!await wait.future) return null;
      final request = jsonDecode(key) as Map<String, Object?>;
      final lines = [
        for (final l in request['lines']! as List)
          CartLine.fromJson(Map<String, Object?>.from(l as Map)),
      ];
      if (lines.isEmpty) return null;
      return await ref
          .read(cartRepositoryProvider)
          .quote(
            lines,
            coupon: request['coupon'] as String?,
            zone: request['zone'] as String?,
          );
    });

/// The quote for the cart as it is now.
final currentCartQuoteProvider = Provider<AsyncValue<CartQuoteDto?>>((ref) {
  final lines = ref.watch(cartControllerProvider).value ?? const [];
  return ref.watch(
    cartQuoteProvider(cartQuoteKey(lines, ref.watch(couponProvider))),
  );
});

final boxCatalogProvider = FutureProvider<BoxCatalogDto>(
  (ref) => ref.watch(cartRepositoryProvider).boxes(),
);
