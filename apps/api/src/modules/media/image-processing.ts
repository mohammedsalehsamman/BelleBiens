import { fileTypeFromBuffer } from 'file-type';
import sharp, { type Metadata, type Sharp } from 'sharp';
import { AppError } from '../../common/errors/app-error.js';

const ALLOWED = new Set(['image/jpeg', 'image/png', 'image/webp']);

/** Longest side kept; product photos are shown at most about 1080 px wide. */
export const MAX_IMAGE_SIDE = 2000;

export interface ProcessedImage {
  bytes: Buffer;
  contentType: 'image/webp';
  width: number;
  height: number;
  hasAlpha: boolean;
}

/**
 * NFR-SEC-08: the type is read from the file's own bytes (never the name or the
 * header the client sends), size is limited, and the picture is decoded and
 * re-encoded, which drops metadata such as GPS position and any hidden payload.
 * `requireAlpha` is for designer cut-outs, which must have a transparent background.
 */
export async function processImage(
  input: Buffer,
  options: { maxBytes: number; requireAlpha?: boolean },
): Promise<ProcessedImage> {
  if (input.length === 0) {
    throw new AppError('VALIDATION_FAILED', { detail: 'empty file' });
  }
  if (input.length > options.maxBytes) {
    throw new AppError('VALIDATION_FAILED', {
      detail: `file larger than ${options.maxBytes} bytes`,
      extra: { maxBytes: options.maxBytes },
    });
  }
  const type = await fileTypeFromBuffer(input);
  if (!type || !ALLOWED.has(type.mime)) {
    throw new AppError('VALIDATION_FAILED', {
      detail: 'only JPEG, PNG or WebP images',
    });
  }

  let image: Sharp;
  let meta: Metadata;
  try {
    image = sharp(input, { limitInputPixels: 40_000_000 }).rotate();
    meta = await image.metadata();
  } catch {
    throw new AppError('VALIDATION_FAILED', { detail: 'unreadable image' });
  }
  if (options.requireAlpha && !meta.hasAlpha) {
    throw new AppError('VALIDATION_FAILED', {
      detail: 'cut-outs need a transparent background',
    });
  }

  const { data, info } = await image
    .resize({
      width: MAX_IMAGE_SIDE,
      height: MAX_IMAGE_SIDE,
      fit: 'inside',
      withoutEnlargement: true,
    })
    .webp({ quality: 82 })
    .toBuffer({ resolveWithObject: true });

  return {
    bytes: data,
    contentType: 'image/webp',
    width: info.width,
    height: info.height,
    hasAlpha: info.channels === 4,
  };
}
