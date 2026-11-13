import { Controller, Get, Query, Res } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { IsIn, IsOptional, Matches } from 'class-validator';
import type { Response } from 'express';
import { DateTime } from 'luxon';
import { Clock, SHOP_TIME_ZONE } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import { PrismaService } from '../../infra/prisma/prisma.service.js';
import { Roles } from '../accounts/auth/auth.decorators.js';
import { shopDate } from '../catalog/domain/product-rules.js';
import { SettingsService } from '../settings/settings.service.js';
import {
  type Period,
  periodsCsv,
  type SalesReport,
  salesReport,
} from './sales-report.js';

const DATE = /^\d{4}-\d{2}-\d{2}$/;
const PERIODS = ['day', 'week', 'month'] as const;
const MAX_DAYS = 400;

class SalesQueryDto {
  @ApiProperty({ example: '2026-11-01' }) @Matches(DATE) from!: string;
  @ApiProperty({ example: '2026-11-30' }) @Matches(DATE) to!: string;
  @ApiPropertyOptional({ enum: PERIODS, default: 'day' })
  @IsOptional()
  @IsIn(PERIODS)
  by?: Period;
  @ApiPropertyOptional({ enum: ['json', 'csv'], default: 'json' })
  @IsOptional()
  @IsIn(['json', 'csv'])
  format?: 'json' | 'csv';
}

class BucketDto {
  @ApiProperty() key!: string;
  @ApiProperty({ type: 'integer' }) orders!: number;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
  @ApiProperty({ type: 'integer' }) totalUsdCents!: number;
}

class CouponBucketDto extends BucketDto {
  @ApiProperty({ type: 'integer' }) discountMinor!: number;
}

class LineBucketDto {
  @ApiProperty() key!: string;
  @ApiProperty() titleAr!: string;
  @ApiProperty() titleEn!: string;
  @ApiProperty({ type: 'integer' }) qty!: number;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
}

export class SalesReportDto {
  @ApiProperty({ type: 'integer' }) orders!: number;
  @ApiProperty({ type: 'integer' }) totalMinor!: number;
  @ApiProperty({ type: 'integer' }) totalUsdCents!: number;
  @ApiProperty({ type: [BucketDto] }) periods!: BucketDto[];
  @ApiProperty({ type: [BucketDto] }) byPaymentMethod!: BucketDto[];
  @ApiProperty({ type: [BucketDto], description: '"pickup" for the branch' })
  byZone!: BucketDto[];
  @ApiProperty({ type: [LineBucketDto] }) byCategory!: LineBucketDto[];
  @ApiProperty({ type: [LineBucketDto], description: 'The top 20' })
  byProduct!: LineBucketDto[];
  @ApiProperty({ type: [CouponBucketDto], description: 'FR-RPT-04' })
  coupons!: CouponBucketDto[];
}

class LowStockDto {
  @ApiProperty({ example: 'white_gypsophila' }) id!: string;
  @ApiProperty() nameAr!: string;
  @ApiProperty() nameEn!: string;
  @ApiProperty({ type: 'integer' }) left!: number;
  @ApiProperty({ enum: ['daily', 'stock', 'product'] }) source!: string;
}

export class DashboardDto {
  @ApiProperty({ example: '2026-11-12' }) date!: string;
  @ApiProperty({
    type: 'integer',
    description: 'To deliver or hand over today',
  })
  ordersToday!: number;
  @ApiProperty({
    type: 'integer',
    description: 'Waiting for the shop to confirm',
  })
  awaitingConfirmation!: number;
  @ApiProperty({ type: 'integer', description: 'Sham Cash receipts to check' })
  paymentsToCheck!: number;
  @ApiProperty({ type: 'integer', description: 'Orders placed today' })
  revenueTodayMinor!: number;
  @ApiProperty({ type: 'integer' }) revenueTodayUsdCents!: number;
  @ApiProperty({ type: [LowStockDto], description: 'FR-INV-04' })
  lowStock!: LowStockDto[];
}

/** FR-RPT-01/03/04 and FR-ADM-10: the owner's numbers. */
@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin')
export class ReportsController {
  constructor(
    private readonly prisma: PrismaService,
    private readonly clock: Clock,
    private readonly settings: SettingsService,
  ) {}

