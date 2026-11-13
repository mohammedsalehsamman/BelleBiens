import { Injectable, Logger } from '@nestjs/common';
import {
  type OrderNotice,
  OrderNotifier,
} from '../../adapters/messaging/order-notifier.js';
import { NotificationsService } from './notifications.service.js';

/** Order events become queued messages (FR-NTF-01..03). */
@Injectable()
export class NotifyingOrderNotifier extends OrderNotifier {
  private readonly logger = new Logger('OrderNotifier');

  constructor(private readonly notifications: NotificationsService) {
    super();
  }

  async orderPlaced(notice: OrderNotice): Promise<void> {
    this.logger.log(`new order ${notice.number}`);
    await this.notifications.orderPlaced(notice.number);
  }

  async statusChanged(notice: OrderNotice & { from: string }): Promise<void> {
    await this.notifications.statusChanged(notice.number, notice.status);
  }

  async paymentRejected(number: string): Promise<void> {
    await this.notifications.paymentRejected(number);
  }
}
