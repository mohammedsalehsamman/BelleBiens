import 'dart:async';
import 'dart:convert';

import 'package:belle_biens/app/locale/app_locale.dart';
import 'package:belle_biens/app/preferences.dart';
import 'package:belle_biens/core/api/api_providers.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/data/catalog_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// Device storage for catalog answers. Tests use MemoryJsonCache.
final jsonCacheProvider = Provider<JsonCache>((ref) => FileJsonCache());

final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => CatalogRepository(
    ref.watch(belleApiProvider),
    ref.watch(jsonCacheProvider),
  ),
);

/// `GET /v1/app/config`, kept on the device for the dollar rate offline.
final appConfigProvider = FutureProvider<AppConfigDto?>((ref) async {
  final api = ref.watch(belleApiProvider);
  final cache = ref.watch(jsonCacheProvider);
  try {
    final config = await guardApi(api.app.appConfigControllerAppConfig);
    await cache.write('app-config', config.toJson(), savedAt: DateTime.now());
    return config;
  } on ApiError {
    final saved = await cache.read('app-config');
    if (saved?.json is Map) {
      return AppConfigDto.fromJson(
        Map<String, Object?>.from(saved!.json! as Map),
      );
    }
    return null;
  }
});

/// README example rate, used only until the app has reached the server once.
const fallbackUsdRate = '120';

/// The ل.س / $ switch (screens 06, 07), remembered on the device.
class DisplayCurrencyController extends Notifier<DisplayCurrency> {
  @override
  DisplayCurrency build() {
    final saved = ref.read(appPreferencesProvider).displayCurrency;
    return saved == 'usd' ? DisplayCurrency.usd : DisplayCurrency.syp;
  }

  void select(DisplayCurrency currency) {
    state = currency;
    ref.read(appPreferencesProvider).setDisplayCurrency(currency.name).ignore();
  }
}

final displayCurrencyProvider =
    NotifierProvider<DisplayCurrencyController, DisplayCurrency>(
      DisplayCurrencyController.new,
    );

final moneyFormatProvider = Provider<MoneyFormat>((ref) {
  final rate = ref.watch(appConfigProvider).value?.currency.usdRate;
  final english = ref.watch(appLocaleProvider).languageCode == 'en';
  return MoneyFormat(
    usdRate: rate ?? fallbackUsdRate,
    numerals: ref.watch(appPreferencesProvider).numerals,
    currency: ref.watch(displayCurrencyProvider),
    sypSymbol: english ? 'SYP' : 'ل.س',
  );
});

final homeProvider = FutureProvider<Cached<HomeDto>>(
  (ref) => ref.watch(catalogRepositoryProvider).home(),
);

final FutureProviderFamily<Cached<ProductDetailDto>, String> productProvider =
    FutureProvider.autoDispose.family<Cached<ProductDetailDto>, String>(
      (ref, slug) => ref.watch(catalogRepositoryProvider).product(slug),
    );

final FutureProvider<Cached<DailyFlowersDto>> dailyFlowersProvider =
    FutureProvider.autoDispose(
      (ref) => ref.watch(catalogRepositoryProvider).dailyFlowers(),
    );

final FutureProviderFamily<Cached<OccasionPageDto>, String> occasionProvider =
    FutureProvider.autoDispose.family<Cached<OccasionPageDto>, String>(
      (ref, slug) => ref.watch(catalogRepositoryProvider).occasion(slug),
    );

final catalogFiltersProvider = FutureProvider<Cached<CatalogFiltersDto>>(
  (ref) => ref.watch(catalogRepositoryProvider).filters(),
);

final branchProvider = FutureProvider<Cached<BranchDto>>(
  (ref) => ref.watch(catalogRepositoryProvider).branch(),
);

final FutureProviderFamily<Cached<PageDto>, String> pageProvider =
    FutureProvider.autoDispose.family<Cached<PageDto>, String>(
      (ref, slug) => ref.watch(catalogRepositoryProvider).page(slug),
    );

/// The shop's filters and sorting (screens 07, 09).
class ShopQueryController extends Notifier<ProductQuery> {
  @override
  ProductQuery build() => const ProductQuery();

