import 'package:belle_biens/app/l10n/gen/app_localizations.dart';
import 'package:belle_biens/app/router/routes.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/media/image_picker.dart';
import 'package:belle_biens/core/network/error_text.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:belle_biens/core/widgets/bb_inputs.dart';
import 'package:belle_biens/core/widgets/bb_layout.dart';
import 'package:belle_biens/core/widgets/bb_surfaces.dart';
import 'package:belle_biens/features/catalog/application/catalog_providers.dart';
import 'package:belle_biens/features/catalog/presentation/widgets/catalog_widgets.dart';
import 'package:belle_biens/features/orders/application/orders_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen 24: pay in the Sham Cash app, then send the transaction number
/// or a receipt photo for the shop to check (FR-PAY-03). Also screen 38's
/// "إعادة إرسال الإيصال".
class ShamCashScreen extends ConsumerStatefulWidget {
  const new({required this.number, super.key});

  final String number;

  @override
  ConsumerState<ShamCashScreen> createState() => _ShamCashScreenState();
}

class _ShamCashScreenState extends ConsumerState<ShamCashScreen> {
  final _reference = TextEditingController();
  String? _receiptUrl;
  bool _uploading = false;
  bool _sending = false;

  @override
  void dispose() {
    _reference.dispose();
    super.dispose();
  }

  void _tell(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _attach() async {
    final l10n = AppLocalizations.of(context);
    final picked = await ref.read(imagePickerProvider)();
    if (picked == null) return;
    setState(() => _uploading = true);
    try {
      final url = await ref
          .read(ordersRepositoryProvider)
          .uploadReceipt(picked.bytes, picked.name);
      if (mounted) setState(() => _receiptUrl = url);
    } on Object catch (error) {
      if (mounted) _tell(errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final reference = _reference.text.trim();
    if (reference.isEmpty && _receiptUrl == null) {
      return _tell(l10n.shamcashNeedProof);
    }
    setState(() => _sending = true);
    try {
      final order = await ref
          .read(orderActionsProvider)
          .sendProof(
            widget.number,
            reference: reference.isEmpty ? null : reference,
            receiptUrl: _receiptUrl,
          );
      if (mounted) {
        context.go(Routes.orderConfirmed(order.number), extra: order);
      }
    } on Object catch (error) {
      if (mounted) _tell(errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _payCash() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _sending = true);
    try {
      final order = await ref.read(orderActionsProvider).payCash(widget.number);
      if (mounted) {
        context.go(Routes.orderConfirmed(order.number), extra: order);
      }
    } on Object catch (error) {
      if (mounted) _tell(errorText(l10n, error));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final order = ref.watch(orderProvider(widget.number));
    final account = ref
        .watch(appConfigProvider)
        .value
        ?.payments
        .shamcashAccount;
    final money = ref.watch(moneyFormatProvider);

    return Scaffold(
      appBar: BBTopBar(
        title: l10n.shamcashTitle,
        onBack: () => Navigator.of(context).maybePop(),
      ),
      body: switch (order) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(BBSpacing.page),
          children: [
            BBCard(
              color: BBColors.surfaceLow,
              child: Column(
                children: [
                  Text(
                    l10n.shamcashAmountFor(value.number),
                    style: BBText.small.muted,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: BBSpacing.xs),
                  Text(
                    money.syp(value.syp.totalMinor),
                    style: BBText.price.copyWith(fontSize: 28),
                  ),
                  if (value.paymentDueAt != null) ...[
                    const SizedBox(height: BBSpacing.sm),
                    _Countdown(due: value.paymentDueAt!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: BBSpacing.section),
            Semantics(
              header: true,
              child: Text(l10n.shamcashSteps, style: BBText.h3),
            ),
            const SizedBox(height: BBSpacing.sm),
            _Step(n: 1, child: Text(l10n.shamcashStep1, style: BBText.small)),
            const SizedBox(height: BBSpacing.sm),
            _Step(
              n: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.shamcashStep2, style: BBText.small),
                  const SizedBox(height: BBSpacing.xs),
                  if (account == null)
                    Text(l10n.shamcashNoAccount, style: BBText.small.muted)
                  else
                    _Account(account: account),
                ],
              ),
            ),
            const SizedBox(height: BBSpacing.sm),
            _Step(n: 3, child: Text(l10n.shamcashStep3, style: BBText.small)),
            const SizedBox(height: BBSpacing.md),
            BBTextField(
              label: l10n.shamcashReference,
              controller: _reference,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
            ),
            const SizedBox(height: BBSpacing.gutter),
            BBCard(
              dashed: _receiptUrl == null,
              onTap: _uploading ? null : _attach,
              child: Row(
                children: [
                  BBIconBox(
                    _receiptUrl == null ? BBIcons.upload : BBIcons.check,
                    size: 40,
                  ),
                  const SizedBox(width: BBSpacing.gutter),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _receiptUrl == null
                              ? l10n.shamcashAttach
                              : l10n.shamcashAttached,
                          style: BBText.small.bold,
                        ),
                        Text(l10n.shamcashAttachHint, style: BBText.xs.muted),
                      ],
                    ),
                  ),
                  if (_uploading)
                    const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
            const SizedBox(height: BBSpacing.md),
            BBNotice(text: l10n.shamcashAfter, icon: BBIcons.info),
            const SizedBox(height: BBSpacing.md),
            BBButton(
              label: l10n.shamcashChangeMethod,
              variant: BBButtonVariant.quiet,
              expand: true,
              onPressed: _sending ? null : _payCash,
            ),
            const SizedBox(height: BBSpacing.lg),
          ],
        ),
        AsyncError(:final error) => ErrorRetry(
          error: error,
          onRetry: () => ref.invalidate(orderProvider(widget.number)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
      bottomNavigationBar: order.hasValue
          ? BBBottomCta(
              children: [
                Expanded(
                  child: BBButton(
                    label: l10n.shamcashSent,
                    expand: true,
                    loading: _sending,
                    onPressed: _uploading ? null : _send,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

/// "أكمل الدفع خلال 01:54:20" (FR-PAY-10).
class _Countdown extends ConsumerWidget {
  const new({required this.due});

  final DateTime due;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final now =
        ref.watch(nowTickerProvider).value ?? ref.watch(clockProvider)();
    final over = !due.isAfter(now);
    return BBBadge(
      label: over
          ? l10n.shamcashExpired
          : l10n.shamcashPayWithin(countdownText(due, now)),
      tone: over ? BBBadgeTone.red : BBBadgeTone.amber,
      icon: BBIcons.clock,
    );
  }
}

class _Account extends StatelessWidget {
  const new({required this.account});

  final String account;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BBCard(
      padding: const EdgeInsets.symmetric(
        horizontal: BBSpacing.gutter,
        vertical: BBSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              account,
              style: BBText.bodyBold.merge(BBText.numeric),
              textDirection: TextDirection.ltr,
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: account));
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.shamcashCopied)));
              }
            },
            icon: const BBIcon(BBIcons.copy, size: 18),
            label: Text(l10n.shamcashCopy),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const new({required this.n, required this.child});

  final int n;
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: BBColors.blush,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$n',
          style: BBText.small.bold.copyWith(color: BBColors.onBlush),
        ),
      ),
      const SizedBox(width: BBSpacing.gutter),
      Expanded(child: child),
    ],
  );
}
