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
 * FR-ORD-08, FR-NTF-*). The notifications module queues the messages (S7).
 * A failure here never undoes an order: callers log it and move on.
 */
export abstract class OrderNotifier {
  abstract orderPlaced(notice: OrderNotice): Promise<void>;
  abstract statusChanged(notice: OrderNotice & { from: string }): Promise<void>;
  /** Screen 38: the shop could not match the payment. */
  abstract paymentRejected(number: string): Promise<void>;
}