  // A setter would not fit: callers build the next query from the current one.
  // ignore: use_setters_to_change_properties
  void set(ProductQuery query) => state = query;

  void category(String? slug) => state = state.copyWith(category: () => slug);
}

final shopQueryProvider = NotifierProvider<ShopQueryController, ProductQuery>(
  ShopQueryController.new,
);

/// The shop grid: the first page, then more pages on "عرض المزيد".
class ShopProducts {
  const new({
    required this.items,
    required this.total,
    required this.page,
    this.offline = false,
    this.loadingMore = false,
  });

  final List<ProductCardDto> items;
  final int total;
  final int page;
  final bool offline;
  final bool loadingMore;

  bool get hasMore => items.length < total;

  ShopProducts copyWith({
    List<ProductCardDto>? items,
    int? page,
    bool? loadingMore,
  }) => ShopProducts(
    items: items ?? this.items,
    total: total,
    page: page ?? this.page,
    offline: offline,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}

class ShopProductsController extends AsyncNotifier<ShopProducts> {
  @override
  Future<ShopProducts> build() async {
    final query = ref.watch(shopQueryProvider);
    final first = await ref.read(catalogRepositoryProvider).products(query);
    return ShopProducts(
      items: first.data.items,
      total: first.data.total,
      page: 1,
      offline: first.offline,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await ref
          .read(catalogRepositoryProvider)
          .products(ref.read(shopQueryProvider), page: current.page + 1);
      state = AsyncData(
        current.copyWith(
          items: [...current.items, ...next.data.items],
          page: current.page + 1,
          loadingMore: false,
        ),
      );
    } on ApiError {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }
}

final shopProductsProvider =
    AsyncNotifierProvider<ShopProductsController, ShopProducts>(
      ShopProductsController.new,
    );

final FutureProviderFamily<Cached<SearchResultDto>, String> searchProvider =
    FutureProvider.autoDispose.family<Cached<SearchResultDto>, String>(
      (ref, query) => ref.watch(catalogRepositoryProvider).search(query),
    );

/// Recent searches on screen 08, newest first, kept on the device.
class RecentSearchesController extends Notifier<List<String>> {
  static const max = 8;

  @override
  List<String> build() {
    final raw = ref.read(appPreferencesProvider).recentSearches;
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List).cast<String>();
    } on Object {
      return const [];
    }
  }

  void add(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    _save([q, ...state.where((s) => s != q)].take(max).toList());
  }

  void clear() => _save(const []);

  void _save(List<String> next) {
    state = next;
    ref
        .read(appPreferencesProvider)
        .setRecentSearches(jsonEncode(next))
        .ignore();
  }
}

final recentSearchesProvider =
    NotifierProvider<RecentSearchesController, List<String>>(
      RecentSearchesController.new,
    );

/// Saved products (screen 32, FR-ACC-06). Empty for guests. Changes show at
/// once and roll back if the server refuses.
class FavoritesController extends AsyncNotifier<List<ProductCardDto>> {
  @override
  Future<List<ProductCardDto>> build() async {
    final session = await ref.watch(sessionControllerProvider.future);
    if (session == null) return const [];
    return await ref.read(catalogRepositoryProvider).favorites();
  }

  bool contains(String slug) =>
      state.value?.any((c) => c.slug == slug) ?? false;

  Future<void> toggle(ProductCardDto card) async {
    final before = state.value ?? const <ProductCardDto>[];
    final saving = !before.any((c) => c.slug == card.slug);
    state = AsyncData(
      saving
          ? [card, ...before]
          : before.where((c) => c.slug != card.slug).toList(),
    );
    try {
      await ref
          .read(catalogRepositoryProvider)
          .setFavorite(card.slug, favorite: saving);
    } on ApiError {
      state = AsyncData(before);
      rethrow;
    }
  }
}

final favoritesProvider =
    AsyncNotifierProvider<FavoritesController, List<ProductCardDto>>(
      FavoritesController.new,
    );

/// Waits [delay] after the last keystroke before searching (screen 08).
class Debouncer {
  new(this.delay);

  final Duration delay;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
