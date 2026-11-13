// Pure rules for notifications: when to try again (FR-NTF-07) and when an
// occasion is next due a reminder (FR-ACC-07).

/** Minutes to wait after each failed try; after the last, it fails for good. */
export const RETRY_MINUTES = [1, 5, 30, 120] as const;
export const MAX_ATTEMPTS = RETRY_MINUTES.length + 1;

/** The wait after `attempts` failed tries, or null when none is left. */
export function retryDelayMinutes(attempts: number): number | null {
  return attempts < MAX_ATTEMPTS ? (RETRY_MINUTES[attempts - 1] ?? null) : null;
}

/**
 * The next time a yearly occasion falls on or after `today` (both
 * YYYY-MM-DD). 29 February is kept on 28 February in other years.
 */
export function nextOccurrence(date: string, today: string): string {
  const [, month, day] = date.split('-').map(Number) as [
    number,
    number,
    number,
  ];
  const year = Number(today.slice(0, 4));
  const on = (y: number) => {
    const leap = (y % 4 === 0 && y % 100 !== 0) || y % 400 === 0;
    const d = month === 2 && day === 29 && !leap ? 28 : day;
    return `${y}-${String(month).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
  };
  const thisYear = on(year);
  return thisYear >= today ? thisYear : on(year + 1);
}

/** Whole days from `from` to `to` (YYYY-MM-DD). */
export function daysBetween(from: string, to: string): number {
  return Math.round(
    (Date.parse(`${to}T00:00:00Z`) - Date.parse(`${from}T00:00:00Z`)) /
      86_400_000,
  );
}

/**
 * The occurrence to remind about today, or null: inside the reminder
 * window and not already reminded for that occurrence.
 */
export function reminderDue(
  occasion: {
    date: string;
    remindDaysBefore: number;
    remindedFor: string | null;
  },
  today: string,
): { occurrence: string; daysLeft: number } | null {
  const occurrence = nextOccurrence(occasion.date, today);
  const daysLeft = daysBetween(today, occurrence);
  if (daysLeft > occasion.remindDaysBefore) return null;
  if (occasion.remindedFor === occurrence) return null;
  return { occurrence, daysLeft };
}
