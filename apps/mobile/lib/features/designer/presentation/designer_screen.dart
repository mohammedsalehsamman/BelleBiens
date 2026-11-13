import 'dart:async';

import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/launch/external_links.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/account/presentation/designs_screen.dart';
import 'package:belle_biens/features/cart/presentation/cart_screen.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/application/add_design_to_cart.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:belle_biens/features/designer/domain/bouquet_spec.dart';
import 'package:belle_biens/features/designer/domain/designer_estimate.dart';
import 'package:belle_biens/features/designer/domain/layout.dart';
import 'package:belle_biens/features/designer/presentation/bouquet_painter.dart';
import 'package:belle_biens/features/designer/presentation/designer_widgets.dart';
import 'package:belle_biens/features/designer/presentation/substitute_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The bouquet designer tab (screens 15-18). One screen whose middle changes
/// with the step; the preview and the price stay on top, so every tap shows
/// its effect at once (NFR-PERF-03).
class DesignerScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(designerControllerProvider);
    final catalog = ref.watch(designerCatalogProvider);
    final controller = ref.read(designerControllerProvider.notifier);
    final current = state.value;

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.designerTitle,
        onBack: current == null || current.step == DesignerStep.occasionAndSize
            ? null
            : () =>
                  controller.goTo(DesignerStep.values[current.step.index - 1]),
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BBIconButton(
              icon: BBIcons.undo,
              tooltip: l10n.designerUndo,
              onPressed: current?.canUndo ?? false ? controller.undo : null,
            ),
            const SizedBox(width: BBSpacing.xs),
            Transform.flip(
              flipX: true,
              child: BBIconButton(
                icon: BBIcons.undo,
                tooltip: l10n.designerRedo,
                onPressed: current?.canRedo ?? false ? controller.redo : null,
              ),
            ),
          ],
        ),
      ),
      body: switch ((state, catalog.value)) {
        (AsyncData(:final value), final cached?) => _Designer(
          state: value,
          catalog: cached.data,
          offline: cached.offline,
        ),
        (AsyncError(:final error), _) => ErrorRetry(
          error: error,
          onRetry: () {
            ref
              ..invalidate(designerCatalogProvider)
              ..invalidate(designerControllerProvider);
          },
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Designer extends ConsumerWidget {
  const new({
    required this.state,
    required this.catalog,
    required this.offline,
  });

  final DesignerState state;
  final DesignerCatalogDto catalog;
  final bool offline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spec = state.spec;
    final items = itemsById(catalog);
    final estimate = DesignerEstimate.of(spec, items);
    final step = state.step;
    final stepName = switch (step) {
      DesignerStep.occasionAndSize => l10n.designerStepOccasion,
      DesignerStep.flowers => l10n.designerStepFlowers,
      DesignerStep.wrapAndExtras => l10n.designerStepWrap,
      DesignerStep.cardAndPreview => l10n.designerStepCard,
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            BBSpacing.page,
            BBSpacing.gutter,
            BBSpacing.page,
            0,
          ),
          child: BBStepsBar(
            total: DesignerStep.values.length,
            current: step.index + 1,
            caption: l10n.designerStepCaption(step.index + 1, stepName),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(BBSpacing.page),
            children: [
              if (offline) ...[
                const OfflineBanner(),
                const SizedBox(height: BBSpacing.gutter),
              ],
              BouquetPreviewCard(
                spec: spec,
                catalog: catalog,
                estimate: estimate,
              ),
              _IssueBanner(spec: spec, catalog: catalog),
              const SizedBox(height: BBSpacing.md),
              switch (step) {
                DesignerStep.occasionAndSize => _OccasionSizeStep(
                  spec: spec,
                  catalog: catalog,
                ),
                DesignerStep.flowers => _FlowersStep(
                  spec: spec,
                  catalog: catalog,
                ),
                DesignerStep.wrapAndExtras => _WrapStep(
                  spec: spec,
                  catalog: catalog,
                ),
                DesignerStep.cardAndPreview => _CardStep(
                  state: state,
                  catalog: catalog,
                  estimate: estimate,
                ),
              },
            ],
          ),
        ),
        _BottomBar(state: state, catalog: catalog, estimate: estimate),
      ],
    );
  }
}

DesignerSizeDto? _sizeOf(DesignerCatalogDto catalog, BouquetSpec spec) =>
    catalog.sizes.where((s) => s.key.toJson() == spec.size).firstOrNull;

bool _stemsFit(DesignerCatalogDto catalog, BouquetSpec spec) {
  final size = _sizeOf(catalog, spec);
  return size != null &&
      spec.stems >= size.minStems &&
      spec.stems <= size.maxStems;
}

