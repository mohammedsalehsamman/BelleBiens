import {
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnModuleDestroy,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Env } from '../../config/env.schema.js';
import { NotificationsService } from './notifications.service.js';

/**
 * Sends due messages every 15 seconds and checks occasion reminders every
 * hour (FR-NTF-07, FR-ACC-07). Off when JOBS_ENABLED is false.
 */
@Injectable()
export class NotificationJobs
  implements OnApplicationBootstrap, OnModuleDestroy
{
  static readonly SEND_EVERY_MS = 15_000;
  static readonly REMIND_EVERY_MS = 60 * 60_000;
  private readonly logger = new Logger(NotificationJobs.name);
  private readonly timers: NodeJS.Timeout[] = [];
  private sending = false;

  constructor(
    private readonly notifications: NotificationsService,
    private readonly config: ConfigService<Env, true>,
  ) {}

  onApplicationBootstrap(): void {
    if (!this.config.get('JOBS_ENABLED', { infer: true })) return;
    this.timers.push(
      setInterval(() => void this.send(), NotificationJobs.SEND_EVERY_MS),
      setInterval(() => void this.remind(), NotificationJobs.REMIND_EVERY_MS),
    );
    for (const t of this.timers) t.unref();
  }

  onModuleDestroy(): void {
    for (const t of this.timers) clearInterval(t);
  }

  async send(): Promise<void> {
    if (this.sending) return;
    this.sending = true;
    try {
      await this.notifications.dispatchDue();
    } catch (error) {
      this.logger.error(`sending failed: ${String(error)}`);
    } finally {
      this.sending = false;
    }
  }

  async remind(): Promise<void> {
    try {
      const n = await this.notifications.remindOccasions();
      if (n > 0) this.logger.log(`occasion reminders queued: ${n}`);
    } catch (error) {
      this.logger.error(`reminders failed: ${String(error)}`);
    }
  }
}
