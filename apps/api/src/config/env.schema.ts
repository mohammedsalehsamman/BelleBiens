import { z } from 'zod';

/**
 * Every environment variable the API reads. Validated once at startup so a bad
 * deployment fails fast instead of failing on the first request.
 * Secrets (payment, messaging, AI, media keys) are added here as their modules
 * arrive and must only ever come from the environment or a secret store (NFR-SEC-05).
 */
export const envSchema = z.object({
  NODE_ENV: z
    .enum(['development', 'test', 'staging', 'production'])
    .default('development'),
  PORT: z.coerce.number().int().min(1).max(65535).default(3000),
  DATABASE_URL: z
    .string()
    .regex(
      /^postgres(ql)?:\/\//,
      'DATABASE_URL must be a postgres:// or postgresql:// URL',
    ),
  REDIS_URL: z
    .string()
    .regex(/^rediss?:\/\//, 'REDIS_URL must be a redis:// or rediss:// URL')
    .default('redis://localhost:6379'),
  /** Oldest app version the API still serves; older apps get 426 and an update screen (NFR-CMP-01). */
  APP_MIN_SUPPORTED_VERSION: z
    .string()
    .regex(/^\d+\.\d+\.\d+$/, 'APP_MIN_SUPPORTED_VERSION must look like 1.2.3')
    .default('1.0.0'),
  LOG_LEVEL: z
    .enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent'])
    .default('info'),
});

export type Env = z.infer<typeof envSchema>;

export function validateEnv(raw: Record<string, unknown>): Env {
  const result = envSchema.safeParse(raw);
  if (!result.success) {
    throw new Error(`Invalid environment:\n${z.prettifyError(result.error)}`);
  }
  return result.data;
}
