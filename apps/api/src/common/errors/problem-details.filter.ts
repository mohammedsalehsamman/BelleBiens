import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpException,
  Logger,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { AppError } from './app-error.js';
import {
  codeForStatus,
  ERROR_CATALOG,
  type ErrorCode,
  pickLanguage,
} from './error-codes.js';

/** RFC 9457 body, plus our stable `code` that the app maps to its own messages. */
export interface ProblemDetails {
  type: string;
  title: string;
  status: number;
  code: ErrorCode;
  detail?: string;
  instance?: string;
  errors?: string[];
  [extra: string]: unknown;
}

export const PROBLEM_TYPE_BASE = 'https://errors.bellebiens.local/';

@Catch()
export class ProblemDetailsFilter implements ExceptionFilter {
  private readonly logger = new Logger(ProblemDetailsFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const http = host.switchToHttp();
    const request = http.getRequest<Request>();
    const response = http.getResponse<Response>();
    const problem = this.toProblem(exception, request);

    if (problem.status >= 500) {
      this.logger.error(
        { err: exception, path: request.originalUrl },
        'Unhandled error while serving request',
      );
    }

    response
      .status(problem.status)
      .type('application/problem+json')
      .json(problem);
  }

  toProblem(
    exception: unknown,
    request: Pick<Request, 'headers' | 'originalUrl'>,
  ): ProblemDetails {
    const lang = pickLanguage(request.headers['accept-language']);
    let status = 500;
    let code: ErrorCode = 'INTERNAL';
    let detail: string | undefined;
    let errors: string[] | undefined;
    let extra: Record<string, unknown> | undefined;

    if (exception instanceof AppError) {
      status = exception.status;
      code = exception.code;
      detail = exception.detail;
      extra = exception.extra;
    } else if (exception instanceof HttpException) {
      status = exception.getStatus();
      code = codeForStatus(status);
      const body = exception.getResponse();
      if (typeof body === 'object' && body !== null && 'message' in body) {
        const message = (body as { message: unknown }).message;
        if (Array.isArray(message)) {
          // class-validator errors from the global ValidationPipe.
          code = 'VALIDATION_FAILED';
          errors = message.map(String);
        } else if (typeof message === 'string' && status < 500) {
          detail = message;
        }
      }
    }

    // Never leak internal error text to clients.
    if (status >= 500) detail = undefined;

    return {
      type: PROBLEM_TYPE_BASE + code,
      title: ERROR_CATALOG[code][lang],
      status,
      code,
      ...(detail !== undefined && { detail }),
      instance: request.originalUrl,
      ...(errors && { errors }),
      ...extra,
    };
  }
}
