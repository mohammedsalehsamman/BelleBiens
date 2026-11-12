import { Module } from '@nestjs/common';
import { CartModule } from '../cart/cart.module.js';
import { DeliveryModule } from '../delivery/delivery.module.js';
import {
  AdminOrdersController,
  MyOrdersController,
  OrdersController,
} from './orders.controller.js';
import { OrdersService } from './orders.service.js';

/** Placing, reading and moving orders (S5, FR-ORD-*, FR-INV-02/03). */
@Module({
  imports: [CartModule, DeliveryModule],
  controllers: [OrdersController, MyOrdersController, AdminOrdersController],
  providers: [OrdersService],
  exports: [OrdersService],
})
export class OrdersModule {}
