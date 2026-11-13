import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/text/digits.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sypMinorToUsdCents (FR-PAY-05, half up like the server)', () {
    test(r'README cart: 7,266 SYP at 120 is $60.55', () {
      expect(sypMinorToUsdCents(726600, '120'), 6055);
    });

    test('prices from the screens', () {
      expect(sypMinorToUsdCents(240000, '120'), 2000);
      expect(sypMinorToUsdCents(54000, '120'), 450);
    });

    test('rounds half up', () {
      // 150 / 120 = 1.25 cents -> 1; 180 / 120 = 1.5 -> 2.
      expect(sypMinorToUsdCents(150, '120'), 1);
      expect(sypMinorToUsdCents(180, '120'), 2);
    });

    test('decimal rates are exact', () {
      // 239 pounds at 119.5 = $2.00 exactly.
      expect(sypMinorToUsdCents(23900, '119.5'), 200);
    });

    test('refuses a zero rate', () {
      expect(() => sypMinorToUsdCents(100, '0'), throwsArgumentError);
    });
  });

  group('MoneyFormat', () {
    const money = MoneyFormat(usdRate: '120');

    test('groups pounds like the screens', () {
      expect(money.syp(240000), '2,400 ل.س');
      expect(money.syp(12000), '120 ل.س');
      expect(money.syp(12050), '120.50 ل.س');
      expect(money.usd(240000), r'$20.00');
    });

    test('the switch picks which currency comes first', () {
      const usd = MoneyFormat(usdRate: '120', currency: DisplayCurrency.usd);
      expect(usd.primary(240000), r'$20.00');
      expect(usd.secondary(240000), '2,400 ل.س');
      expect(money.primary(240000), '2,400 ل.س');
    });

    test('Arabic-Indic digits as a setting (FR-LOC-02)', () {
      const arabic = MoneyFormat(usdRate: '120', numerals: Numerals.arabic);
      expect(arabic.syp(240000), '٢٬٤٠٠ ل.س');
      expect(arabic.count(120), '١٢٠');
    });

    test('price changes stay left to right inside Arabic', () {
      expect(money.change(12000), '\u2066+120\u2069');
      expect(money.change(-6000), '\u2066\u221260\u2069');
    });

    test('English shows SYP', () {
      const en = MoneyFormat(usdRate: '120', sypSymbol: 'SYP');
      expect(en.syp(54000), '540 SYP');
    });
  });
}
