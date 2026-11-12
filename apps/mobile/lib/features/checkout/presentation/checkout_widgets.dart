import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/time/date_text.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:flutter/material.dart';

/// "غداً 12:00 – 14:00", "اليوم 18:00 – 20:00" or "20 تشرين الثاني …".
String slotWhenText(
  AppLocalizations l10n,
  String locale, {
  required String date,
  required int inDays,
  required String start,
  required String end,
}) {
  final time = l10n.checkoutSlot(start, end);
  return switch (inDays) {
    0 => l10n.cartWhenToday(time),
    1 => l10n.cartWhenTomorrow(time),
    _ => l10n.cartWhenDate(dayText(locale, date), time),
  };
}

/// "11 تشرين الثاني" (the screens' Levantine month names).
String dayText(String locale, String date) => dayMonthText(locale, date);

/// "البيت · أبو رمانة".
String addressTitle(BuildContext context, String label, ZoneDto? zone) {
  final area = zone?.name.of(context);
  return [label, ?area].where((p) => p.isNotEmpty).join(' · ');
}

/// A section title as on screens 21 and 23 (".h3").
class CheckoutSection extends StatelessWidget {
  const new({required this.title, required this.child, super.key, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: BBText.h3),
            ),
          ),
          ?action,
        ],
      ),
      const SizedBox(height: BBSpacing.sm),
      child,
    ],
  );
}

/// One of "اليوم / غداً / تاريخ آخر" (screen 21).
class DayOption extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool selected;

  /// Null: not available.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: BBCard(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(
            horizontal: BBSpacing.sm,
            vertical: BBSpacing.gutter,
          ),
          color: selected ? BBColors.optionSelected : BBColors.surface,
          borderColor: selected ? BBColors.primary : BBColors.border,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: BBSizes.minTouch - 24),
            child: Column(
              children: [
                Text(
                  title,
                  style: BBText.small.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: BBText.xs.muted.merge(BBText.numeric),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A label with a switch on the far side ("اتصل قبل الوصول").
class ToggleRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(BBRadius.option),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
        child: Row(
          children: [
            Expanded(
              // The switch reads the label out; the text is for the eyes.
              child: ExcludeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: subtitle == null
                          ? BBText.small
                          : BBText.small.bold,
                    ),
                    if (subtitle != null)
                      Text(subtitle!, style: BBText.xs.muted),
                  ],
                ),
              ),
            ),
            const SizedBox(width: BBSpacing.sm),
            BBToggle(
              value: value,
              onChanged: onChanged,
              semanticLabel: subtitle == null ? label : '$label. $subtitle',
            ),
          ],
        ),
      ),
    ),
  );
}
