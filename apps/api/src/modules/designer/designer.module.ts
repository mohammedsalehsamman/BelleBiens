import { Module } from '@nestjs/common';
import {
  AdminDesignerController,
  DesignerController,
} from './designer.controller.js';
import { DesignerService } from './designer.service.js';

/** Bouquet designer: catalog, quote, preview images (S3). */
@Module({
  controllers: [DesignerController, AdminDesignerController],
  providers: [DesignerService],
  exports: [DesignerService],
})
export class DesignerModule {}
