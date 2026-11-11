import { BadRequestException, NotFoundException } from '@nestjs/common';
import { AppError } from './app-error.js';
import { codeForStatus, ERROR_CATALOG, pickLanguage } from './error-codes.js';
import {
  PROBLEM_TYPE_BASE,
  ProblemDetailsFilter,
} from './problem-details.filter.js';

const request = (lang?: string) => ({
  headers: lang ? { 'accept-language': lang } : {},
  originalUrl: '/v1/test',
});

describe('ProblemDetailsFilter', () => {
  const filter = new ProblemDetailsFilter();

  it('maps an AppError to problem+json with its code and extra fields', () => {
    const problem = filter.toProblem(
      new AppError('STOCK_INSUFFICIENT', {
        detail: 'white_gypsophila',
        extra: { available: 6 },
      }),
      request(),
    );
    expect(problem).toEqual({
      type: PROBLEM_TYPE_BASE + 'STOCK_INSUFFICIENT',
      title: ERROR_CATALOG.STOCK_INSUFFICIENT.ar,
      status: 409,
      code: 'STOCK_INSUFFICIENT',
      detail: 'white_gypsophila',
      instance: '/v1/test',
      available: 6,
    });
  });

  it('answers in English when the client asks for it, Arabic otherwise (NFR-INT-05)', () => {
    const error = new AppError('OUT_OF_ZONE');
    expect(filter.toProblem(error, request('en-US,en;q=0.9')).title).toBe(
      ERROR_CATALOG.OUT_OF_ZONE.en,
    );
    expect(filter.toProblem(error, request('ar-SY')).title).toBe(
      ERROR_CATALOG.OUT_OF_ZONE.ar,
    );
    expect(filter.toProblem(error, request()).title).toBe(
      ERROR_CATALOG.OUT_OF_ZONE.ar,
    );
  });

  it('turns ValidationPipe errors into VALIDATION_FAILED with the field messages', () => {
    const problem = filter.toProblem(
      new BadRequestException({
        message: ['property price should not exist'],
        error: 'Bad Request',
      }),
      request('en'),
    );
    expect(problem.code).toBe('VALIDATION_FAILED');
    expect(problem.status).toBe(400);
    expect(problem.errors).toEqual(['property price should not exist']);
  });

  it('maps plain HTTP exceptions by status', () => {
    const problem = filter.toProblem(
      new NotFoundException('Cannot GET /v1/nope'),
      request(),
    );
    expect(problem.code).toBe('NOT_FOUND');
    expect(problem.status).toBe(404);
  });

  it('hides internal error details behind a generic 500', () => {
    const problem = filter.toProblem(
      new Error('connection string with password'),
      request(),
    );
    expect(problem.status).toBe(500);
    expect(problem.code).toBe('INTERNAL');
    expect(problem.detail).toBeUndefined();
    expect(JSON.stringify(problem)).not.toContain('password');
  });

  it('catch() writes the problem with the right status and content type', () => {
    const json = vi.fn();
    const type = vi.fn(() => ({ json }));
    const status = vi.fn(() => ({ type }));
    const host = {
      switchToHttp: () => ({
        getRequest: () => request('en'),
        getResponse: () => ({ status }),
      }),
    };

    filter.catch(new AppError('SLOT_FULL'), host as never);

    expect(status).toHaveBeenCalledWith(409);
    expect(type).toHaveBeenCalledWith('application/problem+json');
    expect(json).toHaveBeenCalledWith(
      expect.objectContaining({
        code: 'SLOT_FULL',
        title: ERROR_CATALOG.SLOT_FULL.en,
      }),
    );
  });

  it('every catalog entry has Arabic and English text', () => {
    for (const [code, entry] of Object.entries(ERROR_CATALOG)) {
      expect(entry.ar.length, code).toBeGreaterThan(0);
      expect(entry.en.length, code).toBeGreaterThan(0);
    }
  });
});

describe('codeForStatus', () => {
  it.each([
    [400, 'BAD_REQUEST'],
    [401, 'UNAUTHORIZED'],
    [403, 'FORBIDDEN'],
    [404, 'NOT_FOUND'],
    [409, 'CONFLICT'],
    [426, 'UPGRADE_REQUIRED'],
    [429, 'RATE_LIMITED'],
    [500, 'INTERNAL'],
    [503, 'INTERNAL'],
  ])('%i -> %s', (status, code) => {
    expect(codeForStatus(status)).toBe(code);
  });
});

describe('pickLanguage', () => {
  it.each([
    [undefined, 'ar'],
    ['', 'ar'],
    ['ar', 'ar'],
    ['en', 'en'],
    ['en-GB,ar;q=0.5', 'en'],
    ['fr-FR,en;q=0.8', 'ar'],
    [['en-US'], 'en'],
  ])('%j -> %s', (header, expected) => {
    expect(pickLanguage(header as string | string[] | undefined)).toBe(
      expected,
    );
  });
});
