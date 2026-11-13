import { Module } from '@nestjs/common';
import {
  AdminDesignerController,
  DesignerController,
} from './designer.controller.js';
import { DesignerService } from './designer.service.js';
import { SavedDesignsController } from './saved-designs.controller.js';

/** Bouquet designer: catalog, quote, preview images (S3), saved designs (S7). */
@Module({
  controllers: [
    DesignerController,
    AdminDesignerController,
    SavedDesignsController,
  ],
  providers: [DesignerService],
  exports: [DesignerService],
})
export class DesignerModule {}
