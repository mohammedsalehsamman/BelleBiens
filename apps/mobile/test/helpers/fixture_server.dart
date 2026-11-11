import 'dart:convert';
import 'dart:io';

import 'package:belle_biens/core/launch/external_links.dart';
import 'package:dio/dio.dart';

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
  };

  static final _cache = <String, Object?>{};

  static Object? fixture(String name) => _cache.putIfAbsent(
    name,
    () =>
        jsonDecode(File('test/fixtures/catalog/$name.json').readAsStringSync()),
  );

  bool offline = false;
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
