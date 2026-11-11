import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { LoggerModule } from 'nestjs-pino';
import { ClockModule } from './common/clock/clock.module.js';
import { type Env, validateEnv } from './config/env.schema.js';
import { PrismaModule } from './infra/prisma/prisma.module.js';
import { HealthModule } from './modules/health/health.module.js';

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
    ClockModule,
    PrismaModule,
    HealthModule,
  ],
})
export class AppModule {}
