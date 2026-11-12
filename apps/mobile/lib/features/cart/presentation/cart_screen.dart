import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/api/generated/belle_api.dart';
import 'package:belle_biens/core/money/money.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/time/date_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/cart/application/cart_controller.dart';
import 'package:belle_biens/features/cart/domain/cart_line.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/designer/application/designer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screens 20 (cart) and 35 (empty cart).
class CartScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  /// The last quote, kept on screen while a newer one loads, so a quantity
  /// tap does not blank the page.
  CartQuoteDto? _last;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lines = ref.watch(cartControllerProvider).value;
    final quote = ref.watch(currentCartQuoteProvider);
    _last = quote.value ?? (lines?.isEmpty ?? true ? null : _last);
    final count = ref.watch(cartCountProvider);

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.cartTitleCount(count),
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: switch (lines) {
        null => const Center(child: CircularProgressIndicator()),
        [] => const _EmptyCart(),
        final lines => _CartBody(
          lines: lines,
          quote: _last,
          error: quote.hasError ? quote.error : null,
        ),
      },
      bottomNavigationBar: lines == null || lines.isEmpty
          ? null
          : _CartBottom(quote: _last, loading: quote.isLoading),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(BBSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BBHeroIcon(BBIcons.bag),
            const SizedBox(height: BBSpacing.md),
            Text(l10n.cartEmptyTitle, style: BBText.h2),
            const SizedBox(height: BBSpacing.xs),
            Text(
              l10n.cartEmptyBody,
              style: BBText.body.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: BBSpacing.lg),
            BBButton(
              label: l10n.navDesigner,
              leading: BBIcons.flower,
              expand: true,
              onPressed: () => context.go(Routes.designer),
            ),
            const SizedBox(height: BBSpacing.sm),
            BBButton(
              label: l10n.cartBrowseToday,
              variant: BBButtonVariant.secondary,
              expand: true,
              onPressed: () => context.go(Routes.today),
            ),
          ],
        ),
      ),
    );
  }
}

/// "اليوم 15:00", "غداً 12:00" or a date, from the server's ISO time in
/// Damascus (FR-LOC-03).
String earliestText(
  AppLocalizations l10n,
  String locale,
  String iso,
  int inDays,
) {
  final time = iso.length >= 16 ? iso.substring(11, 16) : '';
  return switch (inDays) {
    0 => l10n.cartWhenToday(time),
    1 => l10n.cartWhenTomorrow(time),
    _ => l10n.cartWhenDate(dayMonthText(locale, iso.substring(0, 10)), time),
  };
}

class _CartBody extends ConsumerWidget {
  const new({required this.lines, required this.quote, required this.error});

  final List<CartLine> lines;
  final CartQuoteDto? quote;
  final Object? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final q = quote;
    final locale = Localizations.localeOf(context).languageCode;

    return ListView(
      padding: const EdgeInsets.all(BBSpacing.page),
      children: [
        if (error != null && q == null)
          ErrorRetry(
            error: error!,
            onRetry: () => ref.invalidate(cartQuoteProvider),
          ),
        for (final line in lines) ...[
          _LineCard(
            line: line,
            quoted: q?.lines.where((l) => l.id == line.id).firstOrNull,
          ),
          const SizedBox(height: BBSpacing.gutter),
        ],
        if (q != null && q.leadTimeHours > 0) ...[
          BBNotice(
            text: l10n.cartLeadNotice(
              q.leadTimeHours,
              earliestText(l10n, locale, q.earliestAt, q.earliestInDays),
            ),
            icon: BBIcons.clock,
          ),
          const SizedBox(height: BBSpacing.md),
        ],
        _CouponField(result: q?.coupon),
        const SizedBox(height: BBSpacing.md),
        if (q != null) _Totals(quote: q, money: money),
        if (q != null && q.suggestions.isNotEmpty) ...[
          const SizedBox(height: BBSpacing.section),
          BBSectionHeader(title: l10n.cartSuggestions),
          const SizedBox(height: BBSpacing.sm),
          for (final s in q.suggestions) ...[
            ProductRow(product: s),
            const SizedBox(height: BBSpacing.sm),
          ],
        ],
      ],
    );
  }
}

