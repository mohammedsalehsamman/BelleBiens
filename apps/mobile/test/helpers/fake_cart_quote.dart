import 'fixture_server.dart';

/// A cart quote priced from the recorded fixtures the way the server prices
/// it: products from their option groups, designs from the designer catalog,
/// boxes from the box catalog; WELCOME10 takes 10%. Tests that need line
/// issues override the route instead.
Map<String, Object?> fakeCartQuote(Map<Object?, Object?> request) {
  final products = <String, Map<Object?, Object?>>{
    for (final name in ['product_bouquet', 'product_cake', 'product_drink'])
      (FixtureServer.fixture(name)! as Map)['slug']! as String:
          FixtureServer.fixture(name)! as Map,
  };
  final cards = <String, Map<Object?, Object?>>{
    for (final c
        in (FixtureServer.fixture('products')! as Map)['items'] as List)
      (c as Map)['slug']! as String: c,
  };
  final boxes = FixtureServer.fixture('cart/boxes')! as Map;
  final boxItems = {
    for (final i in boxes['items']! as List)
      (i as Map)['id']: i['unitPriceMinor']! as int,
  };

  final lines = <Map<String, Object?>>[];
  for (final raw in request['lines']! as List) {
    final line = raw as Map;
    final qty = line['qty']! as int;
    var unit = 0;
    var lead = 0;
    var title = {'ar': '', 'en': ''};
    var summary = <String>[];
    switch (line['kind']) {
      case 'product':
        final choice = line['product']! as Map;
        final slug = choice['slug']! as String;
        final chosen = [
          for (final o in choice['options']! as List)
            ((o as Map)['group'], o['option']),
        ];
        final detail = products[slug];
        if (detail != null) {
          unit = detail['priceMinor']! as int;
          for (final g in detail['optionGroups']! as List) {
            final group = g as Map;
            final options = (group['options']! as List)
                .cast<Map<Object?, Object?>>();
            final mine = options
                .where((o) => chosen.contains((group['key'], o['key'])))
                .toList();
            final picked = mine.isEmpty && group['selection'] == 'SINGLE'
                ? options.where((o) => o['isDefault'] == true).toList()
                : mine;
            for (final o in options.where((o) => o['isDefault'] == true)) {
              unit -= o['priceChangeMinor']! as int;
            }
            for (final o in picked) {
              unit += o['priceChangeMinor']! as int;
              summary.add((o['name']! as Map)['ar']! as String);
            }
          }
          lead = detail['leadTimeHours']! as int;
          title = Map<String, String>.from(detail['name']! as Map);
        } else {
          final card = cards[slug]!;
          unit = card['priceMinor']! as int;
          lead = card['leadTimeHours']! as int;
          title = Map<String, String>.from(card['name']! as Map);
        }
        if (choice['inscription'] != null) summary.add('رسالة على الكيك');
      case 'design':
        unit =
            FixtureServer.fakeQuote(line['spec']! as Map)['itemsMinor']! as int;
        title = {'ar': 'باقتك المصمّمة', 'en': 'Your designed bouquet'};
        summary = ['جوري أحمر 12'];
      case 'box':
        final spec = line['spec']! as Map;
        final type = (boxes['types']! as List)
            .cast<Map<Object?, Object?>>()
            .firstWhere((t) => t['id'] == spec['boxType']);
        unit = type['basePriceMinor']! as int;
        for (final c in spec['compartments']! as List) {
          for (final i in (c as Map)['items']! as List) {
            unit += boxItems[(i as Map)['id']]! * (i['qty']! as int);
          }
        }
        title = Map<String, String>.from(type['name']! as Map);
    }
    lines.add({
      'id': line['id'],
      'kind': line['kind'],
      'title': title,
      'summary': {'ar': summary.join(' · '), 'en': summary.join(' · ')},
      'imageUrl': line['previewUrl'],
      'unitPriceMinor': unit,
      'qty': qty,
      'totalMinor': unit * qty,
      'leadTimeHours': lead,
      'issues': <Object>[],
    });
  }

  final items = lines.fold<int>(0, (s, l) => s + (l['totalMinor']! as int));
  final code = (request['couponCode'] as String?)?.toUpperCase();
  final applied = code == 'WELCOME10';
  final discount = applied ? (items * 10 / 100).round() : 0;
  final lead = lines.fold<int>(
    0,
    (m, l) => (l['leadTimeHours']! as int) > m ? l['leadTimeHours']! as int : m,
  );
  Map<String, Object?> money(int Function(int) convert) => {
    'itemsMinor': convert(items),
    'assemblyFeeMinor': 0,
    'discountMinor': convert(discount),
    'deliveryFeeMinor': 0,
    'roundingAdjustmentMinor': 0,
    'totalMinor': convert(items) - convert(discount),
  };
  final inCart = {
    for (final l in request['lines']! as List)
      ((l as Map)['product'] as Map?)?['slug'],
  };
  return {
    'lines': lines,
    'syp': money((v) => v),
    'usd': money((v) => (v / 120).round()),
    'usdRate': '120',
    if (code != null)
      'coupon': {
        'code': code,
        'applied': applied,
        if (!applied) 'problem': 'NOT_FOUND',
        'minOrderMinor': 0,
      },
    'leadTimeHours': lead,
    'earliestAt': lead > 0
        ? '2026-11-12T15:00:00.000+03:00'
        : '2026-11-11T15:30:00.000+03:00',
    'earliestInDays': lead > 0 ? 1 : 0,
    'orderable': lines.isNotEmpty,
    'suggestions': [
      for (final slug in ['macarons-6', 'chocolate-box-16'])
        if (!inCart.contains(slug)) cards[slug],
    ],
  };
}
