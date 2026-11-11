import { compareVersions } from './app-version.js';

describe('compareVersions', () => {
  it.each([
    ['1.0.0', '1.0.0', 0],
    ['1.0.1', '1.0.0', 1],
    ['1.0.0', '1.0.1', -1],
    ['1.10.0', '1.9.9', 1],
    ['2.0', '1.99.99', 1],
    ['1.2.3+45', '1.2.3', 0],
    ['1.2.3-dev', '1.2.4', -1],
    ['1.2', '1.2.0', 0],
  ])('%s vs %s -> %i', (a, b, expected) => {
    expect(compareVersions(a, b)).toBe(expected);
  });
});
