import 'dart:async';

import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/analytics/analytics.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/network/api_error.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/validation/phone.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/auth/application/session_controller.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/checkout/application/checkout_controller.dart';
import 'package:belle_biens/features/checkout/domain/checkout_draft.dart';
import 'package:belle_biens/features/checkout/presentation/checkout_widgets.dart';
import 'package:belle_biens/features/checkout/presentation/shop_mode_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 21: how, where, who and when (FR-DLV-03..08, FR-CRT-06/09).
class CheckoutScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final _name = TextEditingController();
  late final _phone = TextEditingController();
  late final _recipientName = TextEditingController();
  late final _recipientPhone = TextEditingController();
  late final _notes = TextEditingController();

  /// Field errors appear after the first "متابعة".
  bool _checked = false;
  bool _holding = false;

  @override
  void initState() {
    super.initState();
    ref.read(analyticsProvider).log(AnalyticsEvent.checkoutStarted);
    unawaited(_useDefaultAddress());
    final d = ref.read(checkoutControllerProvider);
    _name.text = d.customerName;
    _phone.text = d.customerPhone;
    _recipientName.text = d.recipientName;
    _recipientPhone.text = d.recipientPhone;
    _notes.text = d.notes;
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _recipientName, _recipientPhone, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  /// FR-ACC-04: a signed-in customer starts with their default address,
  /// when it is inside the zones.
  Future<void> _useDefaultAddress() async {
    if (ref.read(checkoutControllerProvider).address != null) return;
    if (ref.read(sessionControllerProvider).value == null) return;
    try {
      final saved = await ref.read(checkoutRepositoryProvider).savedAddresses();
      final pick = saved
          .where((a) => a.isDefault && a.zone != null)
          .firstOrNull;
      if (pick == null || !mounted) return;
      if (ref.read(checkoutControllerProvider).address != null) return;
      _checkout
        ..address(DraftAddress.fromSaved(pick))
        ..edit((d) => d.copyWith(callBeforeArrival: pick.callBeforeArrival));
    } on Object {
      // Offline or signed out meanwhile: the customer picks on the map.
    }
  }

  CheckoutController get _checkout =>
      ref.read(checkoutControllerProvider.notifier);

  String? _nameError(String value, AppLocalizations l10n) =>
      _checked && value.trim().isEmpty ? l10n.checkoutNeedName : null;

  String? _phoneError(String value, AppLocalizations l10n) =>
      _checked && normalizePhone(value) == null ? l10n.phoneInvalid : null;

  Future<void> _continue(_Picked picked) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final d = ref.read(checkoutControllerProvider);
    setState(() => _checked = true);

    void tell(String text) => messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));

    if (d.delivery && d.address == null) return tell(l10n.checkoutNeedAddress);
    if (d.delivery && d.address!.zone == null) {
      await _outOfZone();
      return;
    }
    final people = [_name.text, if (!d.recipientIsMe) _recipientName.text];
    final phones = [_phone.text, if (!d.recipientIsMe) _recipientPhone.text];
    if (people.any((n) => n.trim().isEmpty) ||
        phones.any((p) => normalizePhone(p) == null)) {
      return;
    }
    final date = picked.date;
    final slot = picked.slot;
    if (date == null || slot == null) return tell(l10n.checkoutNeedSlot);
    _checkout
      ..day(date)
      ..slot(slot.start, slot.end);

    setState(() => _holding = true);
    try {
      await _checkout.holdSlot(picked.leadTimeHours);
      if (mounted) await context.push(Routes.checkoutPayment);
    } on ApiError catch (error) {
      tell(errorText(l10n, error));
      ref
        ..invalidate(daySlotsProvider)
        ..invalidate(deliveryCalendarProvider);
    } finally {
      if (mounted) setState(() => _holding = false);
    }
  }

  Future<void> _outOfZone() async {
    final choice = await context.push<String>(Routes.checkoutOutOfZone);
    if (choice == outOfZonePickup) _checkout.fulfillment(Fulfillment.pickup);
    if (choice == outOfZoneOtherAddress && mounted) {
      await context.push(Routes.checkoutAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final d = ref.watch(checkoutControllerProvider);
    final lead = ref.watch(cartLeadTimeProvider) ?? 0;
    final calendar = ref.watch(
      deliveryCalendarProvider((
        leadTimeHours: lead,
        fulfillment: d.fulfillment,
      )),
    );
    final days = calendar.value?.days ?? const <DeliveryDayDto>[];
    // The chosen day, else the first with a free slot.
    final date =
        (d.date != null && days.any((x) => x.date == d.date && x.available))
        ? d.date
        : days.where((x) => x.available).firstOrNull?.date;
    final slots = date == null
        ? null
        : ref.watch(
            daySlotsProvider((
              date: date,
              leadTimeHours: lead,
              fulfillment: d.fulfillment,
            )),
          );
    final open = slots?.value?.slots.where((s) => s.available).toList();
    final slot = open?.where((s) => s.start == d.slotStart).firstOrNull;
    final picked = _Picked(date: date, slot: slot, leadTimeHours: lead);

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.checkoutTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(BBSpacing.page),
        children: [
          BBStepsBar(total: 2, current: 1, caption: l10n.checkoutStep1),
          const SizedBox(height: BBSpacing.section),
          const ShopModeNotice(),
          _HowSection(draft: d),
          if (d.delivery) ...[
            const SizedBox(height: BBSpacing.section),
            _AddressSection(address: d.address),
          ],
          const SizedBox(height: BBSpacing.section),
          CheckoutSection(
            title: l10n.checkoutYouTitle,
            child: Column(
              children: [
                BBTextField(
                  label: l10n.checkoutYourName,
                  controller: _name,
                  error: _nameError(_name.text, l10n),
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  onChanged: (v) {
                    _checkout.edit((x) => x.copyWith(customerName: v));
                    if (_checked) setState(() {});
                  },
                ),
                const SizedBox(height: BBSpacing.gutter),
                BBTextField(
                  label: l10n.checkoutYourPhone,
                  controller: _phone,
                  hint: l10n.phoneHint,
                  error: _phoneError(_phone.text, l10n),
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  onChanged: (v) {
                    _checkout.edit((x) => x.copyWith(customerPhone: v));
                    if (_checked) setState(() {});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: BBSpacing.section),
          CheckoutSection(
            title: l10n.checkoutRecipientTitle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BBSegmented<bool>(
                  segments: [
                    (true, l10n.checkoutRecipientMe),
                    (false, l10n.checkoutRecipientOther),
                  ],
                  selected: d.recipientIsMe,
                  onChanged: (me) =>
                      _checkout.edit((x) => x.copyWith(recipientIsMe: me)),
                ),
                if (!d.recipientIsMe) ...[
                  const SizedBox(height: BBSpacing.gutter),
                  BBTextField(
                    label: l10n.checkoutRecipientName,
                    controller: _recipientName,
                    error: _nameError(_recipientName.text, l10n),
                    textInputAction: TextInputAction.next,
                    onChanged: (v) {
                      _checkout.edit((x) => x.copyWith(recipientName: v));
                      if (_checked) setState(() {});
                    },
                  ),
                  const SizedBox(height: BBSpacing.gutter),
                  BBTextField(
                    label: l10n.checkoutRecipientPhone,
                    controller: _recipientPhone,
                    hint: l10n.phoneHint,
                    error: _phoneError(_recipientPhone.text, l10n),
                    keyboardType: TextInputType.phone,
                    textDirection: TextDirection.ltr,
                    onChanged: (v) {
                      _checkout.edit((x) => x.copyWith(recipientPhone: v));
                      if (_checked) setState(() {});
                    },
                  ),
                  const SizedBox(height: BBSpacing.xs),
                  BBCheckbox(
                    value: d.hideSender,
                    onChanged: (v) =>
                        _checkout.edit((x) => x.copyWith(hideSender: v)),
                    label: Text(l10n.checkoutHideSender, style: BBText.small),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: BBSpacing.section),
          _DaySection(
            draft: d,
            calendar: calendar,
            date: date,
            leadTimeHours: lead,
          ),
          if (date != null) ...[
            const SizedBox(height: BBSpacing.section),
            _TimeSection(
              slots: slots!,
              selected: slot?.start,
              onSelect: (s) => _checkout
                ..day(date)
                ..slot(s.start, s.end),
            ),
          ],
          if (d.delivery) ...[
            const SizedBox(height: BBSpacing.sm),
            ToggleRow(
              label: l10n.checkoutCallBefore,
              value: d.callBeforeArrival,
              onChanged: (v) =>
                  _checkout.edit((x) => x.copyWith(callBeforeArrival: v)),
            ),
          ],
          const SizedBox(height: BBSpacing.md),
          BBTextField(
            label: l10n.checkoutNotes,
            controller: _notes,
            maxLines: 3,
            // FR-CRT-06; the field shows "0 / 300".
            maxLength: 300,
            onChanged: (v) => _checkout.edit((x) => x.copyWith(notes: v)),
          ),
          const SizedBox(height: BBSpacing.lg),
        ],
      ),
      bottomNavigationBar: _Bottom(
        draft: d,
        loading: _holding,
        onContinue: () => _continue(picked),
      ),
    );
  }
}

/// What screen 21 resolved: the day, a free slot on it, the lead time.
class _Picked {
  const new({
    required this.date,
    required this.slot,
    required this.leadTimeHours,
  });

  final String? date;
  final DeliverySlotDto? slot;
  final int leadTimeHours;
}

/// What the out-of-zone screen (36) hands back.
const outOfZonePickup = 'pickup';
const outOfZoneOtherAddress = 'address';

class _HowSection extends ConsumerWidget {
  const new({required this.draft});

  final CheckoutDraft draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final branch = ref.watch(branchProvider).value?.data;
    final controller = ref.read(checkoutControllerProvider.notifier);
    return CheckoutSection(
      title: l10n.checkoutHowTitle,
      child: Column(
        children: [
          BBOptionTile(
            title: l10n.checkoutDelivery,
            subtitle: l10n.checkoutDeliveryHint,
            selected: draft.delivery,
            onTap: () => controller.fulfillment(Fulfillment.delivery),
            trailing: const BBIcon(BBIcons.truck, color: BBColors.textMuted),
          ),
          const SizedBox(height: BBSpacing.sm),
          BBOptionTile(
            title: l10n.checkoutPickup,
            subtitle: branch == null
                ? l10n.checkoutPickupFree
                : l10n.checkoutPickupFreeAt(branch.address.of(context)),
            selected: !draft.delivery,
            onTap: () => controller.fulfillment(Fulfillment.pickup),
            trailing: const BBIcon(BBIcons.store, color: BBColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _AddressSection extends ConsumerWidget {
  const new({required this.address});

  final DraftAddress? address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final a = address;
    void edit() => context.push(Routes.checkoutAddress);
    return CheckoutSection(
      title: l10n.checkoutAddressTitle,
      action: a == null
          ? null
          : TextButton(
              onPressed: edit,
              child: Text(l10n.checkoutAddressChange),
            ),
      child: a == null
          ? BBButton(
              label: l10n.checkoutAddressSet,
              leading: BBIcons.pin,
              variant: BBButtonVariant.secondary,
              expand: true,
              onPressed: edit,
            )
          : BBCard(
              onTap: edit,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BBIconBox(BBIcons.pin, size: 40),
                  const SizedBox(width: BBSpacing.gutter),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addressTitle(context, a.label, a.zone),
                          style: BBText.small.bold,
                        ),
                        if (a.line.isNotEmpty)
                          Text(a.line, style: BBText.xs.muted),
                        const SizedBox(height: BBSpacing.xs),
                        if (a.zone != null)
                          BBBadge(
                            label: l10n.checkoutInZone(
                              money.syp(a.zone!.feeMinor),
                            ),
                            tone: BBBadgeTone.green,
                          )
                        else
                          BBBadge(
                            label: l10n.addressOutOfZone,
                            tone: BBBadgeTone.red,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _DaySection extends ConsumerWidget {
  const new({
    required this.draft,
    required this.calendar,
    required this.date,
    required this.leadTimeHours,
  });

  final CheckoutDraft draft;
  final AsyncValue<DeliveryCalendarDto> calendar;
  final String? date;
  final int leadTimeHours;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final controller = ref.read(checkoutControllerProvider.notifier);
    final title = draft.delivery
        ? l10n.checkoutDayTitle
        : l10n.checkoutPickupDayTitle;

    final cal = calendar.value;
    if (cal == null) {
      return CheckoutSection(
        title: title,
        child: calendar.hasError
            ? ErrorRetry(
                error: calendar.error!,
                onRetry: () => ref.invalidate(deliveryCalendarProvider),
              )
            : const Center(child: CircularProgressIndicator()),
      );
    }
    final today = cal.days.first;
    final tomorrow = cal.days.length > 1 ? cal.days[1] : null;
    final later = date != null && date != today.date && date != tomorrow?.date;

    Future<void> pickDate() async {
      final available = {
        for (final day in cal.days)
          if (day.available) day.date,
      };
      final first = DateTime.parse(today.date);
      final picked = await showDatePicker(
        context: context,
        firstDate: first,
        lastDate: first.add(Duration(days: cal.windowDays)),
        initialDate: DateTime.parse(
          date ?? available.firstOrNull ?? today.date,
        ),
        helpText: l10n.checkoutPickDate,
        selectableDayPredicate: (day) =>
            available.contains(day.toIso8601String().substring(0, 10)),
      );
      if (picked != null) {
        controller.day(picked.toIso8601String().substring(0, 10));
      }
    }

    String sub(DeliveryDayDto day) =>
        day.available ? dayText(locale, day.date) : l10n.checkoutUnavailable;

    return CheckoutSection(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: DayOption(
                  title: l10n.checkoutToday,
                  subtitle: sub(today),
                  selected: date == today.date,
                  onTap: today.available
                      ? () => controller.day(today.date)
                      : null,
                ),
              ),
              const SizedBox(width: BBSpacing.sm),
              if (tomorrow != null) ...[
                Expanded(
                  child: DayOption(
                    title: l10n.checkoutTomorrow,
                    subtitle: sub(tomorrow),
                    selected: date == tomorrow.date,
                    onTap: tomorrow.available
                        ? () => controller.day(tomorrow.date)
                        : null,
                  ),
                ),
                const SizedBox(width: BBSpacing.sm),
              ],
              Expanded(
                child: DayOption(
                  title: l10n.checkoutOtherDate,
                  subtitle: later
                      ? dayText(locale, date!)
                      : l10n.checkoutUpToDays(cal.windowDays),
                  selected: later,
                  onTap: pickDate,
                ),
              ),
            ],
          ),
          if (!today.available && today.problem == SlotProblem.tooSoon) ...[
            const SizedBox(height: BBSpacing.sm),
            // A preparation time to blame, or simply a day already over.
            Text(
              leadTimeHours > 0
                  ? l10n.checkoutTodayTooSoon(leadTimeHours)
                  : l10n.checkoutTodayOver,
              style: BBText.xs.muted,
            ),
          ],
        ],
      ),
    );
  }
}

class _TimeSection extends StatelessWidget {
  const new({
    required this.slots,
    required this.selected,
    required this.onSelect,
  });

  final AsyncValue<DaySlotsDto> slots;
  final String? selected;
  final ValueChanged<DeliverySlotDto> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = slots.value;
    return CheckoutSection(
      title: l10n.checkoutTimeTitle,
      child: day == null
          ? (slots.hasError
                ? BBNotice(
                    text: errorText(l10n, slots.error!),
                    tone: BBNoticeTone.error,
                  )
                : const Center(child: CircularProgressIndicator()))
          : day.slots.every((s) => !s.available)
          ? BBNotice(text: l10n.checkoutNoSlots, tone: BBNoticeTone.warn)
          : Wrap(
              spacing: BBSpacing.sm,
              runSpacing: BBSpacing.sm,
              children: [
                for (final s in day.slots)
                  // Too soon, busy or closed slots are left out; a full one
                  // shows struck through (screen 21).
                  if (s.available || s.problem == SlotProblem.full)
                    Opacity(
                      opacity: s.available ? 1 : 0.5,
                      child: BBChip(
                        label: s.available
                            ? l10n.checkoutSlot(s.start, s.end)
                            : l10n.checkoutSlotFull(s.start, s.end),
                        selected: s.start == selected,
                        onTap: s.available ? () => onSelect(s) : null,
                      ),
                    ),
              ],
            ),
    );
  }
}

class _Bottom extends ConsumerWidget {
  const new({
    required this.draft,
    required this.loading,
    required this.onContinue,
  });

  final CheckoutDraft draft;
  final bool loading;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final quote = ref.watch(checkoutQuoteProvider).value;
    final closed =
        ref.watch(appConfigProvider).value?.shop.mode ==
        ShopConfigDtoMode.closed;
    return BBBottomCta(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              draft.zoneSlug == null
                  ? l10n.productTotal
                  : l10n.checkoutWithDelivery,
              style: BBText.xs.muted,
            ),
            Text(
              quote == null ? '…' : money.primary(quote.syp.totalMinor),
              style: BBText.price.merge(BBText.numeric),
            ),
          ],
        ),
        Expanded(
          child: BBButton(
            label: l10n.checkoutToPayment,
            trailing: BBIcons.forward,
            expand: true,
            loading: loading,
            onPressed: closed ? null : onContinue,
          ),
        ),
      ],
    );
  }
}
