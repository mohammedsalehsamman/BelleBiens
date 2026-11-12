import {
  type CalendarSettings,
  daySlots,
  type LngLat,
  pointInPolygon,
} from './delivery-rules.js';

const square: LngLat[] = [
  [36.28, 33.51],
  [36.29, 33.51],
  [36.29, 33.52],
  [36.28, 33.52],
];

describe('pointInPolygon (FR-DLV-01)', () => {
  it('inside, outside, and on the far side', () => {
    expect(pointInPolygon([36.284, 33.515], square)).toBe(true);
    expect(pointInPolygon([36.3, 33.515], square)).toBe(false);
    expect(pointInPolygon([36.284, 33.5], square)).toBe(false);
  });

  it('works for a concave shape', () => {
    const l: LngLat[] = [
      [0, 0],
      [2, 0],
      [2, 1],
      [1, 1],
      [1, 2],
      [0, 2],
    ];
    expect(pointInPolygon([0.5, 1.5], l)).toBe(true);
    expect(pointInPolygon([1.5, 1.5], l)).toBe(false);
  });
});

const settings: CalendarSettings = {
  hours: { open: '10:00', close: '24:00' },
  slots: [
    { start: '12:00', end: '14:00', capacity: 2 },
    { start: '16:00', end: '18:00', capacity: 2 },
    { start: '20:00', end: '22:00', capacity: 2 },
  ],
  closedDays: ['2026-11-20'],
  windowDays: 60,
  mode: 'open',
  busyAcceptsFrom: null,
};
const now = new Date('2026-11-11T15:00:00+03:00');
const none = () => 0;
const problems = (slots: ReturnType<typeof daySlots>) =>
  slots.map((s) => s.problem);

describe('daySlots (FR-DLV-03/04/05/09)', () => {
  it('today at 15:00: earlier slots are too soon', () => {
    expect(
      problems(daySlots('2026-11-11', now, 0, settings, none, true)),
    ).toEqual(['TOO_SOON', null, null]);
  });

  it('a 24 hour cake at 15:00: nothing before 15:00 tomorrow (SRS 6.2)', () => {
    expect(
      problems(daySlots('2026-11-11', now, 24, settings, none, true)),
    ).toEqual(['TOO_SOON', 'TOO_SOON', 'TOO_SOON']);
    expect(
      problems(daySlots('2026-11-12', now, 24, settings, none, true)),
    ).toEqual(['TOO_SOON', null, null]);
  });

  it('full slots, but pickup ignores capacity', () => {
    const taken = (start: string) => (start === '16:00' ? 2 : 1);
    expect(
      problems(daySlots('2026-11-12', now, 0, settings, taken, true)),
    ).toEqual([null, 'FULL', null]);
    expect(
      problems(daySlots('2026-11-12', now, 0, settings, taken, false)),
    ).toEqual([null, null, null]);
  });

  it('closed days, the booking window, past days', () => {
    expect(
      daySlots('2026-11-20', now, 0, settings, none, true)[0]!.problem,
    ).toBe('CLOSED');
    expect(
      daySlots('2027-01-11', now, 0, settings, none, true)[0]!.problem,
    ).toBe('OUT_OF_RANGE');
    expect(
      daySlots('2026-11-10', now, 0, settings, none, true)[0]!.problem,
    ).toBe('OUT_OF_RANGE');
  });

  it('busy mode takes today only from its time; closed mode takes nothing (FR-ADM-12)', () => {
    const busy = {
      ...settings,
      mode: 'busy' as const,
      busyAcceptsFrom: '20:00',
    };
    expect(problems(daySlots('2026-11-11', now, 0, busy, none, true))).toEqual([
      'TOO_SOON',
      'BUSY',
      null,
    ]);
    expect(problems(daySlots('2026-11-12', now, 0, busy, none, true))).toEqual([
      null,
      null,
      null,
    ]);
    const closed = { ...settings, mode: 'closed' as const };
    expect(
      problems(daySlots('2026-11-12', now, 0, closed, none, true)),
    ).toEqual(['CLOSED', 'CLOSED', 'CLOSED']);
  });
});
