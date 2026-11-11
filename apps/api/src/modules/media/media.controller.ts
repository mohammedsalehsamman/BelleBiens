import { randomUUID } from 'node:crypto';
import type {} from 'multer';
import {
  Controller,
  Post,
  Query,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiCreatedResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { MediaStorage } from '../../adapters/storage/media-storage.js';
import { AppError } from '../../common/errors/app-error.js';
import type { Env } from '../../config/env.schema.js';
import { Roles } from '../accounts/auth/auth.decorators.js';
import {
  MediaDto,
  MediaQueryDto,
  MediaUploadDto,
} from '../catalog/dto/admin-catalog.dto.js';
import { processImage } from './image-processing.js';

/** Hard cap before the file is even read; the configured limit is checked after. */
const MULTER_LIMIT = 20 * 1024 * 1024;

@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin/media')
export class MediaController {
  constructor(
    private readonly storage: MediaStorage,
    private readonly config: ConfigService<Env, true>,
  ) {}

  @Post()
  @Roles('OWNER', 'MANAGER')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: MULTER_LIMIT, files: 1 } }),
  )
  @ApiConsumes('multipart/form-data')
  @ApiBody({ type: MediaUploadDto })
  @ApiOperation({
    summary:
      'Upload a product photo or a designer cut-out (NFR-SEC-08: checked and re-encoded)',
  })
  @ApiCreatedResponse({ type: MediaDto })
  async upload(
    @UploadedFile() file: Express.Multer.File | undefined,
    @Query() query: MediaQueryDto,
  ): Promise<MediaDto> {
    if (!file) throw new AppError('VALIDATION_FAILED', { detail: 'no file' });
    const kind = query.kind ?? 'product';
    const image = await processImage(file.buffer, {
      maxBytes: this.config.get('MEDIA_MAX_UPLOAD_BYTES', { infer: true }),
      requireAlpha: kind === 'cutout',
    });
    const key = `${kind === 'cutout' ? 'cutouts' : 'products'}/${randomUUID()}.webp`;
    const url = await this.storage.put(key, image.bytes, image.contentType);
    return {
      url,
      contentType: image.contentType,
      width: image.width,
      height: image.height,
    };
  }
}
