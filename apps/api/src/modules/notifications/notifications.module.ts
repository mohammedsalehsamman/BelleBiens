import { Global, Module } from '@nestjs/common';
import { OrderNotifier } from '../../adapters/messaging/order-notifier.js';
import { NotificationJobs } from './notification-jobs.js';
import { NotificationsService } from './notifications.service.js';
import { NotifyingOrderNotifier } from './notifying-order-notifier.js';

/** Messages to customers and the shop, their queue and log (S7, FR-NTF-*). */
@Global()
@Module({
  providers: [
    NotificationsService,
    NotificationJobs,
    { provide: OrderNotifier, useClass: NotifyingOrderNotifier },
  ],
  exports: [NotificationsService, OrderNotifier],
})
export class NotificationsModule {}
