import { randomUUID } from 'node:crypto';
import type {} from 'multer';
import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Put,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { MediaStorage } from '../../adapters/storage/media-storage.js';
import { AppError } from '../../common/errors/app-error.js';
import {
  type AuthUser,
  CurrentUser,
  Public,
  Roles,
} from '../accounts/auth/auth.decorators.js';
import { MediaUploadDto } from '../catalog/dto/admin-catalog.dto.js';
import { processImage } from '../media/image-processing.js';
import { DesignerService } from './designer.service.js';
import {
  DesignerCatalogDto,
  DesignerQuoteDto,
  DesignerQuoteRequestDto,
  DesignerSizeDto,
  PreviewImageDto,
  SizeLimitsDto,
} from './dto/designer.dto.js';

/** A rendered 2D preview is 1080 x 1350 (FR-D2D-05); a few hundred KB as PNG. */
const PREVIEW_MAX_BYTES = 3 * 1024 * 1024;

/** The designer works without an account, like the rest of browsing. */
@ApiTags('designer')
@Controller('designer')
export class DesignerController {
  constructor(
    private readonly designer: DesignerService,
    private readonly storage: MediaStorage,
  ) {}

  @Public()
  @Get('catalog')
  @ApiOperation({
    summary:
      "Sizes, palettes, occasions, items with today's stock and slot layouts (screens 15-17)",
  })
  @ApiOkResponse({ type: DesignerCatalogDto })
  catalog(): Promise<DesignerCatalogDto> {
    return this.designer.catalog();
  }

  @Public()
  @Post('quote')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'Price and check a bouquet spec; stock problems come with substitutes (FR-DSG-03/08)',
  })
  @ApiOkResponse({ type: DesignerQuoteDto })
  quote(@Body() dto: DesignerQuoteRequestDto): Promise<DesignerQuoteDto> {
    return this.designer.quote(dto.spec);
  }

  /** Stored so WhatsApp messages, the cart and the recipe can link to it (FR-D2D-05). */
  @Public()
  @Post('preview-image')
  @Throttle({ default: { limit: 20, ttl: 60_000 } })
  @UseInterceptors(
    FileInterceptor('file', {
      limits: { fileSize: PREVIEW_MAX_BYTES, files: 1 },
    }),
  )
  @ApiConsumes('multipart/form-data')
  @ApiBody({ type: MediaUploadDto })
  @ApiOperation({ summary: 'Upload the rendered 2D preview (PNG, re-encoded)' })
  @ApiCreatedResponse({ type: PreviewImageDto })
  async previewImage(
    @UploadedFile() file: Express.Multer.File | undefined,
  ): Promise<PreviewImageDto> {
    if (!file) throw new AppError('VALIDATION_FAILED', { detail: 'no file' });
    const image = await processImage(file.buffer, {
      maxBytes: PREVIEW_MAX_BYTES,
    });
    const url = await this.storage.put(
      `previews/${randomUUID()}.webp`,
      image.bytes,
      image.contentType,
    );
    return { url };
  }
}

@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin/designer')
export class AdminDesignerController {
  constructor(private readonly designer: DesignerService) {}

  @Put('sizes')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({ summary: 'Stem limits per size (FR-DSG-04)' })
  @ApiOkResponse({ type: [DesignerSizeDto] })
  sizes(
    @CurrentUser() actor: AuthUser,
    @Body() dto: SizeLimitsDto,
  ): Promise<DesignerSizeDto[]> {
    return this.designer.setSizeLimits(actor, dto);
  }
}
