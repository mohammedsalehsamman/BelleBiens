import { Injectable } from '@nestjs/common';
import { Clock } from '../../common/clock/clock.js';
import { Prisma } from '../../generated/prisma/client.js';
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
  'payments.unpaidTimeoutMinutes': 120 as number,
  /** FR-PAY-03: the shop's Sham Cash account the customer pays to (screen 24). */
  'payments.shamcashAccount': null as string | null,
  /** FR-ADM-12 busy mode: the shop's message, and the first time it takes today. */
  'shop.busyMessage': null as { ar: string; en: string } | null,
  'shop.busyAcceptsFrom': null as string | null,
  /** FR-DLV-04: the day's delivery slots and how many orders each takes. */
  'delivery.slots': [
    { start: '12:00', end: '14:00', capacity: 6 },
    { start: '14:00', end: '16:00', capacity: 6 },
    { start: '16:00', end: '18:00', capacity: 6 },
    { start: '18:00', end: '20:00', capacity: 6 },
    { start: '20:00', end: '22:00', capacity: 6 },
  ] as { start: string; end: string; capacity: number }[],
  /** FR-DLV-09: dates (YYYY-MM-DD) the shop does not deliver. */
  'delivery.closedDays': [] as string[],
  /** FR-DLV-03: how far ahead an order can be placed. */
  'delivery.windowDays': 60 as number,
  /** FR-DLV-04: how long a chosen slot is kept during checkout. */
  'delivery.slotHoldMinutes': 15 as number,
  /** FR-INV-04: the dashboard lists items with this many or fewer left. */
  'inventory.lowStockThreshold': 5 as number,
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

  /** Writes one setting inside the caller's transaction, then clears the cache. */
  async set<K extends SettingKey>(
    key: K,
    value: SettingValue<K>,
    updatedBy: string | null,
    tx: Prisma.TransactionClient = this.prisma,
  ): Promise<void> {
    const json =
      value === null
        ? Prisma.JsonNull
        : (value as unknown as Prisma.InputJsonValue);
    await tx.setting.upsert({
      where: { key },
      update: { value: json, updatedBy },
      create: { key, value: json, updatedBy },
    });
    this.invalidate();
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
