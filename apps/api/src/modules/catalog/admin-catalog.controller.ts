import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import {
  type AuthUser,
  CurrentUser,
  Roles,
} from '../accounts/auth/auth.decorators.js';
import { AuditQueryDto } from '../admin/admin-users.controller.js';
import { AdminCatalogService } from './admin-catalog.service.js';
import {
  AdminDesignerItemDto,
  AdminProductDto,
  CreateProductDto,
  DailyStemsInputDto,
  DesignerItemInputDto,
  StockAdjustmentDto,
  StockMovementDto,
  TodayListDto,
  UpdateDesignerItemDto,
  UpdateProductDto,
} from './dto/admin-catalog.dto.js';

/**
 * Shop team catalog tools (FR-ADM-02/03/04). Products, prices and designer items
 * are for the owner and the manager; today's list and stock are also the florist's
 * daily work (FR-DLY-01, FR-INV-05).
 */
@ApiTags('admin')
@ApiBearerAuth()
@Controller('admin')
export class AdminCatalogController {
  constructor(private readonly catalog: AdminCatalogService) {}

  @Get('products')
  @Roles('OWNER', 'MANAGER', 'FLORIST')
  @ApiOperation({ summary: 'Every product, hidden ones too' })
  @ApiOkResponse({ type: [AdminProductDto] })
  products(): Promise<AdminProductDto[]> {
    return this.catalog.listProducts();
  }

  @Post('products')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary: 'Add a product with its options and photos (FR-ADM-02)',
  })
  @ApiCreatedResponse({ type: AdminProductDto })
  create(
    @CurrentUser() actor: AuthUser,
    @Body() dto: CreateProductDto,
  ): Promise<AdminProductDto> {
    return this.catalog.createProduct(actor, dto);
  }

  @Patch('products/:id')
  @Roles('OWNER', 'MANAGER')
  @ApiOperation({
    summary: 'Change a product; optionGroups and images replace the old ones',
  })
  @ApiOkResponse({ type: AdminProductDto })
  update(
    @CurrentUser() actor: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateProductDto,
  ): Promise<AdminProductDto> {
    return this.catalog.updateProduct(actor, id, dto);
  }

  @Put('daily-products')
  @Roles('OWNER', 'MANAGER', 'FLORIST')
  @ApiOperation({ summary: "Set today's product list (FR-DLY-02)" })
  @ApiOkResponse({ type: [AdminProductDto] })
  todayList(
    @CurrentUser() actor: AuthUser,
    @Body() dto: TodayListDto,
  ): Promise<AdminProductDto[]> {
    return this.catalog.setTodayList(actor, dto);
  }

  @Get('designer-items')
  @Roles('OWNER', 'MANAGER', 'FLORIST')
  @ApiOperation({ summary: "Designer items with today's stems" })
  @ApiOkResponse({ type: [AdminDesignerItemDto] })
  designerItems(): Promise<AdminDesignerItemDto[]> {
    return this.catalog.listDesignerItems();
  }

  @Post('designer-items')
  @Roles('OWNER', 'MANAGER')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Add a flower, green, wrap, ribbon or extra (FR-ADM-03)',
  })
  @ApiNoContentResponse()
  async createDesignerItem(
    @CurrentUser() actor: AuthUser,
    @Body() dto: DesignerItemInputDto,
  ): Promise<void> {
    await this.catalog.createDesignerItem(actor, dto);
  }

  @Patch('designer-items/:id')
  @Roles('OWNER', 'MANAGER')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Change a designer item' })
  @ApiNoContentResponse()
  async updateDesignerItem(
    @CurrentUser() actor: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateDesignerItemDto,
  ): Promise<void> {
    await this.catalog.updateDesignerItem(actor, id, dto);
  }

  @Put('daily-flowers')
  @Roles('OWNER', 'MANAGER', 'FLORIST')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: "Set today's stems (FR-DLY-01); they expire at midnight",
  })
  @ApiNoContentResponse()
  async dailyFlowers(
    @CurrentUser() actor: AuthUser,
    @Body() dto: DailyStemsInputDto,
  ): Promise<void> {
    await this.catalog.setDailyStems(actor, dto);
  }

  @Post('stock-adjustments')
  @Roles('OWNER', 'MANAGER', 'FLORIST')
  @ApiOperation({ summary: 'Change a stock count with a reason (FR-INV-05)' })
  @ApiCreatedResponse({ type: StockMovementDto })
  adjust(
    @CurrentUser() actor: AuthUser,
    @Body() dto: StockAdjustmentDto,
  ): Promise<StockMovementDto> {
    return this.catalog.adjustStock(actor, dto);
  }

  @Get('stock-movements')
  @Roles('OWNER', 'MANAGER', 'FLORIST')
  @ApiOperation({ summary: 'Latest stock changes (DR-12)' })
  @ApiOkResponse({ type: [StockMovementDto] })
  movements(@Query() query: AuditQueryDto): Promise<StockMovementDto[]> {
    return this.catalog.stockMovements(query.limit ?? 50);
  }
}
