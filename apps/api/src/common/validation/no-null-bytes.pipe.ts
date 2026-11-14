import { type PipeTransform } from '@nestjs/common';
import { AppError } from '../errors/app-error.js';

/** Whether a string anywhere in [value] holds a NUL character. */
export function hasNullByte(value: unknown, depth = 0): boolean {
  if (typeof value === 'string') return value.includes('\u0000');
  if (depth > 20 || value === null || typeof value !== 'object') return false;
  if (Buffer.isBuffer(value)) return false;
  return Object.entries(value).some(
    ([key, item]) => key.includes('\u0000') || hasNullByte(item, depth + 1),
  );
}

/**
 * Postgres cannot store a NUL character in text, so a "%00" in a path, query
 * or body made the query fail with a 500 (found by the ZAP scan, S8). Refused
 * up front as invalid input instead.
 */
export class NoNullBytesPipe implements PipeTransform {
  transform(value: unknown): unknown {
    if (hasNullByte(value)) {
      throw new AppError('VALIDATION_FAILED', {
        detail: 'Text must not contain a NUL character',
      });
    }
    return value;
  }
}
