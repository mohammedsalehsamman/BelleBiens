// Dates in messages the way the shop writes them (FR-LOC-03): Levantine
// month names in Arabic ("12 تشرين الثاني"), Western digits.

const LEVANTINE_MONTHS = [
  'كانون الثاني',
  'شباط',
  'آذار',
  'نيسان',
  'أيار',
  'حزيران',
  'تموز',
  'آب',
  'أيلول',
  'تشرين الأول',
  'تشرين الثاني',
  'كانون الأول',
];

const ENGLISH_MONTHS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/** "12 تشرين الثاني" or "November 12" for a YYYY-MM-DD date. */
export function dayMonthText(date: string, language: 'ar' | 'en'): string {
  const [, month, day] = date.split('-').map(Number) as [
    number,
    number,
    number,
  ];
  return language === 'en'
    ? `${ENGLISH_MONTHS[month - 1]} ${day}`
    : `${day} ${LEVANTINE_MONTHS[month - 1]}`;
}
