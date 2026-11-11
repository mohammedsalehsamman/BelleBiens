/**
 * Search normalization (FR-CAT-04), rules in packages/contracts/vectors/arabic-normalize.json.
 * The stored search column and the customer's query both go through this, so
 * "باقة الجوري" finds "باقه الجوري" and "إهداء" finds "اهداء". The app's offline
 * search uses the same rules (lib/core/text/arabic_normalize.dart).
 */
export function normalizeArabic(input: string): string {
  return input
    .replace(/[ً-ٰٟـ]/g, '')
    .replace(/[آأإٱ]/g, 'ا')
    .replace(/ة/g, 'ه')
    .replace(/ى/g, 'ي')
    .replace(/[٠-٩]/g, (d) => String(d.charCodeAt(0) - 0x0660))
    .replace(/[۰-۹]/g, (d) => String(d.charCodeAt(0) - 0x06f0))
    .replace(/[A-Z]/g, (c) => c.toLowerCase())
    .replace(/\s+/g, ' ')
    .trim();
}

/** The words of a query, normalized. Every word must appear for a product to match. */
export function searchTokens(query: string): string[] {
  const normalized = normalizeArabic(query);
  return normalized === '' ? [] : normalized.split(' ');
}
