import type {
  Fulfillment,
  OrderStatus,
  PaymentStatus,
  Role,
} from '../../../generated/prisma/client.js';

// Design diagram 3 (FR-ORD-02) and UC-04: who may move an order, and where.

const STAFF: Role[] = ['OWNER', 'MANAGER', 'FLORIST', 'DELIVERY_COORDINATOR'];
const LEADS: Role[] = ['OWNER', 'MANAGER'];

interface Move {
  to: OrderStatus;
  roles: Role[];
  /** Only for this way of receiving the order. */
  fulfillment?: Fulfillment;
}

const MOVES: Record<OrderStatus, Move[]> = {
  // UC-04 step 2: staff confirm by call or WhatsApp; 2a: cancel with a reason.
  NEW: [
    { to: 'CONFIRMED', roles: STAFF },
    { to: 'CANCELLED', roles: STAFF },
  ],
  // Step 4: the florist prepares.
  CONFIRMED: [
    { to: 'PREPARING', roles: [...LEADS, 'FLORIST'] },
    { to: 'CANCELLED', roles: LEADS },
  ],
  PREPARING: [
    { to: 'READY', roles: [...LEADS, 'FLORIST'] },
    { to: 'CANCELLED', roles: LEADS },
  ],
  // Step 5: the coordinator sends it out; pickup orders are handed over.
  READY: [
    {
      to: 'OUT_FOR_DELIVERY',
      roles: [...LEADS, 'DELIVERY_COORDINATOR'],
      fulfillment: 'DELIVERY',
    },
    { to: 'PICKED_UP', roles: STAFF, fulfillment: 'PICKUP' },
    { to: 'CANCELLED', roles: LEADS },
  ],
  // Step 6; 6a: a failed delivery goes back to ready with a note.
  OUT_FOR_DELIVERY: [
    { to: 'DELIVERED', roles: [...LEADS, 'DELIVERY_COORDINATOR'] },
    { to: 'READY', roles: [...LEADS, 'DELIVERY_COORDINATOR'] },
    { to: 'CANCELLED', roles: LEADS },
  ],
  DELIVERED: [],
  PICKED_UP: [],
  CANCELLED: [],
};

export type MoveCheck = 'OK' | 'NOT_ALLOWED' | 'FORBIDDEN';

export function checkMove(
  from: OrderStatus,
  to: OrderStatus,
  role: Role,
  fulfillment: Fulfillment,
): MoveCheck {
  const move = MOVES[from].find(
    (m) => m.to === to && (!m.fulfillment || m.fulfillment === fulfillment),
  );
  if (!move) return 'NOT_ALLOWED';
  return move.roles.includes(role) ? 'OK' : 'FORBIDDEN';
}

/** Where an order can go next, for this role (the dashboard's buttons). */
export function nextStatuses(
  from: OrderStatus,
  role: Role,
  fulfillment: Fulfillment,
): OrderStatus[] {
  return MOVES[from]
    .filter(
      (m) =>
        m.roles.includes(role) &&
        (!m.fulfillment || m.fulfillment === fulfillment),
    )
    .map((m) => m.to);
}

/** FR-ORD-05: the customer may cancel until the shop confirms. */
export function customerCanCancel(
  status: OrderStatus,
  paymentStatus: PaymentStatus = 'PENDING',
): boolean {
  // Money already sent (a Sham Cash receipt) needs the shop to refund it, so
  // the customer talks to the shop instead of cancelling here.
  return (
    status === 'NEW' &&
    paymentStatus !== 'SUBMITTED' &&
    paymentStatus !== 'PAID'
  );
}

/** Stock and the slot go back when an order ends this way (FR-INV-02). */
export function releasesStock(to: OrderStatus): boolean {
  return to === 'CANCELLED';
}
