import type { ConfigService } from '@nestjs/config';
import type { Env } from '../../../config/env.schema.js';
import { OrderJobs } from './order-jobs.js';
import type { PaymentsService } from './payments.service.js';

function jobs(enabled: boolean, expire: () => Promise<string[]>) {
  const payments = { expireUnpaid: vi.fn(expire) };
  const config = { get: () => enabled } as unknown as ConfigService<Env, true>;
  return {
    payments,
    jobs: new OrderJobs(payments as unknown as PaymentsService, config),
  };
}

describe('OrderJobs (FR-PAY-10)', () => {
  afterEach(() => {
    vi.useRealTimers();
  });

  it('runs every minute when enabled, never when not', async () => {
    vi.useFakeTimers();
    const on = jobs(true, () => Promise.resolve(['BB-1001']));
    on.jobs.onApplicationBootstrap();
    await vi.advanceTimersByTimeAsync(OrderJobs.EVERY_MS * 2);
    expect(on.payments.expireUnpaid).toHaveBeenCalledTimes(2);
    on.jobs.onModuleDestroy();

    const off = jobs(false, () => Promise.resolve([]));
    off.jobs.onApplicationBootstrap();
    await vi.advanceTimersByTimeAsync(OrderJobs.EVERY_MS * 2);
    expect(off.payments.expireUnpaid).not.toHaveBeenCalled();
  });

  it('a pass never overlaps the previous one, and a failure is survived', async () => {
    let release: () => void = () => undefined;
    const slow = jobs(
      true,
      () =>
        new Promise<string[]>((resolve) => {
          release = () => resolve([]);
        }),
    );
    const first = slow.jobs.tick();
    await slow.jobs.tick();
    expect(slow.payments.expireUnpaid).toHaveBeenCalledTimes(1);
    release();
    await first;

    const failing = jobs(true, () => Promise.reject(new Error('db down')));
    await expect(failing.jobs.tick()).resolves.toBeUndefined();
  });
});
