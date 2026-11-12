import 'package:belle_biens/core/storage/json_cache.dart';
import 'package:belle_biens/features/cart/data/cart_repository.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';

/// The README bouquet (screen 18).
const readmeSpec = <String, Object?>{
  'schemaVersion': 1,
  'occasion': 'birthday',
  'size': 'medium',
  'flowers': [
    {'id': 'red_rose', 'qty': 12},
    {'id': 'white_gypsophila', 'qty': 6},
  ],
  'greens': [
    {'id': 'eucalyptus', 'qty': 3},
  ],
  'wrap': 'satin_bordeaux',
  'ribbon': 'satin_pink',
  'extras': [
    {'id': 'teddy_bear_small', 'qty': 1},
  ],
  'cardMessage': 'كل عام وأنتِ أجمل يا لين',
};

/// Screen 20: the design, two lattes and a 22 cm cake with a candle
/// (2,676 + 1,080 + 3,360 = 7,116 SYP).
const readmeCart = [
  CartLine(id: 'l1', kind: CartItemKind.design, qty: 1, spec: readmeSpec),
  CartLine(
    id: 'l2',
    kind: CartItemKind.product,
    qty: 2,
    product: ProductChoice(slug: 'iced-rose-matcha-latte'),
  ),
  CartLine(
    id: 'l3',
    kind: CartItemKind.product,
    qty: 1,
    product: ProductChoice(
      slug: 'rose-pistachio-cake',
      options: [('size', '22cm'), ('extras', 'birthday-candle')],
      inscription: 'كل عام وأنت بخير',
    ),
  ),
];

/// A phone cache that already holds [lines] in its cart.
MemoryJsonCache cacheWithCart(List<CartLine> lines) => MemoryJsonCache()
  ..entries[CartRepository.linesKey] = CacheEntry(
    json: [for (final l in lines) l.toJson()],
    savedAt: DateTime.utc(2026, 11, 11, 12),
  );
