import { Module } from '@nestjs/common';
import { MediaController } from '../media/media.controller.js';
import { AdminCatalogController } from './admin-catalog.controller.js';
import { AdminCatalogService } from './admin-catalog.service.js';
import {
  CatalogController,
  FavoritesController,
} from './catalog.controller.js';
import { CatalogService } from './catalog.service.js';

/** Catalog, today's flowers, favorites, branch and pages (S2), plus their admin side. */
@Module({
  controllers: [
    CatalogController,
    FavoritesController,
    AdminCatalogController,
    MediaController,
  ],
  providers: [CatalogService, AdminCatalogService],
  exports: [CatalogService],
})
export class CatalogModule {}
