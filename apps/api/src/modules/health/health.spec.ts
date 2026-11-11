import { ServiceUnavailableException } from '@nestjs/common';
import { Test } from '@nestjs/testing';
import { TerminusModule } from '@nestjs/terminus';
import { Clock, FixedClock } from '../../common/clock/clock.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import { DatabaseHealthIndicator } from './database.health.js';
import { HealthController } from './health.controller.js';

describe('Health', () => {
  const queryRaw = vi.fn();

  async function controller(): Promise<HealthController> {
    const moduleRef = await Test.createTestingModule({
      imports: [TerminusModule],
      controllers: [HealthController],
      providers: [
        DatabaseHealthIndicator,
        { provide: PrismaService, useValue: { $queryRaw: queryRaw } },
        {
          provide: Clock,
          useValue: new FixedClock('2026-11-11T12:00:00+03:00'),
        },
      ],
    }).compile();
    return moduleRef.get(HealthController);
  }

  // Block body: an arrow that returns the mock would make Vitest call it as a cleanup hook.
  beforeEach(() => {
    queryRaw.mockReset();
  });

  it('liveness reports ok with the server time, without touching the database', async () => {
    const health = await controller();
    expect(health.liveness()).toEqual({
      status: 'ok',
      time: '2026-11-11T09:00:00.000Z',
    });
    expect(queryRaw).not.toHaveBeenCalled();
  });

  it('readiness is ok when the database answers', async () => {
    queryRaw.mockResolvedValue([{ '?column?': 1 }]);
    const health = await controller();
    const result = await health.readiness();
    expect(result.status).toBe('ok');
    expect(result.details['database']?.status).toBe('up');
  });

  it('readiness fails with 503 when the database is unreachable', async () => {
    queryRaw.mockRejectedValue(new Error('ECONNREFUSED'));
    const health = await controller();
    await expect(health.readiness()).rejects.toBeInstanceOf(
      ServiceUnavailableException,
    );
  });
});
