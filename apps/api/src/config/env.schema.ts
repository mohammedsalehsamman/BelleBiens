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
    /**
     * Development and test only: every code is this value, so automated end-to-end
     * tests on a device can sign in. Refused in staging and production.
     */
    OTP_FIXED_CODE: z
      .string()
      .regex(/^\d{4,8}$/, 'OTP_FIXED_CODE must be 4 to 8 digits')
      .optional(),
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

    // Media (product photos, later designer cut-outs): any S3-compatible store.
    // Development uses SeaweedFS from infra/docker-compose.yml.
    S3_ENDPOINT: z.url().optional(),
    S3_REGION: z.string().default('us-east-1'),
    S3_BUCKET: z.string().min(3).default('belle-media'),
    S3_ACCESS_KEY_ID: z.string().default('dev'),
    S3_SECRET_ACCESS_KEY: z.string().default('dev'),
    /** Public base URL of the bucket; stored image URLs start with it. */
    MEDIA_PUBLIC_URL: z.url().default('http://localhost:8333/belle-media'),
    /**
     * Which proxies may set X-Forwarded-For, so rate limits see the customer's
     * address and not the proxy's (Express "trust proxy"): "loopback" for a
     * reverse proxy on the same machine, a CIDR list for a load balancer.
     */
    TRUST_PROXY: z.string().default('loopback'),
    /**
     * Background jobs in this process (FR-PAY-10 unpaid orders). Tests run
     * them by hand; a second API instance would set this to "false".
     */
    JOBS_ENABLED: z
      .enum(['true', 'false'])
      .default('true')
      .transform((v) => v === 'true'),
    MEDIA_MAX_UPLOAD_BYTES: z.coerce
      .number()
      .int()
      .positive()
      .default(8 * 1024 * 1024),
  })
  .superRefine((env, ctx) => {
    if (
      env.OTP_FIXED_CODE !== undefined &&
      !['development', 'test'].includes(env.NODE_ENV)
    ) {
      ctx.addIssue({
        code: 'custom',
        path: ['OTP_FIXED_CODE'],
        message: 'OTP_FIXED_CODE is only allowed in development and test',
      });
    }
    if (
      env.OTP_FIXED_CODE !== undefined &&
      env.OTP_FIXED_CODE.length !== env.OTP_LENGTH
    ) {
      ctx.addIssue({
        code: 'custom',
        path: ['OTP_FIXED_CODE'],
        message: 'OTP_FIXED_CODE must have OTP_LENGTH digits',
      });
    }
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
