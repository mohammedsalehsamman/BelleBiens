import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:flutter/material.dart';

/// White card with a hairline border and soft shadow (.card, DESIGN.md tier 1).
class BBCard extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(BBSpacing.md),
    this.onTap,
    this.color = BBColors.surface,
    this.borderColor = BBColors.border,
    this.dashed = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color color;
  final Color borderColor;

  /// Dashed placeholder cards ("[real reviews appear here]").
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(BBRadius.card);
    final content = Padding(padding: padding, child: child);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        border: Border.all(color: borderColor),
        boxShadow: dashed ? null : BBShadows.card,
      ),
      child: onTap == null
          ? content
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: content,
              ),
            ),
    );
  }
}

enum BBTone { blush, sage }

/// The rounded square that holds an icon in list rows and cards (.icobox).
class BBIconBox extends StatelessWidget {
  const new(this.icon, {super.key, this.tone = BBTone.blush, this.size = 44});

  final BBIcons icon;
  final BBTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (tone) {
      BBTone.blush => (BBColors.blush, BBColors.primary),
      BBTone.sage => (BBColors.sage, BBColors.onSage),
    };
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(BBRadius.thumb),
      ),
      alignment: Alignment.center,
      child: BBIcon(icon, size: size * 0.5, color: foreground),
    );
  }
}

/// The large round icon at the top of status screens (.hero-ic).
class BBHeroIcon extends StatelessWidget {
  const new(this.icon, {super.key});

  final BBIcons icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      height: 88,
      decoration: const BoxDecoration(
        color: BBColors.blush,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: BBIcon(icon, size: 40, color: BBColors.primary),
    );
  }
}

enum BBNoticeTone { info, ok, warn, error }

/// An inline message with an icon (.notice). Errors are announced to screen
/// readers as live regions.
class BBNotice extends StatelessWidget {
  const new({
    required this.text,
    super.key,
    this.tone = BBNoticeTone.info,
    this.icon,
  });

  final String text;
  final BBNoticeTone tone;
  final BBIcons? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg, defaultIcon) = switch (tone) {
      BBNoticeTone.info => (
        BBColors.noticeInfoBg,
        BBColors.noticeInfoBorder,
        BBColors.noticeInfoText,
        BBIcons.info,
      ),
      BBNoticeTone.ok => (
        BBColors.noticeOkBg,
        BBColors.noticeOkBorder,
        BBColors.noticeOkText,
        BBIcons.check,
      ),
      BBNoticeTone.warn => (
        BBColors.noticeWarnBg,
        BBColors.noticeWarnBorder,
        BBColors.noticeWarnText,
        BBIcons.warning,
      ),
      BBNoticeTone.error => (
        BBColors.noticeErrBg,
        BBColors.noticeErrBorder,
        BBColors.noticeErrText,
        BBIcons.warning,
      ),
    };
    return Semantics(
      liveRegion: tone == BBNoticeTone.error,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(BBSpacing.gutter),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(BBRadius.thumb),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: BBIcon(icon ?? defaultIcon, size: 18, color: fg),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: BBText.small.withColor(fg))),
          ],
        ),
      ),
    );
  }
}

enum BBBadgeTone { sage, blush, amber, green, red, gray, dark }

/// A small status pill (.badge and its tones).
class BBBadge extends StatelessWidget {
  const new({
    required this.label,
    super.key,
    this.tone = BBBadgeTone.blush,
    this.icon,
  });

  final String label;
  final BBBadgeTone tone;
  final BBIcons? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      BBBadgeTone.sage => (BBColors.sage, BBColors.onSage),
      BBBadgeTone.blush => (BBColors.blush, BBColors.onBlush),
      BBBadgeTone.amber => (BBColors.amber, BBColors.onAmber),
      BBBadgeTone.green => (BBColors.green, BBColors.onGreen),
      BBBadgeTone.red => (BBColors.red, BBColors.onRed),
      BBBadgeTone.gray => (BBColors.gray, BBColors.onGray),
      BBBadgeTone.dark => (const Color(0xC72C2422), BBColors.onPrimary),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(BBRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            BBIcon(icon!, size: 14, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: BBText.xs.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              height: 20 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// A white rounded group of rows (.list / .li), for settings and account menus.
class BBListGroup extends StatelessWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BBColors.surface,
        border: Border.all(color: BBColors.border),
        borderRadius: BorderRadius.circular(BBRadius.card),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(BBRadius.card),
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              children[i],
            ],
          ],
        ),
      ),
    );
  }
}

class BBListTile extends StatelessWidget {
  const new({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;

  /// Defaults to a forward chevron when the row is tappable.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: BBSpacing.gutter),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: BBText.bodyBold),
                      if (subtitle != null)
                        Text(subtitle!, style: BBText.xs.muted),
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing!
                else if (onTap != null)
                  const BBIcon(
                    BBIcons.chevronRight,
                    size: 18,
                    color: BBColors.textMuted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
