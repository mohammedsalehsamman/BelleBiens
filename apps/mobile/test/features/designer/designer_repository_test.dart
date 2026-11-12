import 'dart:typed_data';

import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/designer/data/designer_repository.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixture_server.dart';

(DesignerRepository, FixtureServer, MemoryJsonCache) _repo() {
  final server = FixtureServer();
  final cache = MemoryJsonCache();
  final api = BelleApi(
    Dio(BaseOptions(baseUrl: 'http://api'))..httpClientAdapter = server,
  );
  return (DesignerRepository(api, cache), server, cache);
}

void main() {
  test('catalog: saved for offline, then served from the phone', () async {
    final (repo, server, _) = _repo();
    final fresh = await repo.catalog();
    expect(fresh.offline, isFalse);
    expect(fresh.data.items.map((i) => i.id), contains('red_rose'));

    server.offline = true;
    final saved = await repo.catalog();
    expect(saved.offline, isTrue);
    expect(saved.data.sizes, hasLength(4));
  });

  test('catalog offline with nothing saved is a network error', () async {
    final (repo, server, _) = _repo();
    server.offline = true;
    await expectLater(
      repo.catalog(),
      throwsA(isA<ApiError>().having((e) => e.isOffline, 'offline', true)),
    );
  });

  test('quote sends the spec as the schema wants it', () async {
    final (repo, server, _) = _repo();
    const spec = BouquetSpec(
      occasion: 'none',
      size: 'small',
      flowers: [SpecLine('red_rose', 8)],
      wrap: 'transparent',
      ribbon: 'satin_white',
    );
    final quote = await repo.quote(spec);
    expect(quote.lines.first.totalMinor, 72000);
    final body = server.to('/v1/designer/quote').single.data as Map;
    expect(body['spec'], spec.toJson());
  });

  test('preview upload returns the stored address', () async {
    final (repo, server, _) = _repo();
    final url = await repo.uploadPreview(Uint8List.fromList([1, 2, 3]));
    expect(url, 'https://media.test/previews/test.webp');
    expect(server.to('/v1/designer/preview-image').single.method, 'POST');
  });

  test('draft round trip', () async {
    final (repo, _, _) = _repo();
    expect(await repo.readDraft(), isNull);
    await repo.saveDraft({'step': 'flowers'});
    expect(await repo.readDraft(), {'step': 'flowers'});
  });
}
