import { Injectable } from '@nestjs/common';
import { Clock } from '../../common/clock/clock.js';

/**
 * NFR-SEC-03: at most 10 wrong coupon codes per hour from one client, so codes
 * cannot be guessed. Only failures count: a customer whose cart is re-priced
 * with a valid code is never blocked. Kept in memory (one API instance); moves
 * to Redis with the throttler when the API runs on several instances.
 */
@Injectable()
export class CouponAttemptLimiter {
  static readonly maxFailures = 10;
  static readonly windowMs = 60 * 60 * 1000;

  private readonly failures = new Map<string, number[]>();

  constructor(private readonly clock: Clock) {}

  private recent(key: string): number[] {
    const since = this.clock.now().getTime() - CouponAttemptLimiter.windowMs;
    const kept = (this.failures.get(key) ?? []).filter((t) => t > since);
    if (kept.length === 0) this.failures.delete(key);
    else this.failures.set(key, kept);
    return kept;
  }

  blocked(key: string): boolean {
    return this.recent(key).length >= CouponAttemptLimiter.maxFailures;
  }

  /** Seconds until the oldest counted failure leaves the window. */
  retryAfterSeconds(key: string): number {
    const oldest = this.recent(key)[0];
    if (oldest === undefined) return 0;
    const ms =
      oldest + CouponAttemptLimiter.windowMs - this.clock.now().getTime();
    return Math.max(1, Math.ceil(ms / 1000));
  }

  fail(key: string): void {
    this.failures.set(key, [...this.recent(key), this.clock.now().getTime()]);
  }
}
