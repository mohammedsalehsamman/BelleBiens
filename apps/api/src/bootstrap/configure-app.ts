import { type INestApplication, ValidationPipe } from '@nestjs/common';
import {
  DocumentBuilder,
  type OpenAPIObject,
  SwaggerModule,
} from '@nestjs/swagger';
import { ConfigService } from '@nestjs/config';
import helmet from 'helmet';
import type { Env } from '../config/env.schema.js';
import { ProblemDetailsFilter } from '../common/errors/problem-details.filter.js';

/** URL prefix of the versioned REST API (EI-CM-02). */
export const API_PREFIX = 'v1';

/**
 * Everything the running server, the e2e tests and the OpenAPI export must share,
 * so tests exercise exactly what production serves.
 */
export function configureApp(app: INestApplication): INestApplication {
  app.setGlobalPrefix(API_PREFIX);
  // Rate limits (throttler, coupon guesses) key on the client address.
  const config = app.get<ConfigService<Env, true>>(ConfigService);
  (
    app.getHttpAdapter().getInstance() as {
      set: (k: string, v: unknown) => void;
    }
  ).set('trust proxy', config.get('TRUST_PROXY', { infer: true }));
  app.use(helmet());
  app.useGlobalPipes(
    new ValidationPipe({
      // Unknown fields are rejected, so a client can never slip in a price (NFR-SEC-06).
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new ProblemDetailsFilter());
  app.enableShutdownHooks();
  return app;
}

export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = new DocumentBuilder()
    .setTitle('Belle Biens API')
    .setDescription(
      'Shared REST API for the Belle Biens app, website and dashboard (BB-SRS-001). ' +
        'Errors use application/problem+json with a stable `code`.',
    )
    .setVersion('1')
    .addBearerAuth()
    .build();
  return SwaggerModule.createDocument(app, config);
}
