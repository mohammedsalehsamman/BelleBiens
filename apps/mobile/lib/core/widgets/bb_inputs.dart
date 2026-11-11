import 'package:belle_biens/app/theme/tokens.dart';
import 'package:belle_biens/app/theme/typography.dart';
import 'package:belle_biens/core/widgets/bb_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A labelled text field (.field / .inp): label above, hint or error below,
/// optional character counter like "22 / 200".
class BBTextField extends StatelessWidget {
  const new({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.helper,
    this.error,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.prefix,
    this.suffix,
    this.textDirection,
    this.enabled = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? helper;
  final String? error;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  /// Shows a "n / max" counter next to the label and stops typing at max.
  final int? maxLength;
  final int maxLines;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  /// Widget shown at the logical start inside the field (e.g. an icon).
  final Widget? prefix;

  /// Widget shown at the logical end inside the field.
  final Widget? suffix;

  /// Force a direction: phone numbers and emails are typed left to right.
  final TextDirection? textDirection;
  final bool enabled;
  final bool autofocus;

  /// Phone numbers sit on the reading side even though they are typed LTR.
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: BBText.label)),
            if (maxLength != null && controller != null)
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller!,
                builder: (context, value, _) => Text(
                  '${value.text.characters.length} / $maxLength',
                  style: BBText.xs.muted.merge(BBText.numeric),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          autofocus: autofocus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          autofillHints: autofillHints,
          maxLines: maxLines,
          minLines: maxLines > 1 ? 3 : 1,
          textDirection: textDirection,
          textAlign: textAlign,
          inputFormatters: [
            if (maxLength != null)
              LengthLimitingTextInputFormatter(
                maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
              ),
            ...?inputFormatters,
          ],
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: BBText.body,
          decoration: InputDecoration(
            hintText: hint,
            // Phone numbers and emails keep their order inside Arabic screens.
            hintTextDirection: textDirection,
            errorText: error,
            errorMaxLines: 3,
            prefixIcon: prefix,
            suffixIcon: suffix,
            constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
          ),
        ),
        if (helper != null && error == null) ...[
          const SizedBox(height: 6),
          Text(helper!, style: BBText.xs.muted),
        ],
      ],
    );
  }
}

