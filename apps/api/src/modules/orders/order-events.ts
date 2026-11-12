import { Injectable } from '@nestjs/common';
import { Observable, Subject } from 'rxjs';

export interface OrderEvent {
  type: 'order.placed' | 'order.status';
  number: string;
  status: string;
  fulfillment: string;
  slotDate: string;
  slotStart: string;
  totalMinor: number;
  at: string;
}

/**
 * FR-ORD-08: new orders and status changes for the dashboard, as they
 * happen. In one process this is enough; several API instances would share
 * it through Redis pub/sub.
 */
@Injectable()
export class OrderEvents {
  private readonly subject = new Subject<OrderEvent>();

  emit(event: OrderEvent): void {
    this.subject.next(event);
  }

  get stream(): Observable<OrderEvent> {
    return this.subject.asObservable();
  }
}
