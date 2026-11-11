/**
 * Filter words for colors and flower types (screen 09, FR-CAT-02). Products store the
 * slugs; names come from here so both languages stay in step. Occasions live in their
 * own table because each has a page (screen 11).
 */
export interface VocabularyEntry {
  slug: string;
  ar: string;
  en: string;
  swatch?: string;
}

export const COLORS: readonly VocabularyEntry[] = [
  { slug: 'red', ar: 'أحمر', en: 'Red', swatch: '#B3263E' },
  { slug: 'pink', ar: 'وردي', en: 'Pink', swatch: '#E8A3B5' },
  { slug: 'white', ar: 'أبيض', en: 'White', swatch: '#FFFFFF' },
  { slug: 'pastel', ar: 'باستيل', en: 'Pastel', swatch: '#E9D8E4' },
  { slug: 'yellow', ar: 'أصفر', en: 'Yellow', swatch: '#F2C94C' },
];

export const FLOWER_TYPES: readonly VocabularyEntry[] = [
  { slug: 'rose', ar: 'جوري', en: 'Rose' },
  { slug: 'peony', ar: 'بيوني', en: 'Peony' },
  { slug: 'tulip', ar: 'توليب', en: 'Tulip' },
  { slug: 'lisianthus', ar: 'ليزيانثوس', en: 'Lisianthus' },
  { slug: 'hydrangea', ar: 'هيدرانجيا', en: 'Hydrangea' },
];

export const COLOR_SLUGS = COLORS.map((c) => c.slug);
export const FLOWER_TYPE_SLUGS = FLOWER_TYPES.map((f) => f.slug);
