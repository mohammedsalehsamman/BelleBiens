import { checkMove, customerCanCancel, nextStatuses } from './order-status.js';

describe('order status moves (FR-ORD-02, UC-04)', () => {
  it('the happy path for a delivery', () => {
    expect(checkMove('NEW', 'CONFIRMED', 'MANAGER', 'DELIVERY')).toBe('OK');
    expect(checkMove('CONFIRMED', 'PREPARING', 'FLORIST', 'DELIVERY')).toBe(
      'OK',
    );
    expect(checkMove('PREPARING', 'READY', 'FLORIST', 'DELIVERY')).toBe('OK');
    expect(
      checkMove(
        'READY',
        'OUT_FOR_DELIVERY',
        'DELIVERY_COORDINATOR',
        'DELIVERY',
      ),
    ).toBe('OK');
    expect(
      checkMove(
        'OUT_FOR_DELIVERY',
        'DELIVERED',
        'DELIVERY_COORDINATOR',
        'DELIVERY',
      ),
    ).toBe('OK');
  });

  it('pickup is handed over, never sent out', () => {
    expect(checkMove('READY', 'PICKED_UP', 'FLORIST', 'PICKUP')).toBe('OK');
    expect(checkMove('READY', 'OUT_FOR_DELIVERY', 'OWNER', 'PICKUP')).toBe(
      'NOT_ALLOWED',
    );
    expect(checkMove('READY', 'PICKED_UP', 'OWNER', 'DELIVERY')).toBe(
      'NOT_ALLOWED',
    );
  });

  it('no skipping, no way back from the end', () => {
    expect(checkMove('NEW', 'READY', 'OWNER', 'DELIVERY')).toBe('NOT_ALLOWED');
    expect(checkMove('DELIVERED', 'CANCELLED', 'OWNER', 'DELIVERY')).toBe(
      'NOT_ALLOWED',
    );
    expect(checkMove('CANCELLED', 'NEW', 'OWNER', 'DELIVERY')).toBe(
      'NOT_ALLOWED',
    );
  });

  it('roles: a florist does not send out or cancel a confirmed order; a customer moves nothing', () => {
    expect(checkMove('READY', 'OUT_FOR_DELIVERY', 'FLORIST', 'DELIVERY')).toBe(
      'FORBIDDEN',
    );
    expect(checkMove('CONFIRMED', 'CANCELLED', 'FLORIST', 'DELIVERY')).toBe(
      'FORBIDDEN',
    );
    expect(checkMove('NEW', 'CONFIRMED', 'CUSTOMER', 'DELIVERY')).toBe(
      'FORBIDDEN',
    );
  });

  it('next statuses per role, and the customer cancels only before confirmation (FR-ORD-05)', () => {
    expect(nextStatuses('READY', 'DELIVERY_COORDINATOR', 'DELIVERY')).toEqual([
      'OUT_FOR_DELIVERY',
    ]);
    expect(nextStatuses('OUT_FOR_DELIVERY', 'OWNER', 'DELIVERY')).toEqual([
      'DELIVERED',
      'READY',
      'CANCELLED',
    ]);
    expect(customerCanCancel('NEW')).toBe(true);
    expect(customerCanCancel('CONFIRMED')).toBe(false);
  });
});
