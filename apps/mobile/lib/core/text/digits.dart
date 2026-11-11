/// FR-LOC-02: Western digits (0-9) by default; Arabic-Indic digits as a user
/// setting.
enum Numerals { western, arabic }

const _arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

/// Rewrites every Western digit in [text] for display.
String localizeDigits(String text, Numerals numerals) {
  if (numerals == Numerals.western) return text;
  final buffer = StringBuffer();
  for (final unit in text.codeUnits) {
    if (unit >= 0x30 && unit <= 0x39) {
      buffer.write(_arabicIndic[unit - 0x30]);
    } else {
      buffer.writeCharCode(unit);
    }
  }
  return buffer.toString();
}

/// Turns Arabic-Indic (U+0660..) and Extended Arabic-Indic (U+06F0..) digits
/// typed on an Arabic keyboard into Western digits before parsing.
String westernizeDigits(String text) {
  final buffer = StringBuffer();
  for (final unit in text.codeUnits) {
    if (unit >= 0x0660 && unit <= 0x0669) {
      buffer.writeCharCode(0x30 + unit - 0x0660);
    } else if (unit >= 0x06F0 && unit <= 0x06F9) {
      buffer.writeCharCode(0x30 + unit - 0x06F0);
    } else {
      buffer.writeCharCode(unit);
    }
  }
  return buffer.toString();
}
