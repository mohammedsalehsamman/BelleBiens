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
  IsObject,
  IsOptional,
  IsString,
  IsUrl,
  MaxLength,
  MinLength,
} from 'class-validator';
import { MediaStorage } from '../../adapters/storage/media-storage.js';
import { AppError } from '../../common/errors/app-error.js';
import type { Prisma, SavedDesign } from '../../generated/prisma/client.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import {
  type AuthUser,
  CurrentUser,
} from '../accounts/auth/auth.decorators.js';
import { LocalizedTextDto } from '../catalog/dto/catalog.dto.js';
import { DesignerService } from './designer.service.js';
import { checkSpecSchema } from './domain/spec.js';

const MAX_DESIGNS = 50;

export class SavedDesignInputDto {
  @ApiProperty({ example: 'عيد ميلاد لين' })
  @IsString()
  @MinLength(1)
  @MaxLength(60)
  name!: string;

  @ApiProperty({ type: Object, description: 'BouquetSpec v1' })
  @IsObject()
  spec!: Record<string, unknown>;

  @ApiPropertyOptional({ description: 'From POST /v1/designer/preview-image' })
  @IsOptional()
  @IsUrl({ require_tld: false, protocols: ['http', 'https'] })
  @MaxLength(500)
  previewUrl?: string;
}

export class SavedDesignDto {
  @ApiProperty() id!: string;
  @ApiProperty() name!: string;
  @ApiProperty({ type: Object, description: 'BouquetSpec v1, as saved' })
  spec!: Record<string, unknown>;
  @ApiPropertyOptional() previewUrl?: string;
  @ApiProperty({ type: 'integer', example: 18 }) stems!: number;
  @ApiPropertyOptional({ type: LocalizedTextDto, description: 'The wrap' })
  wrap?: LocalizedTextDto;
  @ApiProperty({
    type: 'integer',
    example: 267600,
    description: "Today's price: flowers and stock change (screen 30)",
  })
  priceMinor!: number;
  @ApiProperty({ description: 'Everything in it can be ordered today' })
  available!: boolean;
  @ApiProperty() updatedAt!: Date;
}

/** FR-DSG-12 and screen 30: designs kept by a signed-in customer. */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me/designs')
export class SavedDesignsController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly designer: DesignerService,
    private readonly media: MediaStorage,
  ) {}

  /** Priced again now; a design that no longer checks shows unavailable. */
  private async toDto(row: SavedDesign): Promise<SavedDesignDto> {
    const base = {
      id: row.id,
      name: row.name,
      spec: row.spec as Record<string, unknown>,
      ...(row.previewUrl ? { previewUrl: row.previewUrl } : {}),
      updatedAt: row.updatedAt,
    };
    try {
      const quote = await this.designer.quote(row.spec);
      const wrap = quote.lines.find((l) => l.type === 'WRAP');
      return {
        ...base,
        stems: quote.stems,
        ...(wrap ? { wrap: wrap.name } : {}),
        priceMinor: quote.totalMinor,
        available: quote.orderable,
      };
    } catch {
      return { ...base, stems: 0, priceMinor: 0, available: false };
    }
  }

  private fields(dto: SavedDesignInputDto) {
    const checked = checkSpecSchema(dto.spec);
    if (!checked.ok) {
      throw new AppError('SPEC_INVALID', {
        extra: { problems: checked.problems },
      });
    }
    return {
      name: dto.name.trim(),
      spec: dto.spec as Prisma.InputJsonValue,
      previewUrl:
        dto.previewUrl && this.media.owns(dto.previewUrl)
          ? dto.previewUrl
          : null,
    };
  }

  private async own(user: AuthUser, id: string): Promise<void> {
    const row = await this.prisma.savedDesign.findUnique({ where: { id } });
    if (!row || row.userId !== user.id) {
      throw new AppError('NOT_FOUND', { detail: `design ${id}` });
    }
  }

  @Get()
  @ApiOperation({ summary: "My designs, newest first, at today's prices" })
  @ApiOkResponse({ type: [SavedDesignDto] })
  async list(@CurrentUser() user: AuthUser): Promise<SavedDesignDto[]> {
    const rows = await this.prisma.savedDesign.findMany({
      where: { userId: user.id },
      orderBy: { updatedAt: 'desc' },
    });
    return Promise.all(rows.map((r) => this.toDto(r)));
  }

  @Post()
  @ApiOperation({ summary: 'Save a design (FR-DSG-12)' })
  @ApiCreatedResponse({ type: SavedDesignDto })
  async create(
    @CurrentUser() user: AuthUser,
    @Body() dto: SavedDesignInputDto,
  ): Promise<SavedDesignDto> {
    const count = await this.prisma.savedDesign.count({
      where: { userId: user.id },
    });
    if (count >= MAX_DESIGNS) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `at most ${MAX_DESIGNS} designs`,
      });
    }
    const row = await this.prisma.savedDesign.create({
      data: { userId: user.id, ...this.fields(dto) },
    });
    return this.toDto(row);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Rename or replace a saved design' })
  @ApiOkResponse({ type: SavedDesignDto })
  async update(
    @CurrentUser() user: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: SavedDesignInputDto,
  ): Promise<SavedDesignDto> {
    await this.own(user, id);
    const row = await this.prisma.savedDesign.update({
      where: { id },
      data: this.fields(dto),
    });
    return this.toDto(row);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Remove a saved design' })
  @ApiNoContentResponse()
  async remove(
    @CurrentUser() user: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<void> {
    await this.own(user, id);
    await this.prisma.savedDesign.delete({ where: { id } });
  }
}
