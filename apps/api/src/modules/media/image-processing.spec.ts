import sharp from 'sharp';
import { AppError } from '../../common/errors/app-error.js';
import { MAX_IMAGE_SIDE, processImage } from './image-processing.js';

const png = (width: number, height: number, alpha = false) =>
  sharp({
    create: {
      width,
      height,
      channels: alpha ? 4 : 3,
      background: alpha ? { r: 135, g: 35, b: 65, alpha: 0 } : '#872341',
    },
  })
    .png()
    .toBuffer();

const limits = { maxBytes: 1024 * 1024 };

describe('processImage (NFR-SEC-08)', () => {
  it('re-encodes to WebP and keeps the size', async () => {
    const out = await processImage(await png(40, 30), limits);
    expect(out.contentType).toBe('image/webp');
    expect([out.width, out.height]).toEqual([40, 30]);
    const meta = await sharp(out.bytes).metadata();
    expect(meta.format).toBe('webp');
  });

  it('drops metadata such as EXIF', async () => {
    const withExif = await sharp(await png(20, 20))
      .jpeg()
      .withExif({ IFD0: { Copyright: 'secret-location' } })
      .toBuffer();
    const out = await processImage(withExif, limits);
    const meta = await sharp(out.bytes).metadata();
    expect(meta.exif).toBeUndefined();
  });

  it('shrinks large pictures', async () => {
    const out = await processImage(await png(3000, 1500), {
      maxBytes: 10_000_000,
    });
    expect(out.width).toBe(MAX_IMAGE_SIDE);
    expect(out.height).toBe(1000);
  });

  it('judges the type by content, not by name', async () => {
    const html = Buffer.from('<html><script>alert(1)</script></html>');
    await expect(processImage(html, limits)).rejects.toBeInstanceOf(AppError);
  });

  it('refuses empty and oversized files', async () => {
    await expect(processImage(Buffer.alloc(0), limits)).rejects.toThrow(
      'empty',
    );
    await expect(
      processImage(await png(50, 50), { maxBytes: 10 }),
    ).rejects.toThrow('larger');
  });

  it('cut-outs need transparency', async () => {
    await expect(
      processImage(await png(10, 10), { ...limits, requireAlpha: true }),
    ).rejects.toThrow('transparent');
    const out = await processImage(await png(10, 10, true), {
      ...limits,
      requireAlpha: true,
    });
    expect(out.hasAlpha).toBe(true);
  });
});
