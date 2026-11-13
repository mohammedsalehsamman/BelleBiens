import { Injectable, Logger } from '@nestjs/common';
import { DateTime } from 'luxon';
import {
  MessageGateway,
  type MessageChannel,
} from '../../adapters/messaging/message-gateway.js';
import { Clock, SHOP_TIME_ZONE } from '../../common/clock/clock.js';
import { dayMonthText } from '../../common/text/date-text.js';
import type { Prisma } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  daysBetween,
  reminderDue,
  retryDelayMinutes,
} from './notification-rules.js';
import {
  type Language,
  render,
  type TemplateKey,
  templateForStatus,
  type TemplateVars,
} from './templates.js';

const OCCASION_NAMES: Record<string, Record<Language, string>> = {
  BIRTHDAY: { ar: 'عيد ميلاد', en: 'birthday' },
  ANNIVERSARY: { ar: 'ذكرى', en: 'anniversary' },
  GRADUATION: { ar: 'تخرج', en: 'graduation' },
  OTHER: { ar: 'مناسبة', en: 'occasion' },
};

const money = (minor: number, language: Language) =>
  `${Math.round(minor / 100).toLocaleString('en-US')} ${language === 'en' ? 'SYP' : 'ل.س'}`;

/** The shop's time of an instant: "12 تشرين الثاني 15:30". */
function instantText(at: Date, language: Language): string {
  const local = DateTime.fromJSDate(at, { zone: SHOP_TIME_ZONE });
  return `${dayMonthText(local.toISODate()!, language)} ${local.toFormat('HH:mm')}`;
}

interface Recipient {
  userId: string | null;
  phone: string | null;
  language: Language;
  /** WhatsApp for order messages (screen 33); SMS when turned off. */
  whatsapp: boolean;
}

/**
 * Builds and sends what customers and the shop are told (FR-NTF-01..07).
 * Every message is a row first, then sent: a failed send is tried again
 * later, and the row is the log of what happened.
 */
