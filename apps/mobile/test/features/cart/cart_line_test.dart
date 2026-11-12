import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/cart_fixtures.dart';

void main() {
  CartLine latte(String id, {List<(String, String)> options = const []}) =>
      CartLine(
        id: id,
        kind: CartItemKind.product,
        qty: 1,
        product: ProductChoice(
          slug: 'iced-rose-matcha-latte',
          options: options,
        ),
      );

  test('the same product with the same choices adds to its quantity', () {
    var lines = addLine(const [], latte('a', options: [('milk', 'oat')]));
    lines = addLine(lines, latte('b', options: [('milk', 'oat')]));
    expect(lines, hasLength(1));
    expect(lines.single.qty, 2);
    expect(lines.single.id, 'a');
  });

  test('choice order does not matter; different choices are new lines', () {
    final a = latte('a', options: [('milk', 'oat'), ('ice', 'light')]);
    final b = latte('b', options: [('ice', 'light'), ('milk', 'oat')]);
    expect(addLine([a], b), hasLength(1));
    expect(addLine([a], latte('c')), hasLength(2));
  });

  test('a message on the cake makes it a different line', () {
    const plain = ProductChoice(slug: 'rose-pistachio-cake');
    const message = ProductChoice(
      slug: 'rose-pistachio-cake',
      inscription: 'مبروك',
    );
    expect(plain.sameAs(message), isFalse);
  });

  test('designs never merge; quantities stop at 50', () {
    final design = readmeCart.first;
    expect(addLine([design], design.copyWithId('x')), hasLength(2));
    final many = latte('a').copyWith(qty: 49);
    expect(addLine([many], latte('b').copyWith(qty: 5)).single.qty, 50);
  });

  test('JSON round trip, as POST /v1/cart/quote takes it', () {
    for (final line in readmeCart) {
      expect(CartLine.fromJson(line.toJson()), line);
    }
    expect(readmeCart[2].toJson()['product'], {
      'slug': 'rose-pistachio-cake',
      'options': [
        {'group': 'size', 'option': '22cm'},
        {'group': 'extras', 'option': 'birthday-candle'},
      ],
      'inscription': 'كل عام وأنت بخير',
    });
  });

  test("merging at sign-in keeps the account's lines and adds the phone's "
      '(FR-CRT-03)', () {
    final account = [
      latte('a', options: [('milk', 'oat')]),
    ];
    final phone = [
      latte('b', options: [('milk', 'oat')]),
      readmeCart.first,
      account.first,
    ];
    final merged = mergeCarts(account, phone);
    expect(merged.map((l) => l.id), ['a', 'l1']);
    expect(merged.first.qty, 2);
  });

  test('new ids are 32 hex characters and differ', () {
    final a = CartLine.newId();
    expect(a, matches(RegExp(r'^[0-9a-f]{32}$')));
    expect(CartLine.newId(), isNot(a));
  });
}

extension on CartLine {
  CartLine copyWithId(String id) => CartLine(
    id: id,
    kind: kind,
    qty: qty,
    product: product,
    spec: spec,
    previewUrl: previewUrl,
  );
}
