import 'dart:typed_data';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/catalog/data/catalog_repository.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:dio/dio.dart';

/// The designer's server calls, and the draft kept on the phone (FR-DSG-11).
class DesignerRepository {
  new(this._api, this._cache, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final BelleApi _api;
  final JsonCache _cache;
  final DateTime Function() _now;

  static const _catalogKey = 'designer:catalog';
  static const draftKey = 'designer:draft';

  /// Items, today's stock and slots. Offline: the last saved copy, so a
  /// customer can keep designing; the quote then says what is really left.
  Future<Cached<DesignerCatalogDto>> catalog() async {
    try {
      final catalog = await guardApi(_api.designer.designerControllerCatalog);
      await _cache.write(_catalogKey, catalog.toJson(), savedAt: _now());
      return Cached(catalog);
    } on ApiError catch (error) {
      if (!error.isOffline) rethrow;
      final saved = await _cache.read(_catalogKey);
      if (saved == null || saved.json is! Map) rethrow;
      return Cached(
        DesignerCatalogDto.fromJson(
          Map<String, Object?>.from(saved.json! as Map),
        ),
        offline: true,
        savedAt: saved.savedAt,
      );
    }
  }

  /// The server's price and checks for a spec (FR-DSG-03/08).
  Future<DesignerQuoteDto> quote(BouquetSpec spec) => guardApi(
    () => _api.designer.designerControllerQuote(
      body: DesignerQuoteRequestDto(
        spec: DesignerQuoteRequestDtoSpec(additionalProperties: spec.toJson()),
      ),
    ),
  );

  /// Uploads the rendered preview and returns its address (FR-D2D-05).
  Future<String> uploadPreview(Uint8List png) async {
    final result = await guardApi(
      () => _api.designer.designerControllerPreviewImage(
        file: MultipartFile.fromBytes(png, filename: 'preview.png'),
      ),
    );
    return result.url;
  }

  Future<Map<String, Object?>?> readDraft() async {
    final saved = await _cache.read(draftKey);
    final json = saved?.json;
    return json is Map ? Map<String, Object?>.from(json) : null;
  }

  Future<void> saveDraft(Map<String, Object?> draft) =>
      _cache.write(draftKey, draft, savedAt: _now());
}
