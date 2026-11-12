import { Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import type { PaymentMethod } from '../../../generated/prisma/client.js';
import { SettingsService } from '../../settings/settings.service.js';

/** What the customer needs to pay, once the order exists. */
export interface PaymentStart {
  /** FR-PAY-10: unpaid by then, the order is cancelled. Null: no deadline. */
  dueAt: Date | null;
}

/**
 * FR-PAY-07: every payment method behind one interface, so a method can be
 * added or replaced without touching checkout. Sham Cash is manual until the
 * provider offers a confirmation callback (OI-09); Stripe arrives in S12.
 */
export abstract class PaymentProvider {
  abstract readonly method: PaymentMethod;
  /** Takes the order's payment from here. */
  abstract start(now: Date): Promise<PaymentStart>;
  /** The customer may send a reference or receipt for staff to check. */
  abstract readonly takesProof: boolean;
}

/** FR-PAY-02: paid in cash when handed over; staff confirm by phone. */
@Injectable()
export class CashProvider extends PaymentProvider {
  readonly method = 'CASH' as const;
  readonly takesProof = false;

  async start(): Promise<PaymentStart> {
    return Promise.resolve({ dueAt: null });
  }
}

/** FR-PAY-03: the customer pays in the Sham Cash app, then sends the proof. */
@Injectable()
export class ShamCashManualProvider extends PaymentProvider {
  readonly method = 'SHAMCASH' as const;
  readonly takesProof = true;

  constructor(private readonly settings: SettingsService) {
    super();
  }

  async start(now: Date): Promise<PaymentStart> {
    const minutes = await this.settings.get('payments.unpaidTimeoutMinutes');
    return { dueAt: DateTime.fromJSDate(now).plus({ minutes }).toJSDate() };
  }
}

/** Finds the provider for a method; unknown methods are not offered. */
@Injectable()
export class PaymentProviders {
  private readonly byMethod: Map<PaymentMethod, PaymentProvider>;

  constructor(cash: CashProvider, shamcash: ShamCashManualProvider) {
    this.byMethod = new Map<PaymentMethod, PaymentProvider>([
      [cash.method, cash],
      [shamcash.method, shamcash],
    ]);
  }

  get(method: PaymentMethod): PaymentProvider | undefined {
    return this.byMethod.get(method);
  }
}
