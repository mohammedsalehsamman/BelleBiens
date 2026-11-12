import { Module } from '@nestjs/common';
import {
  AddressesController,
  AdminDeliveryController,
  DeliveryController,
} from './delivery.controller.js';
import { DeliveryService } from './delivery.service.js';

/** Zones, the calendar, slot holds and saved addresses (S5, FR-DLV-*). */
@Module({
  controllers: [
    DeliveryController,
    AddressesController,
    AdminDeliveryController,
  ],
  providers: [DeliveryService],
  exports: [DeliveryService],
})
export class DeliveryModule {}
