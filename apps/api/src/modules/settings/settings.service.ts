import { Injectable } from '@nestjs/common';
import { Clock } from '../../common/clock/clock.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';

/** Defaults used until the shop sets a value (DR-21). Keys match prisma/seed.ts. */
export const SETTING_DEFAULTS = {
  'currency.usdRate': '120',
  'pricing.assemblyFeeMinor': 0,
  'pricing.rounding': { mode: 'none' } as
    { mode: 'none' } | { mode: 'nearest'; stepMinor: number },
  'shop.mode': 'open' as 'open' | 'busy' | 'closed',
  'shop.workingHours': { open: '10:00', close: '24:00' },
  'shop.whatsapp': null as string | null,
  'payments.enabled': { cash: true, shamcash: true, stripe: false },
  'payments.unpaidTimeoutMinutes': 120,
} as const;

export type SettingKey = keyof typeof SETTING_DEFAULTS;
export type SettingValue<K extends SettingKey> = (typeof SETTING_DEFAULTS)[K];

/**
 * Reads shop settings with a short in-process cache. Settings change rarely and are
 * read on hot paths (pricing, app config). Writes come with the admin API (S2/S6),
 * which also clears this cache and writes the audit log.
 */
@Injectable()
export class SettingsService {
  private cache: { values: Map<string, unknown>; loadedAt: number } | null =
    null;
  static readonly CACHE_MS = 30_000;

  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
  ) {}

  async get<K extends SettingKey>(key: K): Promise<SettingValue<K>> {
    const values = await this.load();
    return (
      values.has(key) ? values.get(key) : SETTING_DEFAULTS[key]
    ) as SettingValue<K>;
  }

  invalidate(): void {
    this.cache = null;
  }

  private async load(): Promise<Map<string, unknown>> {
    const now = this.clock.now().getTime();
    if (this.cache && now - this.cache.loadedAt < SettingsService.CACHE_MS) {
      return this.cache.values;
    }
    const rows = await this.prisma.setting.findMany();
    const values = new Map<string, unknown>(
      rows.map((row) => [row.key, row.value]),
    );
    this.cache = { values, loadedAt: now };
    return values;
  }
}
