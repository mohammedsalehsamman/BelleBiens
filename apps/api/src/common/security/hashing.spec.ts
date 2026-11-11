import {
  hmacSha256,
  numericCode,
  randomToken,
  safeEqualHex,
  sha256,
} from './hashing.js';

describe('hashing helpers', () => {
  it('numericCode has the requested length and only digits', () => {
    for (let i = 0; i < 200; i++) {
      const code = numericCode(4);
      expect(code).toMatch(/^\d{4}$/);
    }
    expect(numericCode(6)).toMatch(/^\d{6}$/);
  });

  it('randomToken is long, URL safe and unique', () => {
    const a = randomToken();
    const b = randomToken();
    expect(a).toMatch(/^[A-Za-z0-9_-]{43}$/);
    expect(a).not.toBe(b);
  });

  it('sha256 and hmacSha256 are stable and differ by key', () => {
    expect(sha256('abc')).toBe(
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
    );
    expect(hmacSha256('k1', '1234')).not.toBe(hmacSha256('k2', '1234'));
  });

  it('safeEqualHex compares digests', () => {
    const h = sha256('x');
    expect(safeEqualHex(h, sha256('x'))).toBe(true);
    expect(safeEqualHex(h, sha256('y'))).toBe(false);
    expect(safeEqualHex(h, 'ab')).toBe(false);
  });
});
