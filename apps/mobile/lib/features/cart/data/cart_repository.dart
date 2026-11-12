import 'dart:typed_data';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:dio/dio.dart';

/// The cart's server calls, and the copy kept on the phone (guests and
/// customers alike, so the cart survives a restart without a network).
class CartRepository {
  new(this._api, this._cache, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final BelleApi _api;
  final JsonCache _cache;
  final DateTime Function() _now;

  static const linesKey = 'cart:lines';
  static const _boxesKey = 'cart:boxes';

  CartLineInputDto _dto(CartLine line) =>
      CartLineInputDto.fromJson(line.toJson());

  Future<List<CartLine>> readLocal() async {
    final json = (await _cache.read(linesKey))?.json;
    if (json is! List) return const [];
    final lines = <CartLine>[];
    for (final item in json) {
      try {
        lines.add(CartLine.fromJson(Map<String, Object?>.from(item as Map)));
      } on Object {
        // A line from an older app version: dropped rather than crashing.
      }
    }
    return lines;
  }

  Future<void> saveLocal(List<CartLine> lines) => _cache.write(linesKey, [
    for (final l in lines) l.toJson(),
  ], savedAt: _now());

  Future<List<CartLine>> readAccount() async {
    final cart = await guardApi(_api.me.savedCartControllerGet);
    return [
      for (final l in cart.lines)
        CartLine.fromJson(Map<String, Object?>.from(l.toJson())),
    ];
  }

  Future<void> saveAccount(List<CartLine> lines) => guardApi(
    () => _api.me.savedCartControllerPut(
      body: SaveCartDto(lines: [for (final l in lines) _dto(l)]),
    ),
  );

  /// Prices the lines on the server (FR-CRT-05..08).
  /// With [zone], the zone's delivery fee is added (checkout, FR-CRT-08).
  Future<CartQuoteDto> quote(
    List<CartLine> lines, {
    String? coupon,
    String? zone,
  }) => guardApi(
    () => _api.cart.cartControllerQuote(
      body: CartQuoteRequestDto(
        lines: [for (final l in lines) _dto(l)],
        couponCode: coupon,
        zone: zone,
      ),
    ),
  );

  /// Box types and what goes in them (screen 19); saved for offline.
  Future<BoxCatalogDto> boxes() async {
    try {
      final boxes = await guardApi(_api.cart.cartControllerBoxes);
      await _cache.write(_boxesKey, boxes.toJson(), savedAt: _now());
      return boxes;
    } on ApiError catch (error) {
      final saved = (await _cache.read(_boxesKey))?.json;
      if (!error.isOffline || saved is! Map) rethrow;
      return BoxCatalogDto.fromJson(Map<String, Object?>.from(saved));
    }
  }

  /// A photo of the cake design wanted (FR-CKE-04).
  Future<String> uploadReference(Uint8List bytes, String filename) async {
    final result = await guardApi(
      () => _api.cart.cartControllerReferenceImage(
        file: MultipartFile.fromBytes(bytes, filename: filename),
      ),
    );
    return result.url;
  }
}