  @Get('reports/sales')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary:
      'Sales by period, category, product, payment, zone and coupon; ?format=csv',
  })
  @ApiOkResponse({ type: SalesReportDto })
  async sales(
    @Query() q: SalesQueryDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<SalesReport | string> {
    const from = DateTime.fromISO(q.from, { zone: SHOP_TIME_ZONE });
    const to = DateTime.fromISO(q.to, { zone: SHOP_TIME_ZONE }).plus({
      days: 1,
    });
    if (!from.isValid || !to.isValid || to <= from) {
      throw new AppError('VALIDATION_FAILED', { detail: 'from and to' });
    }
    if (to.diff(from, 'days').days > MAX_DAYS) {
      throw new AppError('VALIDATION_FAILED', {
        detail: `at most ${MAX_DAYS} days`,
      });
    }
    const orders = await this.prisma.order.findMany({
      where: {
        status: { not: 'CANCELLED' },
        createdAt: { gte: from.toJSDate(), lt: to.toJSDate() },
      },
      include: { lines: true },
    });
    const products = await this.prisma.product.findMany({
      select: {
        slug: true,
        category: { select: { slug: true, nameAr: true, nameEn: true } },
      },
    });
    const categoryOf = new Map(
      products.map((p) => [
        p.slug,
        { key: p.category.slug, ar: p.category.nameAr, en: p.category.nameEn },
      ]),
    );
    const report = salesReport(
      orders.map((o) => ({
        createdAt: o.createdAt,
        paymentMethod: o.paymentMethod,
        zoneSlug: o.zoneSlug,
        couponCode: o.couponCode,
        discountMinor: o.discountMinor,
        totalMinor: o.totalMinor,
        totalUsdCents: o.totalUsdCents,
        lines: o.lines.map((l) => {
          const product = (l.choice as { product?: { slug?: unknown } })
            .product;
          return {
            kind: l.kind,
            titleAr: l.titleAr,
            titleEn: l.titleEn,
            qty: l.qty,
            totalMinor: l.totalMinor,
            slug: typeof product?.slug === 'string' ? product.slug : null,
          };
        }),
      })),
      q.by ?? 'day',
      (slug) => categoryOf.get(slug) ?? null,
    );
    if (q.format === 'csv') {
      res.setHeader('Content-Type', 'text/csv; charset=utf-8');
      res.setHeader(
        'Content-Disposition',
        `attachment; filename="sales-${q.from}-${q.to}.csv"`,
      );
      return periodsCsv(report);
    }
    return report;
  }

  @Get('dashboard')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary: "Today's orders, confirmations, revenue and low stock (FR-ADM-10)",
  })
  @ApiOkResponse({ type: DashboardDto })
  async dashboard(): Promise<DashboardDto> {
    const now = this.clock.nowInShopZone();
    const today = shopDate(this.clock.now());
    const start = now.startOf('day').toJSDate();
    const end = now.startOf('day').plus({ days: 1 }).toJSDate();
    const threshold = await this.settings.get('inventory.lowStockThreshold');
    const [ordersToday, awaiting, toCheck, revenue, daily, counted, products] =
      await Promise.all([
        this.prisma.order.count({
          where: { slotDate: today, status: { not: 'CANCELLED' } },
        }),
        this.prisma.order.count({ where: { status: 'NEW' } }),
        this.prisma.order.count({
          where: { status: 'NEW', paymentStatus: 'SUBMITTED' },
        }),
        this.prisma.order.aggregate({
          where: {
            status: { not: 'CANCELLED' },
            createdAt: { gte: start, lt: end },
          },
          _sum: { totalMinor: true, totalUsdCents: true },
        }),
        this.prisma.dailyAvailability.findMany({
          where: { date: today, quantity: { lte: threshold } },
          include: { item: true },
        }),
        this.prisma.designerItem.findMany({
          where: { status: 'ACTIVE', stockQuantity: { lte: threshold } },
        }),
        this.prisma.product.findMany({
          where: { status: 'ACTIVE', stockQuantity: { lte: threshold } },
        }),
      ]);
    return {
      date: now.toISODate()!,
      ordersToday,
      awaitingConfirmation: awaiting,
      paymentsToCheck: toCheck,
      revenueTodayMinor: revenue._sum.totalMinor ?? 0,
      revenueTodayUsdCents: revenue._sum.totalUsdCents ?? 0,
      lowStock: [
        ...daily
          .filter((d) => d.item.status === 'ACTIVE')
          .map((d) => ({
            id: d.item.slug,
            nameAr: d.item.nameAr,
            nameEn: d.item.nameEn,
            left: d.quantity,
            source: 'daily',
          })),
        ...counted.map((i) => ({
          id: i.slug,
          nameAr: i.nameAr,
          nameEn: i.nameEn,
          left: i.stockQuantity ?? 0,
          source: 'stock',
        })),
        ...products.map((p) => ({
          id: p.slug,
          nameAr: p.nameAr,
          nameEn: p.nameEn,
          left: p.stockQuantity ?? 0,
          source: 'product',
        })),
      ].sort((a, b) => a.left - b.left),
    };
  }
}
