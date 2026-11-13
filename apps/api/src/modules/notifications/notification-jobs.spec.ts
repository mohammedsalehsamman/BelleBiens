import type { ConfigService } from '@nestjs/config';
import type { Env } from '../../config/env.schema.js';
import { AccountJobs } from '../accounts/me/account-jobs.js';
import type { MeService } from '../accounts/me/me.service.js';
import { NotificationJobs } from './notification-jobs.js';
import type { NotificationsService } from './notifications.service.js';

const config = (enabled: boolean) =>
  ({ get: () => enabled }) as unknown as ConfigService<Env, true>;

describe('notification and account jobs', () => {
  afterEach(() => {
    vi.useRealTimers();
  });

  it('send every 15 seconds and remind every hour, only when enabled', async () => {
    vi.useFakeTimers();
    const service = {
      dispatchDue: vi.fn(() => Promise.resolve({ sent: 0, failed: 0 })),
      remindOccasions: vi.fn(() => Promise.resolve(1)),
    };
    const jobs = new NotificationJobs(
      service as unknown as NotificationsService,
      config(true),
    );
    jobs.onApplicationBootstrap();
    await vi.advanceTimersByTimeAsync(NotificationJobs.REMIND_EVERY_MS);
    expect(service.dispatchDue).toHaveBeenCalledTimes(240);
    expect(service.remindOccasions).toHaveBeenCalledTimes(1);
    jobs.onModuleDestroy();

    const off = new NotificationJobs(
      service as unknown as NotificationsService,
      config(false),
    );
    off.onApplicationBootstrap();
    await vi.advanceTimersByTimeAsync(NotificationJobs.REMIND_EVERY_MS);
    expect(service.remindOccasions).toHaveBeenCalledTimes(1);
  });

  it('survive failures and never overlap a send', async () => {
    let release: () => void = () => undefined;
    const service = {
      dispatchDue: vi.fn(
        () =>
          new Promise<{ sent: number; failed: number }>((resolve) => {
            release = () => resolve({ sent: 0, failed: 0 });
          }),
      ),
      remindOccasions: vi.fn(() => Promise.reject(new Error('db down'))),
    };
    const jobs = new NotificationJobs(
      service as unknown as NotificationsService,
      config(true),
    );
    const first = jobs.send();
    await jobs.send();
    expect(service.dispatchDue).toHaveBeenCalledTimes(1);
    release();
    await first;
    await expect(jobs.remind()).resolves.toBeUndefined();

    const me = { eraseDeleted: vi.fn(() => Promise.reject(new Error('x'))) };
    const accounts = new AccountJobs(me as unknown as MeService, config(true));
    await expect(accounts.tick()).resolves.toBeUndefined();
  });
});
