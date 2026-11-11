import { type ExecutionContext, Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { LoggerModule } from 'nestjs-pino';
import { AdaptersModule } from './adapters/adapters.module.js';
import { ClockModule } from './common/clock/clock.module.js';
import { AppVersionGuard } from './common/version/app-version.guard.js';
import { type Env, validateEnv } from './config/env.schema.js';
import { PrismaModule } from './infra/prisma/prisma.module.js';
import { AccountsModule } from './modules/accounts/accounts.module.js';
import { CatalogModule } from './modules/catalog/catalog.module.js';
import { DesignerModule } from './modules/designer/designer.module.js';
import { AUTH_RATE_LIMITED } from './modules/accounts/auth/auth.decorators.js';
import {
  JwtAuthGuard,
  RolesGuard,
} from './modules/accounts/auth/auth.guards.js';
import { AuditModule } from './modules/audit/audit.module.js';
import { HealthModule } from './modules/health/health.module.js';
import { SettingsModule } from './modules/settings/settings.module.js';

/** True when the route or its controller carries @AuthRateLimited(). */
function isAuthRateLimited(context: ExecutionContext): boolean {
  return [context.getHandler(), context.getClass()].some(
    (target) => Reflect.getMetadata(AUTH_RATE_LIMITED, target) === true,
  );
}

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      validate: validateEnv,
    }),
    LoggerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => {
        const env = config.get('NODE_ENV', { infer: true });
        return {
          pinoHttp: {
            level: config.get('LOG_LEVEL', { infer: true }),
            // Structured JSON logs in staging and production (NFR-MNT-05); readable logs locally.
            transport:
              env === 'development' ? { target: 'pino-pretty' } : undefined,
            // Personal data and credentials never reach the logs (NFR-SEC-09).
            redact: {
              paths: [
                'req.headers.authorization',
                'req.headers.cookie',
                'res.headers["set-cookie"]',
              ],
              censor: '[redacted]',
            },
            autoLogging: {
              ignore: (req) => req.url?.startsWith('/v1/health') ?? false,
            },
          },
        };
      },
    }),
    // NFR-SEC-03: a general limit per IP, and a strict one on sign-in endpoints.
    ThrottlerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService<Env, true>) => ({
        throttlers: [
          { name: 'default', ttl: 60_000, limit: 300 },
          {
            name: 'auth',
            ttl: 60_000,
            limit: config.get('AUTH_RATE_LIMIT_PER_MINUTE', { infer: true }),
            skipIf: (context: ExecutionContext) => !isAuthRateLimited(context),
          },
        ],
      }),
    }),
    ClockModule,
    PrismaModule,
    AdaptersModule,
    AuditModule,
    SettingsModule,
    AccountsModule,
    CatalogModule,
    DesignerModule,
    HealthModule,
  ],
  // Order matters: rate limit, then app version, then identity, then role.
  providers: [
    { provide: APP_GUARD, useClass: ThrottlerGuard },
    { provide: APP_GUARD, useClass: AppVersionGuard },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
  ],
})
export class AppModule {}
