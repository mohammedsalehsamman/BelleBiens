import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_buttons.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:flutter/material.dart';

/// The header bar of inner screens (.bar): back button, centered title,
/// optional action. Keeps the title centered with an empty 44 dp slot.
class BBTopBar extends StatelessWidget implements PreferredSizeWidget {
  const new({
    required this.title,
    super.key,
    this.onBack,
    this.backLabel,
    this.action,
  });

  final String title;

  /// Null hides the back button.
  final VoidCallback? onBack;
  final String? backLabel;
  final Widget? action;

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final back = MaterialLocalizations.of(context).backButtonTooltip;
    return Material(
      color: BBColors.canvas,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: BBColors.border)),
          ),
          child: Row(
            children: [
              if (onBack != null)
                BBIconButton(
                  icon: BBIcons.back,
                  tooltip: backLabel ?? back,
                  onPressed: onBack,
                )
              else
                const SizedBox(width: BBSizes.minTouch),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: BBText.h3,
                  ),
                ),
              ),
              action ?? const SizedBox(width: BBSizes.minTouch),
            ],
          ),
        ),
      ),
    );
  }
}

/// A screen: optional top bar, scrolling body with the page gutter and 20 dp
/// between sections (.body), optional fixed bottom area (CTA, cart).
class BBScreen extends StatelessWidget {
  const new({
    required this.children,
    super.key,
    this.topBar,
    this.bottom,
    this.gap = BBSpacing.section,
    this.padding = const EdgeInsets.all(BBSpacing.page),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final PreferredSizeWidget? topBar;
  final List<Widget> children;
  final Widget? bottom;
  final double gap;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: topBar,
      body: SafeArea(
        top: topBar == null,
        bottom: bottom == null,
        child: SingleChildScrollView(
          padding: padding,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                children[i],
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottom,
    );
  }
}

/// The fixed white bar at the bottom of flows (.cta), above the system inset.
class BBBottomCta extends StatelessWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: BBColors.surface,
        border: Border(top: BorderSide(color: BBColors.border)),
        boxShadow: BBShadows.bar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(width: BBSpacing.gutter),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Progress bars of multi-step flows (.steps), with the "Step 2 of 4" caption.
class BBStepsBar extends StatelessWidget {
  const new({
    required this.total,
    required this.current,
    required this.caption,
    super.key,
  });

  final int total;

  /// 1-based.
  final int current;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: caption,
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 1; i <= total; i++) ...[
                if (i > 1) const SizedBox(width: 6),
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= current ? BBColors.primary : BBColors.track,
                      borderRadius: BorderRadius.circular(BBRadius.pill),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: BBSpacing.sm),
          Text(caption, style: BBText.xs.muted),
        ],
      ),
    );
  }
}

/// Section title with an optional subtitle and "see all" link (.sec).
class BBSectionHeader extends StatelessWidget {
  const new({
    required this.title,
    super.key,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(header: true, child: Text(title, style: BBText.h3)),
              if (subtitle != null) Text(subtitle!, style: BBText.xs.muted),
            ],
          ),
        ),
        if (actionLabel != null)
          BBLink(label: actionLabel!, onPressed: onAction),
      ],
    );
  }
}

/// A label / value line of a price summary (.kv, .kv.total).
class BBKvRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    super.key,
    this.total = false,
    this.mutedLabel = false,
    this.longValue = false,
  });

  final String label;
  final String value;
  final bool total;
  final bool mutedLabel;

  /// The value is text rather than an amount (a time, an address), so it
  /// takes the room and wraps at large text sizes.
  final bool longValue;

  @override
  Widget build(BuildContext context) {
    final base = total
        ? BBText.h3.copyWith(fontWeight: FontWeight.w700)
        : BBText.label.copyWith(fontWeight: FontWeight.w400);
    final labelText = Text(label, style: mutedLabel ? base.muted : base);
    final valueText = Text(
      value,
      textAlign: TextAlign.end,
      style: total
          ? BBText.price.copyWith(fontSize: 17)
          : base.merge(BBText.numeric),
    );
    return Row(
      children: longValue
          // A short label, a value that may wrap ("غداً 18:00 – 20:00").
          ? [
              labelText,
              const SizedBox(width: BBSpacing.gutter),
              Expanded(child: valueText),
            ]
          // An amount: the label takes the rest and wraps if it must.
          : [
              Expanded(child: labelText),
              const SizedBox(width: BBSpacing.gutter),
              valueText,
            ],
    );
  }
}

/// "──── or ────" between sign-in options.
class BBOrDivider extends StatelessWidget {
  const new({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BBSpacing.gutter),
            child: Text(label, style: BBText.xs.muted),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

/// The floating cart summary above the bottom navigation (.cap).
class BBCartCapsule extends StatelessWidget {
  const new({
    required this.title,
    required this.total,
    required this.actionLabel,
    required this.onTap,
    super.key,
  });

  /// "Cart · 4 items".
  final String title;

  /// "7,116 SYP".
  final String total;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Semantics(
        button: true,
        label: '$title, $total, $actionLabel',
        excludeSemantics: true,
        child: Material(
          color: BBColors.primary,
          shape: const StadiumBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(BBRadius.pill)),
                boxShadow: BBShadows.capsule,
              ),
              child: Padding(
                padding: const EdgeInsets.all(BBSpacing.sm),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0x29FFFFFF),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const BBIcon(
                        BBIcons.bag,
                        size: 22,
                        color: BBColors.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: BBText.label.withColor(BBColors.onPrimary),
                          ),
                          Text(
                            total,
                            style: BBText.small
                                .merge(BBText.numeric)
                                .withColor(const Color(0xE6FFFFFF)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minHeight: 40),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: const BoxDecoration(
                        color: BBColors.surface,
                        borderRadius: BorderRadius.all(
                          Radius.circular(BBRadius.pill),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            actionLabel,
                            style: BBText.label.withColor(BBColors.primary),
                          ),
                          const SizedBox(width: 6),
                          const BBIcon(
                            BBIcons.forward,
                            size: 18,
                            color: BBColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
