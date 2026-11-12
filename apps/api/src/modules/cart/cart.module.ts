import { Module } from '@nestjs/common';
import { DesignerModule } from '../designer/designer.module.js';
import {
  AdminCouponsController,
  CartController,
  SavedCartController,
} from './cart.controller.js';
import { CartService } from './cart.service.js';
import { CouponAttemptLimiter } from './coupon-limiter.js';

/** Cart pricing, saved carts, split boxes and coupons (S4). */
@Module({
  imports: [DesignerModule],
  controllers: [CartController, SavedCartController, AdminCouponsController],
  providers: [CartService, CouponAttemptLimiter],
  exports: [CartService],
})
export class CartModule {}
