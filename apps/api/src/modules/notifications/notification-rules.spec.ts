import {
  MAX_ATTEMPTS,
  nextOccurrence,
  reminderDue,
  retryDelayMinutes,
} from './notification-rules.js';
import { arabicDaysAhead, render, templateForStatus } from './templates.js';

describe('retries (FR-NTF-07)', () => {
  it('waits longer each time, then gives up', () => {
    expect([1, 2, 3, 4].map(retryDelayMinutes)).toEqual([1, 5, 30, 120]);
    expect(retryDelayMinutes(MAX_ATTEMPTS)).toBeNull();
  });
});

describe('occasions (FR-ACC-07)', () => {
  it('the next birthday this year or next; 29 February on the 28th', () => {
    expect(nextOccurrence('1990-11-19', '2026-11-12')).toBe('2026-11-19');
    expect(nextOccurrence('1990-03-01', '2026-11-12')).toBe('2027-03-01');
    expect(nextOccurrence('1992-11-12', '2026-11-12')).toBe('2026-11-12');
    expect(nextOccurrence('2000-02-29', '2026-11-12')).toBe('2027-02-28');
    expect(nextOccurrence('2000-02-29', '2027-11-12')).toBe('2028-02-29');
  });

  it('reminds once, inside the window (screen 31: "بعد 9 أيام")', () => {
    const mom = { date: '1965-11-19', remindDaysBefore: 7, remindedFor: null };
    expect(reminderDue(mom, '2026-11-10')).toBeNull();
    expect(reminderDue(mom, '2026-11-12')).toEqual({
      occurrence: '2026-11-19',
      daysLeft: 7,
    });
    expect(
      reminderDue({ ...mom, remindedFor: '2026-11-19' }, '2026-11-13'),
    ).toBeNull();
    // The year after, it is due again.
    expect(
      reminderDue({ ...mom, remindedFor: '2026-11-19' }, '2027-11-15'),
    ).toEqual({ occurrence: '2027-11-19', daysLeft: 4 });
  });
});

describe('templates (FR-NTF-01/02)', () => {
  it('messages in both languages', () => {
    expect(
      render('order.placed', 'ar', {
        number: 'BB-1001',
        when: '12 تشرين الثاني 16:00 – 18:00',
        total: '7,266 ل.س',
      }).body,
    ).toBe(
      'استلمنا طلبك BB-1001 من Belle Biens. الموعد: 12 تشرين الثاني 16:00 – 18:00. الإجمالي: 7,266 ل.س. يتصل بك المحل لتأكيده.',
    );
    expect(
      render('occasion.reminder', 'ar', {
        person: 'ماما',
        occasion: 'عيد ميلاد',
        days: 2,
      }).body,
    ).toBe('بعد يومين: عيد ميلاد ماما. صمّم باقة الآن.');
    expect([1, 3, 11].map(arabicDaysAhead)).toEqual([
      'غداً',
      'بعد 3 أيام',
      'بعد 11 يوماً',
    ]);
    expect(render('order.out', 'en', { number: 'BB-1001' }).body).toBe(
      'Your order BB-1001 is out for delivery.',
    );
  });

  it('which statuses the customer hears about', () => {
    expect(templateForStatus('CONFIRMED', 'DELIVERY')).toBe('order.confirmed');
    expect(templateForStatus('PREPARING', 'DELIVERY')).toBeNull();
    expect(templateForStatus('READY', 'DELIVERY')).toBeNull();
    expect(templateForStatus('READY', 'PICKUP')).toBe('order.ready.pickup');
    expect(templateForStatus('PICKED_UP', 'PICKUP')).toBe('order.delivered');
  });
});
