import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/core/text/arabic_normalize.dart';
import 'package:flutter/foundation.dart';

/// A catalog answer, and whether it came from the device because the network
/// failed (screen 39 shows the "offline" bar then).
class Cached<T> {
  const new(this.data, {this.offline = false, this.savedAt});

  final T data;
  final bool offline;
  final DateTime? savedAt;
}

/// Filters and sorting for the shop (screens 07, 09).
@immutable
class ProductQuery {
  const new({
    this.category,
    this.occasion,
    this.colors = const {},
    this.flowerTypes = const {},
    this.minPrice,
    this.maxPrice,
    this.availableToday = false,
    this.deliverableToday = false,
    this.sort = ProductSort.popular,
  });

  final String? category;
  final String? occasion;
  final Set<String> colors;
  final Set<String> flowerTypes;
  final int? minPrice;
  final int? maxPrice;
  final bool availableToday;
  final bool deliverableToday;
  final ProductSort sort;

  /// Filters chosen in the sheet (screen 09), shown as "الفلاتر · 2".
  /// Category and sorting have their own controls and do not count.
  int get filterCount =>
      (occasion == null ? 0 : 1) +
      colors.length +
      flowerTypes.length +
      (minPrice == null && maxPrice == null ? 0 : 1) +
      (availableToday ? 1 : 0) +
      (deliverableToday ? 1 : 0);

  ProductQuery copyWith({
    String? Function()? category,
    String? Function()? occasion,
    Set<String>? colors,
    Set<String>? flowerTypes,
    int? Function()? minPrice,
    int? Function()? maxPrice,
    bool? availableToday,
    bool? deliverableToday,
    ProductSort? sort,
  }) => ProductQuery(
    category: category == null ? this.category : category(),
    occasion: occasion == null ? this.occasion : occasion(),
    colors: colors ?? this.colors,
    flowerTypes: flowerTypes ?? this.flowerTypes,
    minPrice: minPrice == null ? this.minPrice : minPrice(),
    maxPrice: maxPrice == null ? this.maxPrice : maxPrice(),
    availableToday: availableToday ?? this.availableToday,
    deliverableToday: deliverableToday ?? this.deliverableToday,
    sort: sort ?? this.sort,
  );

  /// Clears the sheet's filters, keeping category and sorting.
  ProductQuery clearFilters() => ProductQuery(category: category, sort: sort);

  /// A stable cache key: the same filters always give the same key.
  String get key {
    String list(Set<String> s) => (s.toList()..sort()).join(',');
    return [
      'c=${category ?? ''}',
      'o=${occasion ?? ''}',
      'col=${list(colors)}',
      'f=${list(flowerTypes)}',
      'min=${minPrice ?? ''}',
      'max=${maxPrice ?? ''}',
      'a=$availableToday',
      'd=$deliverableToday',
      's=${sort.name}',
    ].join('&');
  }

  @override
  bool operator ==(Object other) => other is ProductQuery && other.key == key;

  @override
  int get hashCode => key.hashCode;
}