/// What a line's issue means to the customer.
String issueText(AppLocalizations l10n, LineIssueDto issue) =>
    switch (issue.code) {
      CartIssueCode.productUnavailable => l10n.issueProductUnavailable,
      CartIssueCode.optionUnavailable => l10n.issueOptionUnavailable,
      CartIssueCode.stockInsufficient =>
        issue.itemId == null
            ? l10n.issueStock(issue.available ?? 0)
            : l10n.issueItemUnavailable,
      CartIssueCode.itemUnavailable => l10n.issueItemUnavailable,
      CartIssueCode.stemsOutOfRange => l10n.issueStems,
      CartIssueCode.boxCompartmentInvalid ||
      CartIssueCode.boxOverCapacity => l10n.issueBox,
      CartIssueCode.inscriptionNotAllowed => l10n.issueInscription,
    };

class _LineCard extends ConsumerWidget {
  const new({required this.line, required this.quoted});

  final CartLine line;
  final QuotedLineDto? quoted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final cart = ref.read(cartControllerProvider.notifier);
    final q = quoted;
    final title = q?.title.of(context) ?? '…';
    final message = line.kind == CartItemKind.design
        ? (line.spec?['cardMessage'] as String?)
        : null;

    return BBCard(
      padding: const EdgeInsets.all(BBSpacing.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: ProductImage(
                  url: q?.imageUrl,
                  kind: line.kind == CartItemKind.product
                      ? ProductKind.gift
                      : ProductKind.bouquet,
                  label: title,
                  radius: BBRadius.thumb,
                ),
              ),
              const SizedBox(width: BBSpacing.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: BBText.bodyBold),
                    if (q != null && q.summary.of(context).isNotEmpty)
                      Text(q.summary.of(context), style: BBText.xs.muted),
                    if (message != null && message.isNotEmpty)
                      Text(
                        l10n.cartCardMessage(message),
                        style: BBText.xs.muted,
                      ),
                    for (final issue in q?.issues ?? const <LineIssueDto>[])
                      Text(
                        issueText(l10n, issue),
                        style: BBText.xs.copyWith(color: BBColors.onRed),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: BBSpacing.sm),
          Row(
            children: [
              BBQtyStepper(
                value: line.qty,
                max: CartLine.maxQty,
                itemLabel: title,
                onChanged: (v) => cart.setQty(line.id, v),
              ),
              const Spacer(),
              if (line.kind == CartItemKind.design)
                Flexible(
                  child: BBLink(
                    label: l10n.cartEditDesign,
                    onPressed: () async {
                      await ref
                          .read(designerControllerProvider.notifier)
                          .startEditing(line.id, line.spec!);
                      if (context.mounted) context.go(Routes.designer);
                    },
                  ),
                ),
              const SizedBox(width: BBSpacing.sm),
              Text(
                q == null ? '…' : money.primary(q.totalMinor),
                style: BBText.price.merge(BBText.numeric),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CouponField extends ConsumerStatefulWidget {
  const new({required this.result});

  final CouponResultDto? result;

  @override
  ConsumerState<_CouponField> createState() => _CouponFieldState();
}

class _CouponFieldState extends ConsumerState<_CouponField> {
  late final _controller = TextEditingController(
    text: ref.read(couponProvider) ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final applied = ref.watch(couponProvider);
    final result = widget.result;
    final message = switch (result) {
      null => null,
      CouponResultDto(applied: true) => l10n.cartCouponApplied(result.code),
      CouponResultDto(problem: CouponProblem.expired) => l10n.cartCouponExpired,
      CouponResultDto(problem: CouponProblem.usedUp) => l10n.cartCouponUsedUp,
      CouponResultDto(problem: CouponProblem.minOrder) =>
        l10n.cartCouponMinOrder(money.syp(result.minOrderMinor)),
      _ => l10n.cartCouponNotFound,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: BBTextField(
                label: l10n.cartCoupon,
                controller: _controller,
                textDirection: TextDirection.ltr,
                textInputAction: TextInputAction.done,
                onSubmitted: (v) => ref.read(couponProvider.notifier).apply(v),
              ),
            ),
            const SizedBox(width: BBSpacing.sm),
            if (applied == null)
              BBButton(
                label: l10n.cartCouponApply,
                variant: BBButtonVariant.secondary,
                onPressed: () =>
                    ref.read(couponProvider.notifier).apply(_controller.text),
              )
            else
              BBIconButton(
                icon: BBIcons.close,
                tooltip: l10n.cartCouponRemove,
                onPressed: () {
                  _controller.clear();
                  ref.read(couponProvider.notifier).apply(null);
                },
              ),
          ],
        ),
        if (applied != null && message != null) ...[
          const SizedBox(height: BBSpacing.xs),
          Text(
            message,
            style: BBText.xs.copyWith(
              color: result!.applied ? BBColors.onGreen : BBColors.onRed,
            ),
          ),
        ],
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const new({required this.quote, required this.money});

  final CartQuoteDto quote;
  final MoneyFormat money;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final syp = quote.syp;
    final total = syp.totalMinor;
    return BBCard(
      child: Column(
        children: [
          BBKvRow(label: l10n.cartProducts, value: money.syp(syp.itemsMinor)),
          if (syp.assemblyFeeMinor > 0) ...[
            const SizedBox(height: BBSpacing.xs),
            BBKvRow(
              label: l10n.designerAssemblyFee,
              value: money.syp(syp.assemblyFeeMinor),
            ),
          ],
          if (syp.discountMinor > 0) ...[
            const SizedBox(height: BBSpacing.xs),
            BBKvRow(
              label: l10n.cartDiscount,
              value: money.change(-syp.discountMinor),
            ),
          ],
          const SizedBox(height: BBSpacing.xs),
          BBKvRow(
            label: l10n.cartDelivery,
            value: l10n.cartDeliveryLater,
            mutedLabel: true,
          ),
          if (syp.roundingAdjustmentMinor != 0) ...[
            const SizedBox(height: BBSpacing.xs),
            BBKvRow(
              label: l10n.cartRounding,
              value: money.change(syp.roundingAdjustmentMinor),
            ),
          ],
          const Divider(),
          BBKvRow(
            label: l10n.cartSubtotal,
            value: money.syp(total),
            total: true,
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              l10n.priceApprox(money.usd(total)),
              style: BBText.xs.muted.merge(BBText.numeric),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBottom extends ConsumerWidget {
  const new({required this.quote, required this.loading});

  final CartQuoteDto? quote;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final money = ref.watch(moneyFormatProvider);
    final q = quote;
    return BBBottomCta(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.productTotal, style: BBText.xs.muted),
            Text(
              q == null ? '…' : money.primary(q.syp.totalMinor),
              style: BBText.price.merge(BBText.numeric),
            ),
          ],
        ),
        Expanded(
          child: BBButton(
            label: l10n.cartContinue,
            trailing: BBIcons.forward,
            expand: true,
            loading: loading && q == null,
            onPressed: q == null
                ? null
                : () => q.orderable
                      ? context.push(Routes.checkout)
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.cartFixIssues)),
                        ),
          ),
        ),
      ],
    );
  }
}

/// The capsule above the tab bar on home and shop (screens 06, 07).
class CartCapsule extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final count = ref.watch(cartCountProvider);
    if (count == 0) return const SizedBox.shrink();
    final money = ref.watch(moneyFormatProvider);
    final total = ref.watch(currentCartQuoteProvider).value?.syp.totalMinor;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        BBSpacing.page,
        0,
        BBSpacing.page,
        BBSpacing.sm,
      ),
      child: BBCartCapsule(
        title: l10n.cartTitleCount(count),
        total: total == null ? '…' : money.primary(total),
        actionLabel: l10n.cartCheckout,
        onTap: () => context.push(Routes.cart),
      ),
    );
  }
}

/// The bag button with the piece count, for screen headers.
class CartButton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(cartCountProvider);
    return BBIconButton(
      icon: BBIcons.bag,
      tooltip: AppLocalizations.of(context).cartTitleCount(count),
      count: count == 0 ? null : count,
      onPressed: () => context.push(Routes.cart),
    );
  }
}

/// Shows "added" with a way to the cart.
void showAddedToCart(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        // Times out like any other: a kept bar covers checkout.
        persist: false,
        action: SnackBarAction(
          label: l10n.cartView,
          onPressed: () => GoRouter.of(context).push(Routes.cart),
        ),
      ),
    );
}

/// For error snack bars from cart actions.
String cartErrorText(BuildContext context, Object error) =>
    errorText(AppLocalizations.of(context), error);
