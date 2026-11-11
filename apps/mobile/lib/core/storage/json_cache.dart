import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// A saved server answer and when it was saved.
class CacheEntry {
  const new({required this.json, required this.savedAt});

  final Object? json;
  final DateTime savedAt;
}

/// Keeps the last catalog answers on the device, so browsing works without a
/// connection (plan 4.5, screen 39). Answers are plain JSON from the API.
abstract class JsonCache {
  Future<CacheEntry?> read(String key);
  Future<void> write(String key, Object? json, {required DateTime savedAt});

  /// Every saved entry whose key starts with [prefix] (offline search).
  Future<List<CacheEntry>> readAll(String prefix);
}

/// One file per key under the app support directory. Keys are hashed into
/// safe file names; the key itself is stored inside the file.
class FileJsonCache implements JsonCache {
  new({Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationSupportDirectory;

  final Future<Directory> Function() _directory;
  Directory? _dir;

  Future<Directory> _cacheDir() async {
    if (_dir != null) return _dir!;
    final dir = Directory('${(await _directory()).path}/catalog_cache');
    await dir.create(recursive: true);
    return _dir = dir;
  }

  static String _fileName(String key) =>
      base64Url.encode(utf8.encode(key)).replaceAll('=', '');

  @override
  Future<CacheEntry?> read(String key) async {
    final file = File('${(await _cacheDir()).path}/${_fileName(key)}.json');
    if (!file.existsSync()) return null;
    return _decode(await file.readAsString());
  }

  @override
  Future<void> write(
    String key,
    Object? json, {
    required DateTime savedAt,
  }) async {
    final dir = await _cacheDir();
    final file = File('${dir.path}/${_fileName(key)}.json');
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(
      jsonEncode({
        'key': key,
        'savedAt': savedAt.toUtc().toIso8601String(),
        'json': json,
      }),
    );
    // Write then rename, so a crash never leaves half a file.
    await tmp.rename(file.path);
  }

  @override
  Future<List<CacheEntry>> readAll(String prefix) async {
    final dir = await _cacheDir();
    final entries = <CacheEntry>[];
    await for (final file in dir.list()) {
      if (file is! File || !file.path.endsWith('.json')) continue;
      try {
        final raw = jsonDecode(await file.readAsString());
        if (raw is Map && (raw['key'] as String? ?? '').startsWith(prefix)) {
          entries.add(_fromMap(raw));
        }
      } on FormatException {
        // A damaged file is just a cache miss.
      }
    }
    return entries;
  }

  static CacheEntry? _decode(String text) {
    try {
      final raw = jsonDecode(text);
      return raw is Map ? _fromMap(raw) : null;
    } on FormatException {
      return null;
    }
  }

  static CacheEntry _fromMap(Map<Object?, Object?> raw) => CacheEntry(
    json: raw['json'],
    savedAt: DateTime.parse(raw['savedAt']! as String),
  );
}

/// For tests and as a fallback when the device storage is unavailable.
class MemoryJsonCache implements JsonCache {
  final Map<String, CacheEntry> entries = {};

  @override
  Future<CacheEntry?> read(String key) async => entries[key];

  @override
  Future<void> write(
    String key,
    Object? json, {
    required DateTime savedAt,
  }) async {
    // Round-trip through JSON so tests see exactly what a file would hold.
    entries[key] = CacheEntry(
      json: jsonDecode(jsonEncode(json)),
      savedAt: savedAt,
    );
  }

  @override
  Future<List<CacheEntry>> readAll(String prefix) async => [
    for (final MapEntry(:key, :value) in entries.entries)
      if (key.startsWith(prefix)) value,
  ];
}
