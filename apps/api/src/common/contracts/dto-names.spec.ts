import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';

/** Every .ts file under a folder, generated code left out. */
function sources(dir: string): string[] {
  return readdirSync(dir, { withFileTypes: true }).flatMap((entry) => {
    const path = join(dir, entry.name);
    if (entry.isDirectory())
      return entry.name === 'generated' ? [] : sources(path);
    return entry.name.endsWith('.ts') && !entry.name.endsWith('.spec.ts')
      ? [path]
      : [];
  });
}

describe('DTO names (NFR-MNT-04)', () => {
  it('are unique, because OpenAPI keeps one schema per class name', () => {
    const root = join(import.meta.dirname, '..', '..');
    const names = sources(root).flatMap((file) =>
      [
        ...readFileSync(file, 'utf8').matchAll(
          /^(?:export )?class (\w+Dto)\b/gm,
        ),
      ].map((m) => m[1]!),
    );
    const repeated = names.filter((n, i) => names.indexOf(n) !== i);
    expect(repeated).toEqual([]);
  });
});
