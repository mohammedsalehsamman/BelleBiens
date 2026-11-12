import {
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnModuleDestroy,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Env } from '../../../config/env.schema.js';
import { PaymentsService } from './payments.service.js';

/**
 * Runs the order jobs in this process every minute (FR-PAY-10). One API
 * instance is enough for the shop; with more, only one sets JOBS_ENABLED and
 * the order row lock keeps a double run harmless. A queue (BullMQ) can take
 * this over when there are more jobs (plan 3.7).
 */
@Injectable()
export class OrderJobs implements OnApplicationBootstrap, OnModuleDestroy {
  static readonly EVERY_MS = 60_000;
  private readonly logger = new Logger(OrderJobs.name);
  private timer: NodeJS.Timeout | null = null;
  private running = false;

  constructor(
    private readonly payments: PaymentsService,
    private readonly config: ConfigService<Env, true>,
  ) {}

  onApplicationBootstrap(): void {
    if (!this.config.get('JOBS_ENABLED', { infer: true })) return;
    this.timer = setInterval(() => void this.tick(), OrderJobs.EVERY_MS);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  /** One pass; skipped while the previous one still runs. */
  async tick(): Promise<void> {
    if (this.running) return;
    this.running = true;
    try {
      const cancelled = await this.payments.expireUnpaid();
      if (cancelled.length > 0) {
        this.logger.log(`unpaid orders cancelled: ${cancelled.join(', ')}`);
      }
    } catch (error) {
      this.logger.error(`order jobs failed: ${String(error)}`);
    } finally {
      this.running = false;
    }
  }
}
