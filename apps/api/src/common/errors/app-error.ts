import { ERROR_CATALOG, type ErrorCode } from './error-codes.js';

/**
 * A business error with a stable code. Throw it from services; the problem-details
 * filter turns it into an application/problem+json response.
 *
 * @example throw new AppError('STOCK_INSUFFICIENT', { detail: 'white_gypsophila', extra: { available: 6 } })
 */
export class AppError extends Error {
  readonly status: number;
  readonly detail?: string;
  readonly extra?: Record<string, unknown>;

  constructor(
    readonly code: ErrorCode,
    options: {
      detail?: string;
      extra?: Record<string, unknown>;
      status?: number;
    } = {},
  ) {
    super(options.detail ?? code);
    this.name = 'AppError';
    this.status = options.status ?? ERROR_CATALOG[code].status;
    this.detail = options.detail;
    this.extra = options.extra;
  }
}
