/** Compares "1.2.3"-style versions. Extra labels ("1.2.3+45", "1.2.3-dev") are ignored. */
export function compareVersions(a: string, b: string): number {
  const parse = (v: string) =>
    v
      .split(/[+-]/)[0]!
      .split('.')
      .map((part) => Number.parseInt(part, 10) || 0);
  const left = parse(a);
  const right = parse(b);
  for (let i = 0; i < Math.max(left.length, right.length); i++) {
    const diff = (left[i] ?? 0) - (right[i] ?? 0);
    if (diff !== 0) return Math.sign(diff);
  }
  return 0;
}

/** Header the app sends on every request (NFR-CMP-01). */
export const APP_VERSION_HEADER = 'x-app-version';
