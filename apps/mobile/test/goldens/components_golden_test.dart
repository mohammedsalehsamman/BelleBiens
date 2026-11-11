@Tags(['golden'])
// goldenTest registers the test synchronously; its Future is only for chaining.
// ignore_for_file: discarded_futures
library;

import 'package:alchemist/alchemist.dart';
import 'package:belle_biens/app/theme/bb_theme.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Design-system goldens in both directions. Compare them with the CSS of
/// docs/design/mobile-screens when a component changes; update on purpose
/// with: flutter test --update-goldens --tags golden
Widget _frame(TextDirection direction, Widget child) => Theme(
  data: BBTheme.light(),
  child: Directionality(
    textDirection: direction,
    child: Container(
      width: 360,
      color: const Color(0xFFFFF8F6),
      padding: const EdgeInsets.all(16),
      child: child,
    ),
  ),
);

Widget _column(List<Widget> children) => Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  mainAxisSize: MainAxisSize.min,
  children: [
    for (final child in children) ...[child, const SizedBox(height: 12)],
  ],
);

void main() {
  for (final (name, direction) in const [
    ('rtl', TextDirection.rtl),
    ('ltr', TextDirection.ltr),
  ]) {
    goldenTest(
      'buttons and links ($name)',
      fileName: 'buttons_$name',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'variants',
            child: _frame(
              direction,
              _column([
                BBButton(
                  label: 'إنشاء حساب',
                  trailing: BBIcons.forward,
                  expand: true,
                  onPressed: () {},
                ),
                BBButton(
                  label: 'تسجيل الدخول',
                  leading: BBIcons.user,
                  variant: BBButtonVariant.secondary,
                  expand: true,
                  onPressed: () {},
                ),
                BBButton(
                  label: 'واتساب',
                  leading: BBIcons.whatsapp,
                  variant: BBButtonVariant.soft,
                  onPressed: () {},
                ),
                BBButton(
                  label: 'أرسل للمحل',
                  leading: BBIcons.whatsapp,
                  variant: BBButtonVariant.whatsapp,
                  onPressed: () {},
                ),
                const BBButton(label: 'معطّل', onPressed: null),
                Row(
                  children: [
                    BBIconButton(
                      icon: BBIcons.back,
                      tooltip: 'رجوع',
                      onPressed: () {},
                    ),
                    BBIconButton(
                      icon: BBIcons.bag,
                      tooltip: 'السلة',
                      count: 4,
                      onPressed: () {},
                    ),
                    BBLink(label: 'عرض الكل', onPressed: () {}),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'inputs ($name)',
      fileName: 'inputs_$name',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'controls',
            child: _frame(
              direction,
              _column([
                const BBTextField(label: 'رقم الهاتف', hint: '0944 123 456'),
                const BBTextField(label: 'الاسم الكامل', error: 'اكتب اسمك.'),
                BBSegmented<int>(
                  segments: const [(0, 'رقم الهاتف'), (1, 'البريد')],
                  selected: 0,
                  onChanged: (_) {},
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    BBChip(label: 'ورد وباقات', selected: true, onTap: () {}),
                    BBChip(label: 'كيك', selected: false, onTap: () {}),
                    const BBChip(label: 'ممتلئ', selected: false, onTap: null),
                  ],
                ),
                BBOptionTile(
                  title: 'توصيل داخل دمشق',
                  subtitle: 'الرسوم حسب المنطقة',
                  selected: true,
                  onTap: () {},
                ),
                BBCheckbox(
                  value: true,
                  onChanged: (_) {},
                  label: const Text('أوافق على الشروط'),
                ),
                Row(
                  children: [
                    BBQtyStepper(
                      value: 6,
                      max: 6,
                      itemLabel: 'جيبسوفيلا',
                      onChanged: (_) {},
                    ),
                    const Spacer(),
                    BBToggle(
                      value: true,
                      semanticLabel: 'الإشعارات',
                      onChanged: (_) {},
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'surfaces ($name)',
      fileName: 'surfaces_$name',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'cards, notices, badges',
            child: _frame(
              direction,
              _column([
                const BBCard(
                  child: Row(
                    children: [
                      BBIconBox(BBIcons.flower),
                      SizedBox(width: 12),
                      Expanded(child: Text('صمّم باقتك بنفسك')),
                    ],
                  ),
                ),
                const BBNotice(text: 'قد تختلف الباقة النهائية قليلاً.'),
                const BBNotice(
                  text: 'داخل منطقة التوصيل',
                  tone: BBNoticeTone.ok,
                ),
                const BBNotice(
                  text: 'الكيك يحتاج 24 ساعة',
                  tone: BBNoticeTone.warn,
                ),
                const BBNotice(
                  text: 'الرمز غير صحيح',
                  tone: BBNoticeTone.error,
                ),
                const Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    BBBadge(label: 'ورد اليوم', tone: BBBadgeTone.sage),
                    BBBadge(label: 'متوفر اليوم فقط', tone: BBBadgeTone.amber),
                    BBBadge(label: 'جاهز', tone: BBBadgeTone.green),
                    BBBadge(label: 'نفد', tone: BBBadgeTone.red),
                  ],
                ),
                const BBStepsBar(
                  total: 4,
                  current: 2,
                  caption: 'الخطوة 2 من 4',
                ),
                const BBKvRow(
                  label: 'المجموع',
                  value: '7,266 ل.س',
                  total: true,
                ),
                BBCartCapsule(
                  title: 'السلة · 4 قطع',
                  total: '7,116 ل.س',
                  actionLabel: 'إتمام الطلب',
                  onTap: () {},
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
