import 'dart:convert';
import 'dart:io';

import 'package:belle_biens/core/launch/external_links.dart';
import 'package:dio/dio.dart';

import 'fake_cart_quote.dart';

/// Answers API calls with responses recorded from the local API
/// (test/fixtures/catalog, made from the seed). Tests can override answers,
/// see what was asked, or go offline.
class FixtureServer implements HttpClientAdapter {
  new();

  /// Path (without query) to fixture file name, for GET requests.
  static const Map<String, String> routes = {
    '/v1/home': 'home',
    '/v1/products': 'products',
    '/v1/products/red-rose-bouquet': 'product_bouquet',
    '/v1/products/rose-pistachio-cake': 'product_cake',
    '/v1/products/iced-rose-matcha-latte': 'product_drink',
    '/v1/search': 'search',
    '/v1/daily-flowers': 'daily',
    '/v1/occasions/birthday': 'occasion',
    '/v1/catalog/filters': 'filters',
    '/v1/branch': 'branch',
    '/v1/pages/delivery': 'page',
    '/v1/app/config': 'app_config',
    '/v1/designer/catalog': 'designer/catalog',
    '/v1/boxes/catalog': 'cart/boxes',
  };

  static final _cache = <String, Object?>{};

  static Object? fixture(String name) => _cache.putIfAbsent(
    name,
    () => jsonDecode(
      File('test/fixtures/${name.contains('/') ? name : 'catalog/$name'}.json')
          .readAsStringSync(),
    ),
  );

  bool offline = false;

  /// What the fake account's saved cart holds (GET/PUT /v1/me/cart).
  List<Object?> savedCart = [];
  final requests = <RequestOptions>[];

  /// Custom answers by path: (status, body).
  final overrides = <String, (int, Object?) Function(RequestOptions)>{};

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (offline) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline (test)',
      );
    }
    final path = options.uri.path;
    if (path == '/v1/designer/preview-image') {
      return ResponseBody.fromString(
        jsonEncode({'url': 'https://media.test/previews/test.webp'}),
        201,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
    if (!overrides.containsKey(path)) {
      final fake = switch (path) {
        '/v1/cart/quote' => (
          200,
          fakeCartQuote(options.data as Map) as Object?,
        ),
        '/v1/me/cart' => (
          200,
          options.method == 'PUT'
              ? {...(options.data as Map), 'updatedAt': null}
              : {'lines': savedCart, 'updatedAt': null},
        ),
        '/v1/uploads/reference-image' => (
          201,
          {'url': 'https://media.test/references/test.webp'},
        ),
        _ => null,
      };
      if (fake != null) {
        if (path == '/v1/me/cart' && options.method == 'PUT') {
          savedCart = List<Object?>.from(
            (options.data as Map)['lines'] as List,
          );
        }
        return ResponseBody.fromString(
          jsonEncode(fake.$2),
          fake.$1,
          headers: {
            Headers.contentTypeHeader: ['application/json'],
          },
        );
      }
    }
    if (path == '/v1/designer/quote' && !overrides.containsKey(path)) {
      return ResponseBody.fromString(
        jsonEncode(fakeQuote((options.data as Map)['spec'] as Map)),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      );
    }
    final (status, body) =
        overrides[path]?.call(options) ??
        switch (routes[path]) {
          final String name => (200, fixture(name)),
          null => (
            404,
            {
              'type': 'https://errors.bellebiens.local/NOT_FOUND',
              'title': 'لم نجد ما تبحث عنه.',
              'status': 404,
              'code': 'NOT_FOUND',
            },
          ),
        };
    return ResponseBody.fromString(
      body == null ? '' : jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  /// A quote priced from the catalog fixture, like the server would, with no
  /// stock issues. Tests that need issues override the quote route.
  static Map<String, Object?> fakeQuote(Map<Object?, Object?> spec) {
    final items = {
      for (final i in (fixture('designer/catalog')! as Map)['items'] as List)
        (i as Map)['id']: i,
    };
    final lines = <Map<String, Object?>>[];
    void add(Object? id, int qty) {
      final item = items[id];
      if (item == null) return;
      final unit = item['unitPriceMinor']! as int;
      lines.add({
        'id': id,
        'type': item['type'],
        'name': item['name'],
        'qty': qty,
        'unitPriceMinor': unit,
        'totalMinor': unit * qty,
      });
    }

    for (final key in ['flowers', 'greens']) {
      for (final l in (spec[key] as List?) ?? const []) {
        add((l as Map)['id'], l['qty']! as int);
      }
    }
    add(spec['wrap'], 1);
    add(spec['ribbon'], 1);
    for (final l in (spec['extras'] as List?) ?? const []) {
      add((l as Map)['id'], l['qty']! as int);
    }
    final total = lines.fold<int>(0, (s, l) => s + (l['totalMinor']! as int));
    final stems = ((spec['flowers'] as List?) ?? const []).fold<int>(
      0,
      (s, l) => s + ((l as Map)['qty']! as int),
    );
    return {
      ...(fixture('designer/quote_readme')! as Map).cast<String, Object?>(),
      'stems': stems,
      'lines': lines,
      'itemsMinor': total,
      'assemblyFeeMinor': 0,
      'totalMinor': total,
      'totalUsdCents': (total / 120).round(),
      'issues': <Object>[],
      'orderable': true,
    };
  }

  /// Requests made to [path], newest last.
  List<RequestOptions> to(String path) =>
      requests.where((r) => r.uri.path == path).toList();

  @override
  void close({bool force = false}) {}
}

/// Records links instead of opening other apps.
class FakeExternalLinks implements ExternalLinks {
  final opened = <Uri>[];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return true;
  }
}
