/// Search normalization (FR-CAT-04), the same rules as the API
/// (apps/api/src/common/text/arabic-normalize.ts) and the shared vectors in
/// packages/contracts/vectors/arabic-normalize.json. Used for offline search
/// over the cached catalog.
String normalizeArabic(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    // 1. Diacritics and tatweel.
    if ((rune >= 0x064B && rune <= 0x065F) ||
        rune == 0x0670 ||
        rune == 0x0640) {
      continue;
    }
    // 5. Arabic-Indic and Extended Arabic-Indic digits.
    if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(0x30 + rune - 0x0660);
      continue;
    }
    if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(0x30 + rune - 0x06F0);
      continue;
    }
    buffer.writeCharCode(switch (rune) {
      // 2. Alef forms.
      0x0622 || 0x0623 || 0x0625 || 0x0671 => 0x0627,
      // 3. Ta marbuta.
      0x0629 => 0x0647,
      // 4. Alef maqsura.
      0x0649 => 0x064A,
      // 6. Latin capitals.
      >= 0x41 && <= 0x5A => rune + 0x20,
      _ => rune,
    });
  }
  // 7. Whitespace.
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// The words of a query, normalized. Every word must appear to match.
List<String> searchTokens(String query) {
  final normalized = normalizeArabic(query);
  return normalized.isEmpty ? const [] : normalized.split(' ');
}

/// True when every word of [query] appears in one of [fields].
bool matchesQuery(String query, Iterable<String> fields) {
  final tokens = searchTokens(query);
  if (tokens.isEmpty) return false;
  final haystack = normalizeArabic(fields.join(' '));
  return tokens.every(haystack.contains);
}
