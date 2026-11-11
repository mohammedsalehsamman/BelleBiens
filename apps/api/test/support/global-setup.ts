import { execSync } from 'node:child_process';
import pg from 'pg';
import { TEST_DATABASE_URL } from './test-env.js';

/** Creates the test database if needed and applies every migration, once per run. */
export default async function setup(): Promise<void> {
  const url = new URL(TEST_DATABASE_URL);
  const database = url.pathname.slice(1);

  const admin = new URL(url);
  admin.pathname = '/postgres';
  admin.search = '';
  const client = new pg.Client({ connectionString: admin.toString() });
  await client.connect();
  try {
    const exists = await client.query(
      'SELECT 1 FROM pg_database WHERE datname = $1',
      [database],
    );
    if (exists.rowCount === 0)
      await client.query(`CREATE DATABASE "${database}"`);
  } finally {
    await client.end();
  }

  execSync('pnpm exec prisma migrate deploy', {
    env: { ...process.env, DATABASE_URL: TEST_DATABASE_URL },
    stdio: 'pipe',
  });
}
