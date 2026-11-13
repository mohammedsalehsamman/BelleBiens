import { Module } from '@nestjs/common';
import { ReportsController } from './reports.controller.js';

/** Sales reports and the dashboard summary (S7, FR-RPT-*, FR-ADM-10). */
@Module({ controllers: [ReportsController] })
export class ReportsModule {}
