import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:flutter/material.dart';

/// Button styles from the screens' CSS: .btn-p, .btn-s, .btn-g, .btn-w, and the
/// quiet text button used for "continue as guest".
enum BBButtonVariant { primary, secondary, soft, whatsapp, quiet, onPrimary }

/// The pill button used across the app (DESIGN.md "Buttons"): 48 dp tall
/// (44 dp small), at least 48 dp touch target (NFR-INT-03).
class BBButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = BBButtonVariant.primary,
    this.leading,
    this.trailing,
    this.expand = false,
    this.small = false,
    this.loading = false,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final BBButtonVariant variant;
  final BBIcons? leading;
  final BBIcons? trailing;

  /// Takes the full width, like `.full`.
  final bool expand;
  final bool small;

  /// Shows a spinner and ignores taps, keeping the label for screen readers.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, border) = switch (variant) {
      BBButtonVariant.primary => (BBColors.primary, BBColors.onPrimary, null),
      BBButtonVariant.secondary => (
        BBColors.surface,
        BBColors.primary,
        const BorderSide(color: BBColors.primary, width: 1.5),
      ),
      BBButtonVariant.soft => (BBColors.blush, BBColors.onBlush, null),
      BBButtonVariant.whatsapp => (BBColors.whatsapp, BBColors.onPrimary, null),
      BBButtonVariant.quiet => (Colors.transparent, BBColors.textMuted, null),
      BBButtonVariant.onPrimary => (BBColors.surface, BBColors.primary, null),
    };
    final enabled = onPressed != null && !loading;
    final height = small ? 44.0 : BBSizes.buttonHeight;
    final textStyle = BBText.button.copyWith(fontSize: small ? 14 : 15);

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          )
        else if (leading != null)
          BBIcon(leading!, size: 18, color: foreground),
        if (loading || leading != null) const SizedBox(width: BBSpacing.sm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle.copyWith(color: foreground),
          ),
        ),
        if (trailing != null && !loading) ...[
          const SizedBox(width: BBSpacing.sm),
          BBIcon(trailing!, size: 18, color: foreground),
        ],
      ],
    );

    final button = Semantics(
      button: true,
      enabled: enabled,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: enabled || variant == BBButtonVariant.quiet
            ? background
            : background.withValues(alpha: 0.5),
        shape: StadiumBorder(side: border ?? BorderSide.none),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height,
              minWidth: BBSizes.minTouch,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: small ? 16 : 20),
              child: Opacity(opacity: enabled ? 1 : 0.7, child: content),
            ),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// The 44 dp round outlined icon button of the top bars (.ib), with an
/// optional count dot (cart, notifications).
class BBIconButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
    this.count,
    this.size = 20,
  });

  final BBIcons icon;

  /// Read by screen readers; every icon-only button needs one (NFR-INT-02).
  final String tooltip;
  final VoidCallback? onPressed;
  final int? count;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: BBSizes.minTouch,
        child: Center(
          child: Material(
            color: BBColors.surface,
            shape: const CircleBorder(side: BorderSide(color: BBColors.border)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox.square(
                dimension: BBSizes.iconButton,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    BBIcon(icon, size: size, color: BBColors.text),
                    if (count != null && count! > 0)
                      PositionedDirectional(
                        top: 4,
                        end: 4,
                        child: _CountDot(count: count!),
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

class _CountDot extends StatelessWidget {
  const new({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: BBColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(BBRadius.pill)),
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: BBText.xs.copyWith(
          fontSize: 11,
          height: 1.2,
          fontWeight: FontWeight.w600,
          color: BBColors.onPrimary,
        ),
      ),
    );
  }
}

/// An inline text link (.link): Bordeaux, semibold, 48 dp tall touch area.
class BBLink extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.color = BBColors.primary,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final BBIcons? leading;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(BBRadius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: BBSizes.minTouch,
            minWidth: BBSizes.minTouch,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  BBIcon(leading!, size: 16, color: color),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: BBText.label.withColor(color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