@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly settings: SettingsService,
    private readonly gateway: MessageGateway,
  ) {}

  // ---------- queueing ----------

  private async queue(
    to: Recipient,
    key: TemplateKey,
    vars: TemplateVars,
    extra: { orderNumber?: string; route?: string; push?: boolean },
  ): Promise<void> {
    const { title, body } = render(key, to.language, vars);
    const now = this.clock.now();
    const rows: Prisma.NotificationCreateManyInput[] = [];
    const base = {
      userId: to.userId,
      orderNumber: extra.orderNumber ?? null,
      template: key,
      language: to.language,
      title,
      body,
      data: extra.route ? { route: extra.route } : undefined,
      nextAttemptAt: now,
      createdAt: now,
    };
    if (to.phone && extra.push !== true) {
      const channel: MessageChannel = to.whatsapp ? 'WHATSAPP' : 'SMS';
      rows.push({ ...base, channel, recipient: to.phone });
    }
    if (to.userId && extra.push !== false) {
      const devices = await this.prisma.device.findMany({
        where: { userId: to.userId },
        select: { pushToken: true },
      });
      for (const d of devices) {
        rows.push({ ...base, channel: 'PUSH', recipient: d.pushToken });
      }
    }
    if (rows.length > 0)
      await this.prisma.notification.createMany({ data: rows });
  }

  private async customerOf(order: {
    userId: string | null;
    customerPhone: string;
  }): Promise<Recipient> {
    const user = order.userId
      ? await this.prisma.user.findUnique({ where: { id: order.userId } })
      : null;
    return {
      userId: user?.id ?? null,
      phone: order.customerPhone,
      language: user?.language ?? 'ar',
      whatsapp: user?.notifyWhatsapp ?? true,
    };
  }

  private when(
    order: { slotDate: Date; slotStart: string; slotEnd: string },
    language: Language,
  ): string {
    const date = order.slotDate.toISOString().slice(0, 10);
    return `${dayMonthText(date, language)} ${order.slotStart} – ${order.slotEnd}`;
  }

  /** FR-NTF-01 and FR-NTF-03: the customer's confirmation and the shop's alert. */
  async orderPlaced(number: string): Promise<void> {
    const order = await this.prisma.order.findUnique({ where: { number } });
    if (!order) return;
    const to = await this.customerOf(order);
    const owed = order.paymentMethod !== 'CASH' && order.paymentDueAt;
    await this.queue(
      to,
      owed ? 'order.placed.shamcash' : 'order.placed',
      {
        number,
        when: this.when(order, to.language),
        total: money(order.totalMinor, to.language),
        ...(owed ? { due: instantText(order.paymentDueAt!, to.language) } : {}),
      },
      { orderNumber: number, route: `/orders/${number}` },
    );

    const shop = await this.settings.get('shop.whatsapp');
    if (shop) {
      await this.queue(
        { userId: null, phone: shop, language: 'ar', whatsapp: true },
        'shop.new_order',
        {
          number,
          when: this.when(order, 'ar'),
          total: money(order.totalMinor, 'ar'),
          fulfillment: order.fulfillment === 'DELIVERY' ? 'توصيل' : 'استلام',
        },
        { orderNumber: number, push: false },
      );
    }
  }

  /** FR-NTF-02: confirmed, ready for pickup, out, delivered, cancelled. */
  async statusChanged(number: string, status: string): Promise<void> {
    const order = await this.prisma.order.findUnique({ where: { number } });
    if (!order) return;
    const key = templateForStatus(status, order.fulfillment);
    if (!key) return;
    const to = await this.customerOf(order);
    await this.queue(
      to,
      key,
      { number, when: this.when(order, to.language) },
      { orderNumber: number, route: `/orders/${number}` },
    );
  }

  /** Screen 38: the shop could not match the payment. */
  async paymentRejected(number: string): Promise<void> {
    const order = await this.prisma.order.findUnique({ where: { number } });
    if (!order) return;
    const to = await this.customerOf(order);
    await this.queue(
      to,
      'payment.rejected',
      { number },
      { orderNumber: number, route: `/orders/${number}` },
    );
  }

  /**
   * FR-ACC-07, FR-NTF-04/05: occasion reminders by push, once per
   * occurrence, only for customers who keep them on.
   */
  async remindOccasions(): Promise<number> {
    const today = this.clock.nowInShopZone().toISODate()!;
    const occasions = await this.prisma.occasionReminder.findMany({
      where: { user: { status: 'ACTIVE', notifyOccasions: true } },
      include: { user: { select: { language: true } } },
    });
    let sent = 0;
    for (const o of occasions) {
      const due = reminderDue(
        {
          date: o.date.toISOString().slice(0, 10),
          remindDaysBefore: o.remindDaysBefore,
          remindedFor: o.remindedFor?.toISOString().slice(0, 10) ?? null,
        },
        today,
      );
      if (!due) continue;
      const language = o.user.language;
      await this.queue(
        { userId: o.userId, phone: null, language, whatsapp: false },
        'occasion.reminder',
        {
          person: o.person,
          occasion: OCCASION_NAMES[o.type]![language],
          days: due.daysLeft,
        },
        { route: '/designer', push: true },
      );
      await this.prisma.occasionReminder.update({
        where: { id: o.id },
        data: { remindedFor: new Date(`${due.occurrence}T00:00:00.000Z`) },
      });
      sent += 1;
    }
    return sent;
  }

  // ---------- sending ----------

  /**
   * Sends what is due. Rows are claimed with SKIP LOCKED so two runs never
   * send the same message; a failure waits 1, 5, 30 then 120 minutes, then
   * the row is marked FAILED with its last error (FR-NTF-07).
   */
  async dispatchDue(limit = 50): Promise<{ sent: number; failed: number }> {
    const now = this.clock.now();
    let sent = 0;
    let failed = 0;
    await this.prisma.$transaction(async (tx) => {
      const due = await tx.$queryRaw<
        {
          id: string;
          channel: MessageChannel;
          recipient: string;
          title: string;
          body: string;
          data: Record<string, string> | null;
          attempts: number;
        }[]
      >`SELECT id, channel, recipient, title, body, data, attempts
        FROM notification
        WHERE status = 'PENDING' AND next_attempt_at <= ${now}
        ORDER BY next_attempt_at
        LIMIT ${limit}
        FOR UPDATE SKIP LOCKED`;
      for (const n of due) {
        const attempts = n.attempts + 1;
        try {
          await this.gateway.send({
            channel: n.channel,
            recipient: n.recipient,
            title: n.title,
            body: n.body,
            ...(n.data ? { data: n.data } : {}),
          });
          await tx.notification.update({
            where: { id: n.id },
            data: {
              status: 'SENT',
              attempts,
              sentAt: this.clock.now(),
              nextAttemptAt: null,
              lastError: null,
            },
          });
          sent += 1;
        } catch (error) {
          const wait = retryDelayMinutes(attempts);
          await tx.notification.update({
            where: { id: n.id },
            data: {
              attempts,
              lastError: String(error).slice(0, 500),
              ...(wait === null
                ? { status: 'FAILED', nextAttemptAt: null }
                : {
                    nextAttemptAt: DateTime.fromJSDate(now)
                      .plus({ minutes: wait })
                      .toJSDate(),
                  }),
            },
          });
          if (wait === null) failed += 1;
          this.logger.warn(`notification ${n.id} try ${attempts} failed`);
        }
      }
    });
    return { sent, failed };
  }

  /** FR-NTF-07 for the shop: the log of an order's messages. */
  async forOrder(orderNumber: string) {
    return this.prisma.notification.findMany({
      where: { orderNumber },
      orderBy: { createdAt: 'asc' },
    });
  }

  /** Days until a stored occasion (for screen 31). */
  daysUntil(next: string): number {
    return daysBetween(this.clock.nowInShopZone().toISODate()!, next);
  }
}
