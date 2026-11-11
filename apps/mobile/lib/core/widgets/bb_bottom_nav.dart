import 'package:belle_biens/app/theme/bb_theme.dart';
import 'package:belle_biens/app/theme/tokens.dart';
import 'package:flutter/material.dart';

class BBNavItem {
  const new({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Bottom navigation from the HTML screens: five tabs, with "Design your
/// bouquet" raised in the middle as a primary circle (DESIGN.md, component 6).
/// Material icons stand in until the SVG icon set lands in S1.
class BBBottomNav extends StatelessWidget {
  const new({
    required this.items,
    required this.currentIndex,
    required this.onSelect,
    this.centerIndex = 2,
    super.key,
  }) : assert(items.length == 5, 'The design has exactly five tabs');

  final List<BBNavItem> items;
  final int currentIndex;
  final int centerIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xF7FFFCFA),
        border: Border(top: BorderSide(color: BBColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavButton(
                    item: items[i],
                    selected: i == currentIndex,
                    raised: i == centerIndex,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const new({
    required this.item,
    required this.selected,
    required this.raised,
    required this.onTap,
  });

  final BBNavItem item;
  final bool selected;
  final bool raised;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? BBColors.primary : context.bb.textMuted;
    final label = Text(
      item.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 11.5,
        color: color,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
    );

    final icon = raised
        ? Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              width: BBSizes.navCenter,
              height: BBSizes.navCenter,
              decoration: BoxDecoration(
                color: BBColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: BBColors.canvas, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80872341),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                    spreadRadius: -6,
                  ),
                ],
              ),
              child: Icon(item.icon, color: BBColors.onPrimary, size: 26),
            ),
          )
        : Icon(item.icon, color: color, size: 24);

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (raised)
                SizedBox(height: 38, child: OverflowBox(child: icon))
              else
                icon,
              const SizedBox(height: 2),
              label,
            ],
          ),
        ),
      ),
    );
  }
}
