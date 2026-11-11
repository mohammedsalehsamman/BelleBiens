import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/catalog/data/catalog_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fixture_server.dart';

(CatalogRepository, FixtureServer, MemoryJsonCache) _repo() {
  final server = FixtureServer();
  final cache = MemoryJsonCache();
  final api = BelleApi(
    Dio(BaseOptions(baseUrl: 'http://api'))..httpClientAdapter = server,
  );
  return (
    CatalogRepository(api, cache, now: () => DateTime.utc(2026, 11, 11, 12)),
    server,
    cache,
  );
}

void main() {
  group('network first, saved copy offline (plan 4.5)', () {
    test('a fresh answer is saved', () async {
      final (repo, _, cache) = _repo();
      final home = await repo.home();
      expect(home.offline, isFalse);
      expect(home.data.categories, hasLength(4));
      expect(cache.entries.keys, contains('home'));
    });

    test('offline, the saved answer comes back marked offline', () async {
      final (repo, server, _) = _repo();
      await repo.home();
      server.offline = true;
      final home = await repo.home();
      expect(home.offline, isTrue);
      expect(home.savedAt, DateTime.utc(2026, 11, 11, 12));
      expect(home.data.today.first.name.ar, 'باقة الجوري الأحمر');
    });

    test('offline with nothing saved is a network error', () async {
      final (repo, server, _) = _repo();
      server.offline = true;
      await expectLater(
        repo.dailyFlowers(),
        throwsA(isA<ApiError>().having((e) => e.isOffline, 'offline', true)),
      );
    });

    test('server errors are not hidden behind the cache', () async {
      final (repo, _, _) = _repo();
      await expectLater(
        repo.product('no-such-product'),
        throwsA(isA<ApiError>().having((e) => e.code, 'code', 'NOT_FOUND')),
      );
    });
  });

  test('sends filters and sorting as query parameters (screen 09)', () async {
    final (repo, server, _) = _repo();
    await repo.products(
      const ProductQuery(
        category: 'flowers',
        colors: {'red', 'pink'},
        maxPrice: 250000,
        availableToday: true,
        sort: ProductSort.priceAsc,
      ),
      page: 2,
    );
    final query = server.to('/v1/products').single.uri.queryParametersAll;
    expect(query['category'], ['flowers']);
    expect(query['colors'], unorderedEquals(['red', 'pink']));
    expect(query['maxPrice'], ['250000']);
    expect(query['availableToday'], ['true']);
    expect(query['sort'], ['price_asc']);
    expect(query['page'], ['2']);
    expect(query.containsKey('deliverableToday'), isFalse);
  });

  test('count asks for no items', () async {
    final (repo, server, _) = _repo();
    server.overrides['/v1/products'] = (_) =>
        (200, {'items': <Object>[], 'total': 7, 'page': 1, 'pageSize': 0});
    expect(await repo.count(const ProductQuery(occasion: 'love')), 7);
    final sent = server.to('/v1/products').single.uri.queryParameters;
    expect(sent['pageSize'], '0');
  });

  test('offline search looks through saved products (FR-CAT-04)', () async {
    final (repo, server, _) = _repo();
    await repo.products(const ProductQuery());
    server.offline = true;
    final result = await repo.search('باقه الجوري');
    expect(result.offline, isTrue);
    expect(
      result.data.items.map((c) => c.slug),
      containsAll(['red-rose-bouquet', 'luxury-red-rose-bouquet']),
    );
    expect(result.data.facets.single.categorySlug, 'flowers');
  });

  group('ProductQuery', () {
    test('counts the sheet filters only', () {
      const q = ProductQuery(
        category: 'flowers',
        occasion: 'love',
        colors: {'red', 'pink'},
        minPrice: 1,
        deliverableToday: true,
      );
      expect(q.filterCount, 5);
      expect(q.clearFilters().filterCount, 0);
      expect(q.clearFilters().category, 'flowers');
    });

    test('the same filters give the same cache key', () {
      const a = ProductQuery(colors: {'red', 'pink'});
      const b = ProductQuery(colors: {'pink', 'red'});
      expect(a.key, b.key);
      expect(a, b);
    });
  });
}
