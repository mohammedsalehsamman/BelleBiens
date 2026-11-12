import { Injectable, Logger } from '@nestjs/common';
import { maskPhone } from '../../common/phone/phone.js';

export interface OrderNotice {
  number: string;
  status: string;
  fulfillment: 'DELIVERY' | 'PICKUP';
  slotDate: string;
  slotStart: string;
  totalMinor: number;
  customerPhone: string;
}

/**
 * Tells the shop about new orders and the customer about changes (UC-01 step 7,
 * FR-ORD-08, FR-NTF-*). WhatsApp, SMS, push and the dashboard stream come in S6/S7,
 * each a class behind this interface (NFR-FLX-02). A failure here never undoes an
 * order: callers log it and move on.
 */
export abstract class OrderNotifier {
  abstract orderPlaced(notice: OrderNotice): Promise<void>;
  abstract statusChanged(notice: OrderNotice & { from: string }): Promise<void>;
}

/** Development: writes the notices to the API log. */
@Injectable()
export class ConsoleOrderNotifier extends OrderNotifier {
  private readonly logger = new Logger('OrderNotifier');

  async orderPlaced(n: OrderNotice): Promise<void> {
    this.logger.log(
      `[console provider] new order ${n.number} · ${n.fulfillment} ${n.slotDate} ${n.slotStart} · ${n.totalMinor / 100} SYP · ${maskPhone(n.customerPhone)}`,
    );
    await Promise.resolve();
  }

  async statusChanged(n: OrderNotice & { from: string }): Promise<void> {
    this.logger.log(
      `[console provider] order ${n.number}: ${n.from} -> ${n.status}`,
    );
    await Promise.resolve();
  }
}