/// The square checkbox with a label (.box), at least 48 dp tall.
class BBCheckbox extends StatelessWidget {
  const new({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  /// Any widget, so labels can hold links ("I accept the terms").
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        checked: value,
        child: InkWell(
          onTap: onChanged == null ? null : () => onChanged!(!value),
          borderRadius: BorderRadius.circular(BBRadius.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
            child: Row(
              children: [
                _Box(checked: value),
                const SizedBox(width: BBSpacing.gutter),
                Expanded(child: label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const new({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: checked ? BBColors.primary : BBColors.surface,
        border: Border.all(
          color: checked ? BBColors.primary : BBColors.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: checked
          ? const BBIcon(BBIcons.check, size: 16, color: BBColors.onPrimary)
          : null,
    );
  }
}

/// A selectable card row with a radio or checkbox (.opt / .opt.on).
class BBOptionTile extends StatelessWidget {
  const new({
    required this.title,
    required this.selected,
    required this.onTap,
    super.key,
    this.subtitle,
    this.trailing,
    this.multiple = false,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? trailing;

  /// A checkbox instead of a radio.
  final bool multiple;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      checked: multiple ? selected : null,
      inMutuallyExclusiveGroup: !multiple,
      button: true,
      child: Material(
        color: selected ? BBColors.optionSelected : BBColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BBRadius.option),
          side: BorderSide(
            color: selected ? BBColors.primary : BBColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(BBRadius.option),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: multiple
                      ? _Box(checked: selected)
                      : _Radio(selected: selected),
                ),
                const SizedBox(width: BBSpacing.gutter),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: BBText.small.bold),
                      if (subtitle != null)
                        Text(subtitle!, style: BBText.xs.muted),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: BBSpacing.sm),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const new({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? BBColors.primary : BBColors.surface,
        border: Border.all(
          color: selected ? BBColors.primary : BBColors.outline,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: BBColors.surface,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

/// On/off switch (.toggle): 48 x 28, Bordeaux when on.
class BBToggle extends StatelessWidget {
  const new({
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      label: semanticLabel,
      button: true,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: BBSizes.minTouch,
          height: BBSizes.minTouch,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 48,
              height: 28,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: value ? BBColors.primary : BBColors.toggleOff,
                borderRadius: BorderRadius.circular(BBRadius.pill),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 150),
                alignment: value
                    ? AlignmentDirectional.centerEnd
                    : AlignmentDirectional.centerStart,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: BBColors.surface,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Segmented pill control (.seg), for 2 to 4 choices.
class BBSegmented<T> extends StatelessWidget {
  const new({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
    this.dense = false,
  });

  final List<(T value, String label)> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  /// 36 dp segments for the header currency switch.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final inset = dense ? 3.0 : 4.0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: BBColors.surfaceMuted,
        borderRadius: BorderRadius.circular(BBRadius.pill),
      ),
      child: Row(
        children: [
          for (final (i, (value, label)) in segments.indexed)
            Expanded(
              child: Semantics(
                selected: value == selected,
                button: true,
                inMutuallyExclusiveGroup: true,
                // The track's padding is part of each segment's tap area, so
                // a 40 dp pill still gets a 48 dp touch target (NFR-INT-03).
                child: GestureDetector(
                  onTap: () => onChanged(value),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      i == 0 ? inset : inset / 2,
                      inset,
                      i == segments.length - 1 ? inset : inset / 2,
                      inset,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      constraints: BoxConstraints(minHeight: dense ? 36 : 40),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: value == selected
                            ? BBColors.surface
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(BBRadius.pill),
                        boxShadow: value == selected
                            ? const [
                                BoxShadow(
                                  color: Color(0x142C2422),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: BBText.label.copyWith(
                          color: value == selected
                              ? BBColors.primary
                              : BBColors.textVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A capsule filter or category chip (.chip / .chip.on).
class BBChip extends StatelessWidget {
  const new({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
    this.icon,
  });

  final String label;
  final bool selected;

  /// Null shows the chip as unavailable (for example a full time slot).
  final VoidCallback? onTap;
  final BBIcons? icon;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? BBColors.onPrimary : BBColors.text;
    return Semantics(
      selected: selected,
      enabled: onTap != null,
      button: true,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Material(
          color: selected ? BBColors.primary : BBColors.surface,
          shape: StadiumBorder(
            side: BorderSide(
              color: selected ? BBColors.primary : BBColors.borderStrong,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const StadiumBorder(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: BBSizes.minTouch),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      BBIcon(icon!, size: 16, color: fg),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: BBText.label.copyWith(
                        fontWeight: FontWeight.w500,
                        color: fg,
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

/// Quantity control (.qty): "+" on the logical start, as in the designs.
class BBQtyStepper extends StatelessWidget {
  const new({
    required this.value,
    required this.onChanged,
    required this.itemLabel,
    super.key,
    this.min = 0,
    this.max,
  });

  final int value;
  final ValueChanged<int> onChanged;

  /// Used in "Add one red rose" style labels for screen readers.
  final String itemLabel;
  final int min;

  /// Upper limit, for example the stems in stock (FR-DSG-03).
  final int? max;

  @override
  Widget build(BuildContext context) {
    final canAdd = max == null || value < max!;
    final canRemove = value > min;
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: BBColors.surface,
        border: Border.all(color: BBColors.borderStrong),
        borderRadius: BorderRadius.circular(BBRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: BBIcons.plus,
            label: '+ $itemLabel',
            onTap: canAdd ? () => onChanged(value + 1) : null,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 28),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: BBText.bodyBold.merge(BBText.numeric),
            ),
          ),
          _StepButton(
            icon: BBIcons.minus,
            label: '− $itemLabel',
            onTap: canRemove ? () => onChanged(value - 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final BBIcons icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 40 dp drawn, 48 dp touch target (NFR-INT-03).
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.square(
          dimension: BBSizes.minTouch,
          child: Center(
            child: Container(
              width: BBSizes.stepperButton,
              height: BBSizes.stepperButton,
              decoration: BoxDecoration(
                color: onTap == null ? BBColors.gray : BBColors.surfaceLow,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: BBIcon(
                icon,
                size: 18,
                color: onTap == null ? BBColors.textMuted : BBColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One box per digit (screen 04), typed left to right in both languages.
/// Backed by a single hidden field, so paste and SMS autofill work.
class BBOtpInput extends StatefulWidget {
  const new({
    required this.length,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
    this.onCompleted,
    this.autofocus = true,
    this.hasError = false,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final String semanticLabel;
  final bool autofocus;
  final bool hasError;

  @override
  State<BBOtpInput> createState() => _BBOtpInputState();
}

class _BBOtpInputState extends State<BBOtpInput> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_changed);
    _focus.addListener(() => setState(() {}));
  }

  void _changed() {
    final value = _controller.text;
    widget.onChanged(value);
    if (value.length == widget.length) widget.onCompleted?.call(value);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    return Semantics(
      label: widget.semanticLabel,
      textField: true,
      value: text,
      child: GestureDetector(
        onTap: _focus.requestFocus,
        child: Stack(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.length; i++) ...[
                    if (i > 0) const SizedBox(width: BBSpacing.gutter),
                    _DigitBox(
                      digit: i < text.length ? text[i] : '',
                      active:
                          _focus.hasFocus &&
                          (i == text.length ||
                              (i == widget.length - 1 &&
                                  text.length == widget.length)),
                      error: widget.hasError,
                    ),
                  ],
                ],
              ),
            ),
            // The real input: invisible, on top, receives typing and paste.
            Positioned.fill(
              child: Opacity(
                opacity: 0,
                child: ExcludeSemantics(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focus,
                    autofocus: widget.autofocus,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    showCursor: false,
                    enableInteractiveSelection: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(widget.length),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitBox extends StatelessWidget {
  const new({required this.digit, required this.active, required this.error});

  final String digit;
  final bool active;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final borderColor = error
        ? BBColors.error
        : active
        ? BBColors.primary
        : BBColors.borderStrong;
    return Container(
      width: 64,
      height: 68,
      decoration: BoxDecoration(
        color: BBColors.surface,
        borderRadius: BorderRadius.circular(BBRadius.option),
        border: Border.all(color: borderColor, width: active || error ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: Text(
        digit,
        style: BBText.h1.copyWith(
          color: BBColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
