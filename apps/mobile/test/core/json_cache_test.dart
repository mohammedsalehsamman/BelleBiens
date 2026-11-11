import 'dart:io';

import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late FileJsonCache cache;
  final savedAt = DateTime.utc(2026, 11, 11, 12);

  setUp(() {
    dir = Directory.systemTemp.createTempSync('bb_cache_');
    cache = FileJsonCache(directory: () async => dir);
  });
  tearDown(() => dir.deleteSync(recursive: true));

  test('saves and reads back JSON with its time', () async {
    await cache.write('home', {'a': 1, 'ar': 'باقة'}, savedAt: savedAt);
    final entry = await cache.read('home');
    expect(entry!.json, {'a': 1, 'ar': 'باقة'});
    expect(entry.savedAt, savedAt);
  });

  test('a missing key is null; a damaged file is a miss', () async {
    expect(await cache.read('nothing'), isNull);
    await cache.write('home', {'a': 1}, savedAt: savedAt);
    Directory('${dir.path}/catalog_cache')
        .listSync()
        .whereType<File>()
        .single
        .writeAsStringSync('{not json');
    expect(await cache.read('home'), isNull);
  });

  test('keys with any characters are safe file names', () async {
    const key = 'products:c=&o=&col=red,pink&p=1';
    await cache.write(key, {'items': <Object>[]}, savedAt: savedAt);
    expect((await cache.read(key))!.json, {'items': <Object>[]});
  });

  test('readAll finds entries by key prefix', () async {
    await cache.write('products:a', {'n': 1}, savedAt: savedAt);
    await cache.write('products:b', {'n': 2}, savedAt: savedAt);
    await cache.write('home', {'n': 3}, savedAt: savedAt);
    final all = await cache.readAll('products:');
    expect(all.map((e) => (e.json! as Map)['n']), unorderedEquals([1, 2]));
  });

  test('writing again replaces the entry', () async {
    await cache.write('home', {'v': 1}, savedAt: savedAt);
    await cache.write('home', {'v': 2}, savedAt: savedAt);
    expect((await cache.read('home'))!.json, {'v': 2});
  });
}
