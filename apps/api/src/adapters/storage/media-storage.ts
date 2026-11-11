import {
  CreateBucketCommand,
  HeadBucketCommand,
  PutBucketPolicyCommand,
  PutObjectCommand,
  S3Client,
} from '@aws-sdk/client-s3';
import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { Env } from '../../config/env.schema.js';

/**
 * Where uploaded media lives (NFR-FLX-02). The store is S3-compatible: SeaweedFS in
 * development, the hosting provider's object storage later (OI-04).
 */
export abstract class MediaStorage {
  /** Stores the bytes under `key` and returns the public URL. */
  abstract put(
    key: string,
    bytes: Buffer,
    contentType: string,
  ): Promise<string>;
}

@Injectable()
export class S3MediaStorage extends MediaStorage {
  private readonly logger = new Logger('MediaStorage');
  private readonly client: S3Client;
  private readonly bucket: string;
  private readonly publicUrl: string;
  private bucketReady: Promise<void> | null = null;

  constructor(config: ConfigService<Env, true>) {
    super();
    const endpoint = config.get('S3_ENDPOINT', { infer: true });
    this.client = new S3Client({
      region: config.get('S3_REGION', { infer: true }),
      endpoint,
      forcePathStyle: endpoint !== undefined,
      credentials: {
        accessKeyId: config.get('S3_ACCESS_KEY_ID', { infer: true }),
        secretAccessKey: config.get('S3_SECRET_ACCESS_KEY', { infer: true }),
      },
    });
    this.bucket = config.get('S3_BUCKET', { infer: true });
    this.publicUrl = config
      .get('MEDIA_PUBLIC_URL', { infer: true })
      .replace(/\/$/, '');
  }

  async put(key: string, bytes: Buffer, contentType: string): Promise<string> {
    await this.ensureBucket();
    await this.client.send(
      new PutObjectCommand({
        Bucket: this.bucket,
        Key: key,
        Body: bytes,
        ContentType: contentType,
        // Names are random and never reused, so the files can be cached for good.
        CacheControl: 'public, max-age=31536000, immutable',
      }),
    );
    return `${this.publicUrl}/${key}`;
  }

  /** Creates the bucket with public read on first use (development convenience). */
  private ensureBucket(): Promise<void> {
    this.bucketReady ??= (async () => {
      try {
        await this.client.send(new HeadBucketCommand({ Bucket: this.bucket }));
        return;
      } catch {
        this.logger.warn(`Creating bucket ${this.bucket}`);
      }
      await this.client.send(new CreateBucketCommand({ Bucket: this.bucket }));
      await this.client
        .send(
          new PutBucketPolicyCommand({
            Bucket: this.bucket,
            Policy: JSON.stringify({
              Version: '2012-10-17',
              Statement: [
                {
                  Effect: 'Allow',
                  Principal: '*',
                  Action: ['s3:GetObject'],
                  Resource: [`arn:aws:s3:::${this.bucket}/*`],
                },
              ],
            }),
          }),
        )
        .catch((error: unknown) => {
          // Some S3-compatible stores serve public reads without a policy.
          this.logger.warn(`Bucket policy not set: ${String(error)}`);
        });
    })().catch((error: unknown) => {
      this.bucketReady = null;
      throw error;
    });
    return this.bucketReady;
  }
}
