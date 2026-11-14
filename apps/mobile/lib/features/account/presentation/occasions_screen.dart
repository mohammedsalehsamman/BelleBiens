import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/time/date_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/application/account_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String occasionTypeName(AppLocalizations l10n, OccasionType type) =>
    switch (type) {
      OccasionType.birthday => l10n.occasionBirthday,
      OccasionType.anniversary => l10n.occasionAnniversary,
      OccasionType.graduation => l10n.occasionGraduation,
      OccasionType.other => l10n.occasionOther,
    };

/// "اليوم", "غداً", "بعد 9 أيام".
String occasionCountdown(AppLocalizations l10n, int days) => switch (days) {
  0 => l10n.occasionsToday,
  1 => l10n.occasionsTomorrow,
  _ => l10n.occasionsInDays(days),
};

/// The catalog occasion a reminder opens the designer for (screen 11).
String? _designerOccasion(OccasionType type) => switch (type) {
  OccasionType.birthday => 'birthday',
  OccasionType.anniversary => 'love',
  OccasionType.graduation => 'graduation',
  OccasionType.other => null,
};

/// Screen 31: birthdays and anniversaries, reminded every year (FR-ACC-07).
class OccasionsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final occasions = ref.watch(myOccasionsProvider);

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.occasionsTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: switch (occasions) {
        AsyncValue(:final value?) => ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            if (value.isEmpty)
              BBNotice(text: l10n.occasionsEmpty, icon: BBIcons.calendar),
            for (final o in value) ...[
              _OccasionCard(occasion: o),
              const SizedBox(height: BBSpacing.gutter),
            ],
            const SizedBox(height: BBSpacing.sm),
            const _OccasionForm(),
            const SizedBox(height: BBSpacing.md),
            Text(
              l10n.occasionsNote,
              style: BBText.xs.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.lg),
          ],
        ),
        AsyncError(:final error) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(myOccasionsProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _OccasionCard extends ConsumerWidget {
  const new({required this.occasion});

  final OccasionReminderDto occasion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final o = occasion;
    final slug = _designerOccasion(o.type2);

    Future<void> remove() async {
      final messenger = ScaffoldMessenger.of(context);
      final sure = await confirmDialog(
        context,
        l10n.occasionsDeleteAsk(o.person),
        l10n.addressesDelete,
      );
      if (!sure) return;
      try {
        await ref.read(accountRepositoryProvider).deleteOccasion(o.id);
        ref.invalidate(myOccasionsProvider);
      } on Object catch (error) {
        messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
      }
    }

    return BBCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BBIconBox(BBIcons.gift, size: 40),
              const SizedBox(width: BBSpacing.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${occasionTypeName(l10n, o.type2)} ${o.person}',
                      style: BBText.bodyBold,
                    ),
                    Text(
                      l10n.occasionsWhen(
                        dayMonthText(locale, o.next),
                        occasionCountdown(l10n, o.daysLeft),
                      ),
                      style: BBText.small.muted.merge(BBText.numeric),
                    ),
                  ],
                ),
              ),
              BBIconButton(
                icon: BBIcons.trash,
                tooltip: l10n.addressesDelete,
                onPressed: remove,
              ),
            ],
          ),
          const SizedBox(height: BBSpacing.xs),
          BBBadge(
            label: l10n.occasionsRemind(o.remindDaysBefore),
            tone: BBBadgeTone.sage,
            icon: BBIcons.bell,
          ),
          const SizedBox(height: BBSpacing.sm),
          BBButton(
            label: l10n.occasionsDesign,
            leading: BBIcons.flower,
            small: true,
            onPressed: () async {
              final designer = ref.read(designerControllerProvider.notifier);
              if (slug != null) await designer.startForOccasion(slug);
              if (context.mounted) context.go(Routes.designer);
            },
          ),
        ],
      ),
    );
  }
}

/// Screen 31 "إضافة مناسبة".
class _OccasionForm extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_OccasionForm> createState() => _OccasionFormState();
}

class _OccasionFormState extends ConsumerState<_OccasionForm> {
  final _person = TextEditingController();
  OccasionType _type = OccasionType.birthday;
  String? _date;
  int _before = 7;
  bool _saving = false;

  @override
  void dispose() {
    _person.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year + 2, 12, 31),
      initialDate: _date == null ? now : DateTime.parse(_date!),
      helpText: l10n.occasionsPickDate,
    );
    if (picked != null) {
      setState(() => _date = picked.toIso8601String().substring(0, 10));
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (_person.text.trim().isEmpty || _date == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.occasionsNeedFields)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(accountRepositoryProvider).saveOccasion({
        'person': _person.text.trim(),
        'type': _type.toJson(),
        'date': _date,
        'remindDaysBefore': _before,
      });
      ref.invalidate(myOccasionsProvider);
      _person.clear();
      setState(() => _date = null);
    } on Object catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    return BBCard(
      color: BBColors.surfaceLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(l10n.occasionsAdd, style: BBText.h3),
          ),
          const SizedBox(height: BBSpacing.gutter),
          BBTextField(
            label: l10n.occasionsPerson,
            hint: l10n.occasionsPersonHint,
            controller: _person,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: BBSpacing.gutter),
          Text(l10n.occasionsType, style: BBText.label),
          const SizedBox(height: BBSpacing.xs),
          Wrap(
            spacing: BBSpacing.sm,
            runSpacing: BBSpacing.sm,
            children: [
              for (final t in OccasionType.values)
                BBChip(
                  label: occasionTypeName(l10n, t),
                  selected: _type == t,
                  onTap: () => setState(() => _type = t),
                ),
            ],
          ),
          const SizedBox(height: BBSpacing.gutter),
          Text(l10n.occasionsDate, style: BBText.label),
          const SizedBox(height: BBSpacing.xs),
          BBButton(
            label: _date == null
                ? l10n.occasionsPickDate
                : dayMonthText(
                    locale,
                    _date!,
                    numerals: ref.watch(displayNumeralsProvider),
                  ),
            leading: BBIcons.calendar,
            variant: BBButtonVariant.secondary,
            expand: true,
            onPressed: _pickDate,
          ),
          const SizedBox(height: BBSpacing.gutter),
          Text(l10n.occasionsRemindBefore, style: BBText.label),
          const SizedBox(height: BBSpacing.xs),
          Wrap(
            spacing: BBSpacing.sm,
            runSpacing: BBSpacing.sm,
            children: [
              for (final days in const [1, 3, 7, 14])
                BBChip(
                  label: l10n.occasionsDays(days),
                  selected: _before == days,
                  onTap: () => setState(() => _before = days),
                ),
            ],
          ),
          const SizedBox(height: BBSpacing.md),
          BBButton(
            label: l10n.occasionsSave,
            expand: true,
            loading: _saving,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

/// A yes/no question; true when the customer confirms.
Future<bool> confirmDialog(
  BuildContext context,
  String question,
  String yes,
) async {
  final l10n = AppLocalizations.of(context);
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(question),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.trackCancelNo),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yes),
        ),
      ],
    ),
  );
  return answer ?? false;
}
