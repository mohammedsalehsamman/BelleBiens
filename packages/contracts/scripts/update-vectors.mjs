// Regenerates generated vectors (spec-hash.json) and then runs the contract tests.
process.env.UPDATE_VECTORS = '1';
await import('../test/contracts.test.mjs');
