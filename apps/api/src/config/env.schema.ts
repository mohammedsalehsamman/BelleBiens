import { z } from 'zod';

/**
 * Every environment variable the API reads. Validated once at startup so a bad
 * deployment fails fast instead of failing on the first request.
 * Secrets (payment, messaging, AI, media keys) are added here as their modules
 * arrive and must only ever come from the environment or a secret store (NFR-SEC-05).
 */
export const envSchema = z
  .object({
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
      .regex(
        /^\d+\.\d+\.\d+$/,
        'APP_MIN_SUPPORTED_VERSION must look like 1.2.3',
      )
      .default('1.0.0'),
    LOG_LEVEL: z
      .enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent'])
      .default('info'),

    // --- Auth (S1) ---
    /** Signs access tokens (HS256). At least 32 random characters; rotate by redeploying. */
    JWT_ACCESS_SECRET: z
      .string()
      .min(32, 'JWT_ACCESS_SECRET must be at least 32 characters'),
    JWT_ACCESS_TTL_SECONDS: z.coerce.number().int().min(60).default(900),
    REFRESH_TOKEN_TTL_DAYS: z.coerce.number().int().min(1).default(30),
    /** Keys the HMAC of stored OTP codes. Defaults to the JWT secret when unset. */
    OTP_PEPPER: z.string().min(16).optional(),
    /** The designs show a 4-digit code (screen 04). 6 is safer; change here, the app follows. */
    OTP_LENGTH: z.coerce.number().int().min(4).max(8).default(4),
    OTP_TTL_SECONDS: z.coerce.number().int().min(60).default(300),
    OTP_MAX_ATTEMPTS: z.coerce.number().int().min(1).default(5),
    OTP_RESEND_SECONDS: z.coerce.number().int().min(0).default(60),
    /** Codes one phone may request per 10 minutes (NFR-SEC-03). */
    OTP_MAX_PER_WINDOW: z.coerce.number().int().min(1).default(3),
    /** Requests per minute per IP on sign-in endpoints (NFR-SEC-03). */
    AUTH_RATE_LIMIT_PER_MINUTE: z.coerce.number().int().min(1).default(10),
    /** Comma-separated OAuth client ids allowed to sign in with Google (EI-SW-06). Empty disables it. */
    GOOGLE_CLIENT_IDS: z.string().default(''),

    // --- Messaging (OI-05: provider still open) ---
    /** `console` logs codes and messages; real providers are added behind the same interface. */
    MESSAGING_PROVIDER: z.enum(['console']).default('console'),
    MAIL_SMTP_URL: z.string().default('smtp://localhost:1025'),
    MAIL_FROM: z.string().default('Belle Biens <no-reply@bellebiens.local>'),
    /** Where password reset links point (the website, later). */
    PUBLIC_WEB_URL: z.url().default('http://localhost:3001'),
  })
  .superRefine((env, ctx) => {
    // The console provider prints sign-in codes to the log: never in production.
    if (env.NODE_ENV === 'production' && env.MESSAGING_PROVIDER === 'console') {
      ctx.addIssue({
        code: 'custom',
        path: ['MESSAGING_PROVIDER'],
        message:
          'MESSAGING_PROVIDER=console is not allowed in production (OI-05: choose a provider)',
      });
    }
  });

export type Env = z.infer<typeof envSchema>;

export function validateEnv(raw: Record<string, unknown>): Env {
  const result = envSchema.safeParse(raw);
  if (!result.success) {
    throw new Error(`Invalid environment:\n${z.prettifyError(result.error)}`);
  }
  return result.data;
}
