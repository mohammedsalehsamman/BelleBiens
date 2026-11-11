import {
  createHash,
  createHmac,
  randomBytes,
  randomInt,
  timingSafeEqual,
} from 'node:crypto';

/** Random opaque token for refresh tokens and reset links (256 bits, URL safe). */
export function randomToken(): string {
  return randomBytes(32).toString('base64url');
}

/** Tokens are stored as SHA-256 only, so a database leak does not leak sessions. */
export function sha256(value: string): string {
  return createHash('sha256').update(value, 'utf8').digest('hex');
}

/** OTP codes are short, so they are keyed with a server secret before storage. */
export function hmacSha256(secret: string, value: string): string {
  return createHmac('sha256', secret).update(value, 'utf8').digest('hex');
}

/** Constant-time comparison of two hex digests. */
export function safeEqualHex(a: string, b: string): boolean {
  const left = Buffer.from(a, 'hex');
  const right = Buffer.from(b, 'hex');
  return left.length === right.length && timingSafeEqual(left, right);
}

/** Uniformly random numeric code, leading zeros kept ("0427"). */
export function numericCode(length: number): string {
  return String(randomInt(0, 10 ** length)).padStart(length, '0');
}