/// Reads the catalog from the API and keeps the last answers on the device.
/// Network first; when there is no network, the saved copy (NFR-REL-05,
/// plan 4.5). Server errors (404, 400) are never hidden behind the cache.
class CatalogRepository {
  new(this._api, this._cache, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final BelleApi _api;
  final JsonCache _cache;
  final DateTime Function() _now;

  static const pageSize = 20;

  Future<Cached<T>> _cached<T>(
    String key,
    Future<T> Function() fetch,
    T Function(Map<String, Object?> json) fromJson,
    Map<String, Object?> Function(T value) toJson,
  ) async {
    try {
      final value = await guardApi(fetch);
      await _cache.write(key, toJson(value), savedAt: _now());
      return Cached(value);
    } on ApiError catch (error) {
      if (!error.isOffline) rethrow;
      final saved = await _cache.read(key);
      if (saved == null || saved.json is! Map) rethrow;
      return Cached(
        fromJson(Map<String, Object?>.from(saved.json! as Map)),
        offline: true,
        savedAt: saved.savedAt,
      );
    }
  }

  Future<Cached<HomeDto>> home() => _cached(
    'home',
    _api.catalog.catalogControllerHome,
    HomeDto.fromJson,
    (v) => v.toJson(),
  );

  Future<Cached<ProductPageDto>> products(ProductQuery query, {int page = 1}) =>
      _cached(
        'products:${query.key}&p=$page',
        () => _api.catalog.catalogControllerProducts(
          category: query.category,
          occasion: query.occasion,
          colors: query.colors.isEmpty ? null : query.colors.toList(),
          flowerTypes: query.flowerTypes.isEmpty
              ? null
              : query.flowerTypes.toList(),
          minPrice: query.minPrice,
          maxPrice: query.maxPrice,
          availableToday: query.availableToday ? true : null,
          deliverableToday: query.deliverableToday ? true : null,
          sort: CatalogControllerProductsSort.fromJson(query.sort.toJson()),
          page: page,
          pageSize: pageSize,
        ),
        ProductPageDto.fromJson,
        (v) => v.toJson(),
      );

  /// How many products match, for the "عرض 7 منتجات" button (screen 09).
  /// Not cached: without a network the button just says "show results".
  Future<int> count(ProductQuery query) async {
    final page = await guardApi(
      () => _api.catalog.catalogControllerProducts(
        category: query.category,
        occasion: query.occasion,
        colors: query.colors.isEmpty ? null : query.colors.toList(),
        flowerTypes: query.flowerTypes.isEmpty
            ? null
            : query.flowerTypes.toList(),
        minPrice: query.minPrice,
        maxPrice: query.maxPrice,
        availableToday: query.availableToday ? true : null,
        deliverableToday: query.deliverableToday ? true : null,
        pageSize: 0,
      ),
    );
    return page.total;
  }

  Future<Cached<ProductDetailDto>> product(String slug) => _cached(
    'product:$slug',
    () => _api.catalog.catalogControllerProduct(slug: slug),
    ProductDetailDto.fromJson,
    (v) => v.toJson(),
  );

  Future<Cached<DailyFlowersDto>> dailyFlowers() => _cached(
    'daily',
    _api.catalog.catalogControllerDailyFlowers,
    DailyFlowersDto.fromJson,
    (v) => v.toJson(),
  );

  Future<Cached<OccasionPageDto>> occasion(String slug) => _cached(
    'occasion:$slug',
    () => _api.catalog.catalogControllerOccasion(slug: slug),
    OccasionPageDto.fromJson,
    (v) => v.toJson(),
  );

  Future<Cached<CatalogFiltersDto>> filters() => _cached(
    'filters',
    _api.catalog.catalogControllerFilters,
    CatalogFiltersDto.fromJson,
    (v) => v.toJson(),
  );

  Future<Cached<BranchDto>> branch() => _cached(
    'branch',
    _api.catalog.catalogControllerBranch,
    BranchDto.fromJson,
    (v) => v.toJson(),
  );

  Future<Cached<PageDto>> page(String slug) => _cached(
    'page:$slug',
    () => _api.catalog.catalogControllerPage(slug: slug),
    PageDto.fromJson,
    (v) => v.toJson(),
  );

  /// Server search (FR-CAT-04). Offline, the same Arabic rules run over every
  /// product saved on the device, so a customer can still find what they saw.
  Future<Cached<SearchResultDto>> search(String query) async {
    try {
      final result = await guardApi(
        () => _api.catalog.catalogControllerSearch(q: query),
      );
      return Cached(result);
    } on ApiError catch (error) {
      if (!error.isOffline) rethrow;
      return Cached(await _searchSaved(query), offline: true);
    }
  }

  Future<SearchResultDto> _searchSaved(String query) async {
    final cards = <String, ProductCardDto>{};
    void add(Object? json) {
      if (json is! Map) return;
      final card = ProductCardDto.fromJson(Map<String, Object?>.from(json));
      cards.putIfAbsent(card.slug, () => card);
    }

    for (final entry in await _cache.readAll('products:')) {
      final items = (entry.json as Map?)?['items'];
      if (items is List) items.forEach(add);
    }
    final home = (await _cache.read('home'))?.json as Map?;
    if (home != null) {
      for (final section in ['today', 'cakes']) {
        final items = home[section];
        if (items is List) items.forEach(add);
      }
    }
    final matches = cards.values
        .where(
          (c) => matchesQuery(query, [
            c.name.ar,
            c.name.en,
            c.subtitle.ar,
            c.subtitle.en,
          ]),
        )
        .toList();
    final counts = <String, int>{};
    for (final c in matches) {
      counts[c.categorySlug] = (counts[c.categorySlug] ?? 0) + 1;
    }
    return SearchResultDto(
      query: query,
      total: matches.length,
      facets: [
        for (final MapEntry(:key, :value) in counts.entries)
          SearchFacetDto(
            categorySlug: key,
            name: LocalizedTextDto(ar: key, en: key),
            count: value,
          ),
      ],
      items: matches,
    );
  }

  Future<List<ProductCardDto>> favorites() =>
      guardApi(_api.me.favoritesControllerList);

  Future<void> setFavorite(String slug, {required bool favorite}) => guardApi(
    () => favorite
        ? _api.me.favoritesControllerAdd(slug: slug)
        : _api.me.favoritesControllerRemove(slug: slug),
  );
}
