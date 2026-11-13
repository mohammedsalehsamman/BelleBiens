import {
  Injectable,
  Logger,
  type OnApplicationBootstrap,
  type OnModuleDestroy,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Env } from '../../../config/env.schema.js';
import { MeService } from './me.service.js';

/** Erases accounts 30 days after their deletion request, hourly (FR-ACC-08). */
@Injectable()
export class AccountJobs implements OnApplicationBootstrap, OnModuleDestroy {
  static readonly EVERY_MS = 60 * 60_000;
  private readonly logger = new Logger(AccountJobs.name);
  private timer: NodeJS.Timeout | null = null;

  constructor(
    private readonly me: MeService,
    private readonly config: ConfigService<Env, true>,
  ) {}

  onApplicationBootstrap(): void {
    if (!this.config.get('JOBS_ENABLED', { infer: true })) return;
    this.timer = setInterval(() => void this.tick(), AccountJobs.EVERY_MS);
    this.timer.unref();
  }

  onModuleDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  async tick(): Promise<void> {
    try {
      const n = await this.me.eraseDeleted();
      if (n > 0) this.logger.log(`accounts erased: ${n}`);
    } catch (error) {
      this.logger.error(`erasing accounts failed: ${String(error)}`);
    }
  }
}
