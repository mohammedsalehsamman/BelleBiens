import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  Put,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Matches,
  Max,
  MaxLength,
  Min,
  MinLength,
} from 'class-validator';
import { Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import type { OccasionReminder } from '../../../generated/prisma/client.js';
import { PrismaService } from '../../../infra/prisma/prisma.service.js';
import {
  daysBetween,
  nextOccurrence,
} from '../../notifications/notification-rules.js';
import { type AuthUser, CurrentUser } from '../auth/auth.decorators.js';

const TYPES = ['BIRTHDAY', 'ANNIVERSARY', 'GRADUATION', 'OTHER'] as const;
const DATE = /^\d{4}-\d{2}-\d{2}$/;
const MAX_OCCASIONS = 50;

export class OccasionReminderInputDto {
  @ApiProperty({ example: 'ماما' })
  @IsString()
  @MinLength(1)
  @MaxLength(60)
  person!: string;

  @ApiProperty({ enum: TYPES, enumName: 'OccasionType' })
  @IsIn(TYPES)
  type!: (typeof TYPES)[number];

  @ApiProperty({
    example: '1965-11-19',
    description: 'Only month and day repeat',
  })
  @Matches(DATE)
  date!: string;

  @ApiPropertyOptional({
    type: 'integer',
    example: 7,
    description: 'Default 7',
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(30)
  remindDaysBefore?: number;
}

export class OccasionReminderDto {
  @ApiProperty() id!: string;
  @ApiProperty() person!: string;
  @ApiProperty({ enum: TYPES, enumName: 'OccasionType' })
  type!: (typeof TYPES)[number];
  @ApiProperty({ example: '1965-11-19' }) date!: string;
  @ApiProperty({ type: 'integer' }) remindDaysBefore!: number;
  @ApiProperty({ example: '2026-11-19', description: 'The next time it falls' })
  next!: string;
  @ApiProperty({ type: 'integer', example: 9, description: 'Days until next' })
  daysLeft!: number;
}

/** FR-ACC-07 and screen 31: occasions reminded every year. */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me/occasions')
export class OccasionsController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
  ) {}

  private toDto(row: OccasionReminder): OccasionReminderDto {
    const today = this.clock.nowInShopZone().toISODate()!;
    const date = row.date.toISOString().slice(0, 10);
    const next = nextOccurrence(date, today);
    return {
      id: row.id,
      person: row.person,
      type: row.type,
      date,
      remindDaysBefore: row.remindDaysBefore,
      next,
      daysLeft: daysBetween(today, next),
    };
  }

  private fields(dto: OccasionReminderInputDto) {
    if (Number.isNaN(Date.parse(`${dto.date}T00:00:00Z`))) {
      throw new AppError('VALIDATION_FAILED', { detail: 'date' });
    }
    return {
      person: dto.person.trim(),
      type: dto.type,
      date: new Date(`${dto.date}T00:00:00.000Z`),
      remindDaysBefore: dto.remindDaysBefore ?? 7,
      // A changed date or window may be due again.
      remindedFor: null,
    };
  }

  private async own(user: AuthUser, id: string): Promise<void> {
    const row = await this.prisma.occasionReminder.findUnique({
      where: { id },
    });
    if (!row || row.userId !== user.id) {
      throw new AppError('NOT_FOUND', { detail: `occasion ${id}` });
    }
  }

  @Get()
  @ApiOperation({ summary: 'My occasions, soonest first' })
  @ApiOkResponse({ type: [OccasionReminderDto] })
  async list(@CurrentUser() user: AuthUser): Promise<OccasionReminderDto[]> {
    const rows = await this.prisma.occasionReminder.findMany({
      where: { userId: user.id },
    });
    return rows
      .map((r) => this.toDto(r))
      .sort((a, b) => a.daysLeft - b.daysLeft);
  }

  @Post()
  @ApiOperation({ summary: 'Add an occasion (screen 31 "حفظ المناسبة")' })
  @ApiCreatedResponse({ type: OccasionReminderDto })
  async create(
    @CurrentUser() user: AuthUser,
    @Body() dto: OccasionReminderInputDto,
  ): Promise<OccasionReminderDto> {
    const count = await this.prisma.occasionReminder.count({
      where: { userId: user.id },
    });
    if (count >= MAX_OCCASIONS) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `at most ${MAX_OCCASIONS} occasions`,
      });
    }
    const row = await this.prisma.occasionReminder.create({
      data: { userId: user.id, ...this.fields(dto) },
    });
    return this.toDto(row);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Change an occasion' })
  @ApiOkResponse({ type: OccasionReminderDto })
  async update(
    @CurrentUser() user: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: OccasionReminderInputDto,
  ): Promise<OccasionReminderDto> {
    await this.own(user, id);
    const row = await this.prisma.occasionReminder.update({
      where: { id },
      data: this.fields(dto),
    });
    return this.toDto(row);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Remove an occasion' })
  @ApiNoContentResponse()
  async remove(
    @CurrentUser() user: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<void> {
    await this.own(user, id);
    await this.prisma.occasionReminder.delete({ where: { id } });
  }
}
