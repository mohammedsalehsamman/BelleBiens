import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

/// Every designer step lays out at 360 dp, in both languages, at normal and
/// double text size (NFR-INT-04), with the README bouquet in progress.
void main() {
  for (final language in ['ar', 'en']) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('designer steps fit 360 dp ($language, text x$scale)', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(360, 4000);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final t = await pumpTestApp(tester, language: language);
        await tapText(
          tester,
          language == 'ar' ? 'صمّم باقتك' : 'Design',
          last: true,
        );
        final controller = t.container.read(
          designerControllerProvider.notifier,
        );
        await controller.edit(
          (s) => s
              .withQty(SpecList.flowers, 'red_rose', 12)
              .withQty(SpecList.flowers, 'white_gypsophila', 6)
              .withQty(SpecList.greens, 'eucalyptus', 3)
              .withQty(SpecList.extras, 'teddy_bear_small', 1)
              .copyWith(cardMessage: () => 'كل عام وأنتِ أجمل يا لين'),
        );
        for (final step in DesignerStep.values) {
          await controller.goTo(step);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 450));
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${step.name} ($language, x$scale)',
          );
        }
        await tester.pump(const Duration(seconds: 1));
      });
    }
  }
}
