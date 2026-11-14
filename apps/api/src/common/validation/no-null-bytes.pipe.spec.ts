import { NoNullBytesPipe, hasNullByte } from './no-null-bytes.pipe.js';

describe('NUL characters are refused (ZAP, S8)', () => {
  it('finds them in strings, nested values and keys', () => {
    expect(hasNullByte('ورد\u0000')).toBe(true);
    expect(hasNullByte({ lines: [{ note: 'a\u0000b' }] })).toBe(true);
    expect(hasNullByte({ ['k\u0000']: 1 })).toBe(true);
    expect(hasNullByte({ q: 'ورد', page: 1, tags: ['red'] })).toBe(false);
    expect(hasNullByte(Buffer.from([0, 1, 2]))).toBe(false);
    expect(hasNullByte(null)).toBe(false);
  });

  it('turns them into VALIDATION_FAILED and lets the rest through', () => {
    const pipe = new NoNullBytesPipe();
    expect(() => pipe.transform('\u0000')).toThrow(
      expect.objectContaining({ code: 'VALIDATION_FAILED' }),
    );
    expect(pipe.transform({ q: 'جوري' })).toEqual({ q: 'جوري' });
  });
});