/// Stock problems the server found (FR-DSG-03): opens screen 37.
class _IssueBanner extends ConsumerWidget {
  const new({required this.spec, required this.catalog});

  final BouquetSpec spec;
  final DesignerCatalogDto catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quote = ref.watch(designerQuoteProvider(quoteKey(spec))).value;
    final stock = quote?.issues
        .where((i) => i.code != QuoteIssueCode.stemsOutOfRange)
        .firstOrNull;
    if (stock == null) return const SizedBox.shrink();
    final item = itemsById(catalog)[stock.itemId];
    return Padding(
      padding: const EdgeInsets.only(top: BBSpacing.gutter),
      child: InkWell(
        onTap: item == null
            ? null
            : () => showSubstituteSheet(
                context,
                item: item.copyWith(available: stock.available),
                qty: stock.requested ?? 1,
                items: catalog.items,
              ),
        child: BBNotice(
          text: l10n.designerIssueBanner,
          tone: BBNoticeTone.warn,
          icon: BBIcons.warning,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new(this.title, {this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: BBSpacing.sm),
    child: Row(
      children: [
        Expanded(
          child: Semantics(header: true, child: Text(title, style: BBText.h3)),
        ),
        if (trailing != null) Text(trailing!, style: BBText.xs.muted),
      ],
    ),
  );
}

/// Screen 15: occasion, size and palette.
class _OccasionSizeStep extends ConsumerWidget {
  const new({required this.spec, required this.catalog});

  final BouquetSpec spec;
  final DesignerCatalogDto catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(designerControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(l10n.designerOccasion),
        Wrap(
          spacing: BBSpacing.sm,
          runSpacing: BBSpacing.sm,
          children: [
            for (final o in catalog.occasions)
              BBChip(
                label: o.name.of(context),
                selected: spec.occasion == o.slug,
                onTap: () =>
                    controller.edit((s) => s.copyWith(occasion: o.slug)),
              ),
          ],
        ),
        const SizedBox(height: BBSpacing.section),
        _SectionTitle(l10n.designerSize),
        for (final size in catalog.sizes) ...[
          BBOptionTile(
            title: size.name.of(context),
            subtitle: l10n.designerSizeRange(size.minStems, size.maxStems),
            selected: spec.size == size.key.toJson(),
            onTap: () => controller.edit(
              (s) => s.copyWith(size: size.key.toJson() as String),
            ),
          ),
          const SizedBox(height: BBSpacing.sm),
        ],
        Text(l10n.designerSizeNote, style: BBText.xs.muted),
        const SizedBox(height: BBSpacing.section),
        _SectionTitle(l10n.designerPalette, trailing: l10n.designerOptional),
        Wrap(
          spacing: BBSpacing.sm,
          runSpacing: BBSpacing.sm,
          children: [
            for (final p in catalog.palettes)
              BBChip(
                label: p.name.of(context),
                selected: spec.palette == p.key.toJson(),
                // A second tap clears the optional palette.
                onTap: () => controller.edit(
                  (s) => s.copyWith(
                    palette: () => s.palette == p.key.toJson()
                        ? null
                        : p.key.toJson() as String,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Screen 16: flowers, fillers and greens with today's stock.
class _FlowersStep extends ConsumerWidget {
  const new({required this.spec, required this.catalog});

  final BouquetSpec spec;
  final DesignerCatalogDto catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(designerControllerProvider.notifier);
    final size = _sizeOf(catalog, spec);
    final palette = catalog.palettes
        .where((p) => p.key.toJson() == spec.palette)
        .firstOrNull;
    bool fits(DesignerItemDto i) =>
        palette != null &&
        palette.colors.isNotEmpty &&
        i.colorTags.any(palette.colors.contains);

    Widget row(DesignerItemDto item, {bool perSprig = false}) {
      final list = listFor(item.type2);
      final qty = spec.qty(list, item.id);
      return Padding(
        padding: const EdgeInsets.only(bottom: BBSpacing.sm),
        child: ItemQtyRow(
          item: item,
          qty: qty,
          perSprig: perSprig,
          fitsPalette: fits(item),
          onChanged: (v) => controller.edit((s) => s.withQty(list, item.id, v)),
          onSuggest: () => showSubstituteSheet(
            context,
            item: item,
            qty: size == null
                ? 1
                : (size.minStems - spec.stems).clamp(1, size.maxStems),
            items: catalog.items,
          ),
        ),
      );
    }

    final flowers = catalog.items.where((i) => i.type2 == DesignerPart.flower);
    final others = catalog.items.where(
      (i) => i.type2 == DesignerPart.filler || i.type2 == DesignerPart.green,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (size != null) _StemsMeter(stems: spec.stems, size: size),
        const SizedBox(height: BBSpacing.section),
        _SectionTitle(l10n.designerMainFlowers, trailing: l10n.designerPerStem),
        for (final item in flowers) row(item),
        const SizedBox(height: BBSpacing.md),
        _SectionTitle(l10n.designerFillersGreens),
        for (final item in others) row(item, perSprig: true),
        Text(l10n.designerStockNote, style: BBText.xs.muted),
      ],
    );
  }
}

/// "18 وردة من 15 – 30" with a bar (screen 16).
class _StemsMeter extends StatelessWidget {
  const new({required this.stems, required this.size});

  final int stems;
  final DesignerSizeDto size;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tooFew = stems < size.minStems;
    final tooMany = stems > size.maxStems;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.designerStemsRange(
                  l10n.designerStems(stems),
                  size.minStems,
                  size.maxStems,
                ),
                style: BBText.small.bold.merge(BBText.numeric),
              ),
            ),
            Flexible(
              child: Text(
                l10n.designerSizeName(size.name.of(context)),
                style: BBText.small.muted,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: BBSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(BBRadius.pill),
          child: LinearProgressIndicator(
            value: (stems / size.maxStems).clamp(0, 1).toDouble(),
            minHeight: 6,
            color: tooMany ? BBColors.error : BBColors.primary,
            backgroundColor: BBColors.track,
          ),
        ),
        if (stems > 0 && (tooFew || tooMany)) ...[
          const SizedBox(height: BBSpacing.sm),
          BBNotice(
            text: tooFew
                ? l10n.designerTooFew(size.minStems)
                : l10n.designerTooMany(size.maxStems),
            tone: BBNoticeTone.warn,
          ),
        ],
      ],
    );
  }
}

/// Screen 17: wrap, ribbon and extras.
class _WrapStep extends ConsumerWidget {
  const new({required this.spec, required this.catalog});

  final BouquetSpec spec;
  final DesignerCatalogDto catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final controller = ref.read(designerControllerProvider.notifier);
    final wraps = catalog.items.where((i) => i.type2 == DesignerPart.wrap);
    final ribbons = catalog.items.where((i) => i.type2 == DesignerPart.ribbon);
    final extras = catalog.items.where((i) => i.type2 == DesignerPart.extra);
    final ribbon = itemsById(catalog)[spec.ribbon];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(l10n.designerWrap),
        for (final w in wraps) ...[
          Opacity(
            opacity: w.available == 0 ? 0.5 : 1,
            child: BBOptionTile(
              title: w.name.of(context),
              subtitle: w.available == 0
                  ? l10n.designerUnavailable
                  : w.detail.of(context),
              selected: spec.wrap == w.id,
              onTap: w.available == 0
                  ? null
                  : () => controller.edit((s) => s.copyWith(wrap: w.id)),
              trailing: Text(
                money.change(w.unitPriceMinor),
                style: BBText.small.bold.merge(BBText.numeric),
              ),
            ),
          ),
          const SizedBox(height: BBSpacing.sm),
        ],
        const SizedBox(height: BBSpacing.md),
        _SectionTitle(l10n.designerRibbon),
        Wrap(
          spacing: BBSpacing.md,
          runSpacing: BBSpacing.sm,
          children: [
            for (final r in ribbons)
              Semantics(
                button: true,
                selected: spec.ribbon == r.id,
                label: r.name.of(context),
                excludeSemantics: true,
                child: InkWell(
                  onTap: r.available == 0
                      ? null
                      : () => controller.edit((s) => s.copyWith(ribbon: r.id)),
                  borderRadius: BorderRadius.circular(BBRadius.card),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: BBSizes.minTouch,
                      minHeight: BBSizes.minTouch,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(BBSpacing.xs),
                      child: Column(
                        children: [
                          Swatch(r.swatch, selected: spec.ribbon == r.id),
                          const SizedBox(height: BBSpacing.xs),
                          Text(r.name.of(context), style: BBText.xs),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (ribbon != null) ...[
          const SizedBox(height: BBSpacing.xs),
          Text(
            l10n.designerRibbonNote(money.change(ribbon.unitPriceMinor)),
            style: BBText.xs.muted.merge(BBText.numeric),
          ),
        ],
        const SizedBox(height: BBSpacing.section),
        _SectionTitle(l10n.designerExtras),
        for (final e in extras)
          Padding(
            padding: const EdgeInsets.only(bottom: BBSpacing.sm),
            child: ItemQtyRow(
              item: e,
              qty: spec.qty(SpecList.extras, e.id),
              onChanged: (v) =>
                  controller.edit((s) => s.withQty(SpecList.extras, e.id, v)),
            ),
          ),
      ],
    );
  }
}

/// Screen 18: preview mode, gift card, summary and sending.
class _CardStep extends ConsumerStatefulWidget {
  const new({
    required this.state,
    required this.catalog,
    required this.estimate,
  });

  final DesignerState state;
  final DesignerCatalogDto catalog;
  final DesignerEstimate estimate;

  @override
  ConsumerState<_CardStep> createState() => _CardStepState();
}

class _CardStepState extends ConsumerState<_CardStep> {
  late final _recipient = TextEditingController(
    text: widget.state.recipientName,
  );
  late final _message = TextEditingController(
    text: widget.state.spec.cardMessage ?? '',
  );
  bool _sending = false;

  @override
  void dispose() {
    _recipient.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // Loads the branch if no screen has yet (works offline from the cache).
    String? whatsapp;
    try {
      whatsapp = (await ref.read(branchProvider.future)).data.whatsapp;
    } on Object {
      whatsapp = null;
    }
    if (!mounted) return;
    if (whatsapp == null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.designerSendNoNumber)),
      );
      return;
    }
    setState(() => _sending = true);
    try {
      final spec = widget.state.spec;
      final items = itemsById(widget.catalog);
      final layout = widget.catalog.layouts.sizes.firstWhere(
        (l) => l.size.toJson() == spec.size,
      );
      final png = await renderBouquetPng(layoutBouquet(spec, layout), items);
      final link = await ref
          .read(designerRepositoryProvider)
          .uploadPreview(png);
      if (!mounted) return;
      final money = ref.read(moneyFormatProvider);
      final total = designerTotal(ref, spec, widget.estimate).totalMinor;
      final text = [
        l10n.designerWhatsappIntro,
        for (final line in widget.estimate.lines)
          l10n.designerLineQty(line.item.name.of(context), line.qty),
        l10n.designerWhatsappTotal(money.syp(total)),
        l10n.designerWhatsappPreview(link),
      ].join('\n');
      await ref
          .read(externalLinksProvider)
          .open(ExternalLinks.whatsapp(whatsapp, text: text));
    } on Object catch (error) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(errorText(l10n, error))));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final controller = ref.read(designerControllerProvider.notifier);
    final state = widget.state;
    final total = designerTotal(ref, state.spec, widget.estimate);
    final messageLength = _message.text.runes.length;

    String lineLabel(EstimateLine line) {
      final name = line.item.name.of(context);
      return switch (line.item.type2) {
        DesignerPart.wrap => l10n.designerWrapLine(name),
        DesignerPart.ribbon => l10n.designerRibbonLine(name),
        _ => l10n.designerLineQty(name, line.qty),
      };
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BBSegmented<String>(
          segments: [
            ('2d', '2D'),
            ('3d', l10n.designerMode3d),
            ('ai', l10n.designerModeAi),
          ],
          selected: '2d',
          // 3D and AI previews come in release 3 (FR-D3D, FR-DAI).
          onChanged: (_) {},
        ),
        const SizedBox(height: BBSpacing.sm),
        BBNotice(text: l10n.designerModeSoon, icon: BBIcons.info),
        const SizedBox(height: BBSpacing.section),
        Row(
          children: [
            Expanded(child: Text(l10n.designerCard, style: BBText.h3)),
            // The checkbox stretches its label, so it needs a bounded width.
            Flexible(
              child: BBCheckbox(
                value: !state.withCard,
                onChanged: (v) => controller.setWithCard(value: !v),
                label: Text(l10n.designerNoCard, style: BBText.small),
              ),
            ),
          ],
        ),
        if (state.withCard) ...[
          const SizedBox(height: BBSpacing.sm),
          BBTextField(
            label: l10n.designerRecipient,
            controller: _recipient,
            maxLength: 60,
            textInputAction: TextInputAction.next,
            onChanged: controller.setRecipient,
          ),
          const SizedBox(height: BBSpacing.gutter),
          BBTextField(
            label: l10n.designerMessage,
            controller: _message,
            maxLines: 4,
            helper: l10n.designerMessageCount(
              messageLength,
              BouquetSpec.maxCardMessage,
            ),
            inputFormatters: [_CodePointLimit(BouquetSpec.maxCardMessage)],
            onChanged: (text) {
              setState(() {});
              unawaited(controller.setCardMessage(text));
            },
          ),
        ],
        const SizedBox(height: BBSpacing.section),
        _SectionTitle(l10n.designerSummary),
        BBCard(
          child: Column(
            children: [
              for (final line in widget.estimate.lines) ...[
                BBKvRow(
                  label: lineLabel(line),
                  value: money.syp(line.totalMinor),
                ),
                const SizedBox(height: BBSpacing.xs),
              ],
              if ((total.quote?.assemblyFeeMinor ?? 0) > 0) ...[
                BBKvRow(
                  label: l10n.designerAssemblyFee,
                  value: money.syp(total.quote!.assemblyFeeMinor),
                ),
                const SizedBox(height: BBSpacing.xs),
              ],
              const Divider(),
              BBKvRow(
                label: l10n.productTotal,
                value: money.syp(total.totalMinor),
                total: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: BBSpacing.gutter),
        Text(l10n.productDisclaimer, style: BBText.xs.muted),
        const SizedBox(height: BBSpacing.md),
        Row(
          children: [
            Expanded(
              child: BBButton(
                label: l10n.designerSave,
                variant: BBButtonVariant.secondary,
                expand: true,
                // FR-DSG-12: kept under "تصاميمي" (screen 30).
                onPressed: state.spec.flowers.isEmpty
                    ? null
                    : () => saveDesignToAccount(
                        context,
                        ref,
                        state.spec.toJson(),
                      ),
              ),
            ),
            const SizedBox(width: BBSpacing.sm),
            Expanded(
              child: BBButton(
                label: l10n.designerSend,
                leading: BBIcons.whatsapp,
                variant: BBButtonVariant.whatsapp,
                expand: true,
                loading: _sending,
                onPressed: state.spec.flowers.isEmpty ? null : _send,
              ),
            ),
          ],
        ),
        const SizedBox(height: BBSpacing.sm),
        BBButton(
          label: l10n.designerRestart,
          variant: BBButtonVariant.quiet,
          expand: true,
          onPressed: controller.restart,
        ),
      ],
    );
  }
}

/// Keeps the card message within 200 code points (emoji count as one).
class _CodePointLimit extends TextInputFormatter {
  new(this.max);

  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.text.runes.length <= max ? newValue : oldValue;
}

/// Previous / next, and on the last step the total and "add to cart".
class _BottomBar extends ConsumerWidget {
  const new({
    required this.state,
    required this.catalog,
    required this.estimate,
  });

  final DesignerState state;
  final DesignerCatalogDto catalog;
  final DesignerEstimate estimate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final controller = ref.read(designerControllerProvider.notifier);
    final spec = state.spec;
    final step = state.step;

    if (step == DesignerStep.cardAndPreview) {
      final total = designerTotal(ref, spec, estimate);
      final orderable =
          _stemsFit(catalog, spec) && (total.quote?.orderable ?? true);
      return BBBottomCta(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.productTotal, style: BBText.xs.muted),
              Text(
                money.primary(total.totalMinor),
                style: BBText.price.merge(BBText.numeric),
              ),
            ],
          ),
          Expanded(
            child: BBButton(
              label: state.editingLineId == null
                  ? l10n.designerAddToCart
                  : l10n.cartUpdateDesign,
              leading: BBIcons.bag,
              expand: true,
              onPressed: orderable
                  ? () async {
                      final updated = await addDesignToCart(
                        ref,
                        state,
                        catalog,
                      );
                      if (!context.mounted) return;
                      showAddedToCart(
                        context,
                        updated ? l10n.cartUpdated : l10n.cartAdded,
                      );
                    }
                  : null,
            ),
          ),
        ],
      );
    }

    final next = DesignerStep.values[step.index + 1];
    final canGoOn = switch (step) {
      DesignerStep.flowers => _stemsFit(catalog, spec),
      _ => true,
    };
    return BBBottomCta(
      children: [
        if (step != DesignerStep.occasionAndSize)
          BBButton(
            label: l10n.designerPrevious,
            variant: BBButtonVariant.secondary,
            onPressed: () =>
                controller.goTo(DesignerStep.values[step.index - 1]),
          ),
        Expanded(
          child: BBButton(
            label: switch (step) {
              DesignerStep.occasionAndSize => l10n.designerNextFlowers,
              DesignerStep.flowers => l10n.designerNextWrap,
              _ => l10n.designerNextCard,
            },
            trailing: BBIcons.forward,
            expand: true,
            onPressed: canGoOn ? () => controller.goTo(next) : null,
          ),
        ),
      ],
    );
  }
}
