import { dayMonthText } from './date-text.js';

describe('dayMonthText (FR-LOC-03)', () => {
  it('uses the Levantine month names in Arabic', () => {
    expect(dayMonthText('2026-11-12', 'ar')).toBe('12 تشرين الثاني');
    expect(dayMonthText('2027-01-03', 'ar')).toBe('3 كانون الثاني');
    expect(dayMonthText('2026-11-12', 'en')).toBe('November 12');
  });
});
