import { Module } from '@nestjs/common';
import { CartModule } from '../cart/cart.module.js';
import { DeliveryModule } from '../delivery/delivery.module.js';
import { OrderEvents } from './order-events.js';
import {
  AdminOrdersController,
  MyOrdersController,
  OrdersController,
} from './orders.controller.js';
import { OrdersService } from './orders.service.js';
import { OrderJobs } from './payments/order-jobs.js';
import {
  CashProvider,
  PaymentProviders,
  ShamCashManualProvider,
} from './payments/payment-providers.js';
import {
  AdminOrderPaymentsController,
  OrderPaymentsController,
} from './payments/payments.controller.js';
import { PaymentsService } from './payments/payments.service.js';

/** Placing, paying, reading and moving orders (S5, S6; FR-ORD-*, FR-PAY-*). */
@Module({
  imports: [CartModule, DeliveryModule],
  // The admin payments controller first: its "stream" route must win over
  // "admin/orders/:number".
  controllers: [
    AdminOrderPaymentsController,
    OrderPaymentsController,
    OrdersController,
    MyOrdersController,
    AdminOrdersController,
  ],
  providers: [
    OrdersService,
    PaymentsService,
    OrderEvents,
    OrderJobs,
    CashProvider,
    ShamCashManualProvider,
    PaymentProviders,
  ],
  exports: [OrdersService, PaymentsService],
})
export class OrdersModule {}
