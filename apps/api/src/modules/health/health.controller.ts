import { Controller, Get } from '@nestjs/common';
import {
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiTags,
} from '@nestjs/swagger';
import { HealthCheck, HealthCheckService } from '@nestjs/terminus';
import { Clock } from '../../common/clock/clock.js';
import { DatabaseHealthIndicator } from './database.health.js';

export class LivenessDto {
  @ApiProperty({ example: 'ok' })
  status!: 'ok';

  @ApiProperty({
    example: '2026-11-11T09:00:00.000Z',
    description: 'Server time (UTC)',
  })
  time!: string;
}

@ApiTags('health')
@Controller('health')
export class HealthController {
  constructor(
    private readonly health: HealthCheckService,
    private readonly database: DatabaseHealthIndicator,
    private readonly clock: Clock,
  ) {}

  @Get()
  @ApiOperation({
    summary: 'Liveness: the process is up. Does not touch the database.',
  })
  @ApiOkResponse({ type: LivenessDto })
  liveness(): LivenessDto {
    return { status: 'ok', time: this.clock.now().toISOString() };
  }

  @Get('ready')
  @HealthCheck()
  @ApiOperation({
    summary: 'Readiness: dependencies (database) are reachable. 503 otherwise.',
  })
  readiness() {
    return this.health.check([() => this.database.isHealthy('database')]);
  }
}
