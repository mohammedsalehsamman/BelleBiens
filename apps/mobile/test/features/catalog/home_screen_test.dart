import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('home shows the designer, today, cakes and the branch '
      '(screen 06)', (tester) async {
    final t = await pumpTestApp(tester);

    expect(find.text('صمّم باقتك على ذوقك'), findsOneWidget);
    expect(find.text('ورد وباقات'), findsWidgets);
    expect(find.text('ورد اليوم'), findsWidgets);
    expect(find.text('باقة الجوري الأحمر'), findsWidgets);
    expect(find.text('2,400 ل.س'), findsWidgets);
    expect(find.text(r'$20.00'), findsWidgets);
    expect(find.text('مفتوح الآن'), findsOneWidget);
    expect(t.server.to('/v1/home'), hasLength(1));

    await tester.scrollUntilVisible(
      find.text('Belle Biens · أبو رمانة'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('يومياً 10:00 – 24:00'), findsOneWidget);
  });
}
