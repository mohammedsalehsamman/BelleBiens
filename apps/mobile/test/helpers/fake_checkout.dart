import 'fake_cart_quote.dart';
import 'fixture_server.dart';

// Delivery and order answers for checkout tests, the way the server gives
// them at 15:00 on 11 November 2026 (the API tests' clock): five slots a
// day, 16:00 tomorrow full, the cake's 24 hours pushing out earlier slots.

const testToday = '2026-11-11';
const _slots = [
  ('12:00', '14:00'),
  ('14:00', '16:00'),
  ('16:00', '18:00'),
  ('18:00', '20:00'),
  ('20:00', '22:00'),
];

String _date(int days) => DateTime.utc(
  2026,
  11,
  11,
).add(Duration(days: days)).toIso8601String().substring(0, 10);

/// The hour a cart with [lead] hours is ready, counted from today 15:00.
int _readyHour(String date, int lead) {
  final day = DateTime.parse('${date}T00:00:00Z');
  final ready = DateTime.utc(2026, 11, 11, 15).add(Duration(hours: lead));
  final hours = ready.difference(day).inHours;
  return hours < 0 ? 0 : hours;
}

List<Map<String, Object?>> fakeSlots(
  String date,
  int lead, {
  bool pickup = false,
  Set<String> full = const {},
}) {
  final ready = _readyHour(date, lead);
  return [
    for (final (start, end) in _slots)
      () {
        final hour = int.parse(start.substring(0, 2));
        final problem = hour < ready
            ? 'TOO_SOON'
            : (!pickup && full.contains('$date $start') ? 'FULL' : null);
        return {
          'start': start,
          'end': end,
          'available': problem == null,
          'problem': ?problem,
        };
      }(),
  ];
}

/// The slots taken in the fakes: tomorrow 16:00 (screen 21's "ممتلئ").
const defaultFullSlots = {'2026-11-12 16:00'};

Map<String, Object?> fakeCalendar(int lead, {bool pickup = false}) => {
  'leadTimeHours': lead,
  'windowDays': 60,
  'days': [
    for (var i = 0; i <= 60; i++)
      () {
        final date = _date(i);
        final slots = fakeSlots(
          date,
          lead,
          pickup: pickup,
          full: defaultFullSlots,
        );
        final open = slots.any((s) => s['available'] == true);
        return {
          'date': date,
          'inDays': i,
          'available': open,
          if (!open) 'problem': 'TOO_SOON',
        };
      }(),
  ],
};

List<Map<String, Object?>> get fakeZones =>
    (FixtureServer.fixture('delivery/zones')! as List)
        .cast<Map<String, Object?>>();

/// FR-DLV-01, as the server checks it (the seed's zones are boxes).
Map<String, Object?>? zoneAt(num latitude, num longitude) {
  for (final z in fakeZones) {
    final points = (z['polygon']! as List).cast<List<Object?>>();
    final lngs = points.map((p) => p[0]! as num);
    final lats = points.map((p) => p[1]! as num);
    if (longitude >= lngs.reduce((a, b) => a < b ? a : b) &&
        longitude <= lngs.reduce((a, b) => a > b ? a : b) &&
        latitude >= lats.reduce((a, b) => a < b ? a : b) &&
        latitude <= lats.reduce((a, b) => a > b ? a : b)) {
      return {
        for (final key in ['slug', 'name', 'feeMinor', 'eta']) key: z[key],
      };
    }
  }
  return null;
}

/// The zone's fee, as POST /v1/cart/quote adds it at checkout.
int zoneFee(String? slug) => slug == null
    ? 0
    : (fakeZones.firstWhere((z) => z['slug'] == slug)['feeMinor']! as int);

/// POST /v1/orders: the order the server would make from the request.
Map<String, Object?> fakeOrder(
  Map<Object?, Object?> body, {
  int number = 1001,
}) {
  final address = body['address'] as Map?;
  final zone = address == null
      ? null
      : zoneAt(address['latitude']! as num, address['longitude']! as num);
  final quote = fakeCartQuote({
    'lines': body['lines'],
    if (body['couponCode'] != null) 'couponCode': body['couponCode'],
    if (zone != null) 'zone': zone['slug'],
  });
  final syp = quote['syp']! as Map<String, Object?>;
  final slot = body['slot']! as Map;
  final start = slot['start']! as String;
  final end = _slots.firstWhere((s) => s.$1 == start).$2;
  final customer = body['customer']! as Map;
  final recipient = (body['recipient'] as Map?) ?? customer;
  return {
    'number': 'BB-$number',
    'status': 'NEW',
    'paymentStatus': 'PENDING',
    'paymentMethod': body['paymentMethod'],
    'fulfillment': body['fulfillment'],
    'createdAt': '2026-11-11T12:00:00.000Z',
    'recipient': {'name': recipient['name'], 'phone': recipient['phone']},
    'hideSender': body['hideSender'] ?? false,
    if (address != null)
      'address': {
        'latitude': address['latitude'],
        'longitude': address['longitude'],
        'label': address['label'] ?? '',
        'area': address['area'] ?? '',
        'landmark': address['landmark'] ?? '',
        'building': address['building'] ?? '',
        'floor': address['floor'] ?? '',
        'details': address['details'] ?? '',
      },
    'zone': ?zone,
    'slot': {'date': slot['date'], 'start': start, 'end': end},
    'callBeforeArrival': body['callBeforeArrival'] ?? false,
    'whatsappConfirm': body['whatsappConfirm'] ?? false,
    'notes': body['notes'] ?? '',
    'couponCode': ?body['couponCode'],
    'lines': [
      for (final (i, l) in (quote['lines']! as List).indexed)
        {
          'position': i + 1,
          'kind': (l as Map)['kind'],
          'title': l['title'],
          'summary': l['summary'],
          'qty': l['qty'],
          'unitPriceMinor': l['unitPriceMinor'],
          'totalMinor': l['totalMinor'],
        },
    ],
    'syp': syp,
    'totalUsdCents': (quote['usd']! as Map)['totalMinor'],
    'usdRate': '120',
    'canCancel': true,
    'history': [
      {'status': 'NEW', 'at': '2026-11-11T12:00:00.000Z'},
    ],
  };
}
