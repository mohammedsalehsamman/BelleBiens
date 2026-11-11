import {
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Put,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { AppError } from '../../common/errors/app-error.js';
import {
  type AuthUser,
  CurrentUser,
  Public,
} from '../accounts/auth/auth.decorators.js';
import { CatalogService } from './catalog.service.js';
import {
  BranchDto,
  CatalogFiltersDto,
  CategoryDto,
  DailyFlowersDto,
  HomeDto,
  OccasionDto,
  OccasionPageDto,
  PageDto,
  ProductCardDto,
  ProductDetailDto,
  ProductPageDto,
  ProductQueryDto,
  SearchQueryDto,
  SearchResultDto,
} from './dto/catalog.dto.js';

const SLUG = /^[a-z0-9][a-z0-9-]{0,79}$/;

function checkSlug(slug: string): string {
  if (!SLUG.test(slug)) throw new AppError('NOT_FOUND', { detail: slug });
  return slug;
}

/** Browsing needs no account (FR-CAT-*, guest checkout FR-CRT-03). */
@ApiTags('catalog')
@Public()
@Controller()
export class CatalogController {
  constructor(private readonly catalog: CatalogService) {}

  @Get('home')
  @ApiOperation({ summary: 'Home screen in one call (screen 06)' })
  @ApiOkResponse({ type: HomeDto })
  home(): Promise<HomeDto> {
    return this.catalog.home();
  }

  @Get('categories')
  @ApiOperation({ summary: 'Categories with product counts (FR-CAT-01)' })
  @ApiOkResponse({ type: [CategoryDto] })
  categories(): Promise<CategoryDto[]> {
    return this.catalog.categories();
  }

  @Get('catalog/filters')
  @ApiOperation({
    summary: 'Filter choices and price range (screen 09, FR-CAT-02)',
  })
  @ApiOkResponse({ type: CatalogFiltersDto })
  filters(): Promise<CatalogFiltersDto> {
    return this.catalog.filters();
  }

  @Get('products')
  @ApiOperation({
    summary:
      'Products with filters, sorting and pages (screen 07, FR-CAT-02/03)',
  })
  @ApiOkResponse({ type: ProductPageDto })
  products(@Query() query: ProductQueryDto): Promise<ProductPageDto> {
    return this.catalog.listProducts(query);
  }

  @Get('products/:slug')
  @ApiOperation({ summary: 'One product with its options (screens 12-14)' })
  @ApiOkResponse({ type: ProductDetailDto })
  product(
    @Param('slug') slug: string,
    @CurrentUser() user: AuthUser | undefined,
  ): Promise<ProductDetailDto> {
    return this.catalog.product(checkSlug(slug), user?.id);
  }

  @Get('search')
  @ApiOperation({
    summary:
      'Arabic-aware search with per-category counts (screen 08, FR-CAT-04)',
  })
  @ApiOkResponse({ type: SearchResultDto })
  search(@Query() query: SearchQueryDto): Promise<SearchResultDto> {
    return this.catalog.search(query);
  }

  @Get('daily-flowers')
  @ApiOperation({
    summary:
      "Today's flowers; expires at midnight Damascus time (screen 10, FR-DLY-*)",
  })
  @ApiOkResponse({ type: DailyFlowersDto })
  dailyFlowers(): Promise<DailyFlowersDto> {
    return this.catalog.dailyFlowers();
  }

  @Get('occasions')
  @ApiOperation({ summary: 'Occasions (FR-CAT-11)' })
  @ApiOkResponse({ type: [OccasionDto] })
  occasions(): Promise<OccasionDto[]> {
    return this.catalog.occasions();
  }

  @Get('occasions/:slug')
  @ApiOperation({ summary: 'An occasion page (screen 11)' })
  @ApiOkResponse({ type: OccasionPageDto })
  occasion(@Param('slug') slug: string): Promise<OccasionPageDto> {
    return this.catalog.occasion(checkSlug(slug));
  }

  @Get('branch')
  @ApiOperation({ summary: 'Branch, hours and contact (screen 34, FR-CON-03)' })
  @ApiOkResponse({ type: BranchDto })
  branch(): Promise<BranchDto> {
    return this.catalog.branch();
  }

  @Get('pages/:slug')
  @ApiOperation({
    summary: 'Delivery, cancellation, privacy and terms (FR-CON-04)',
  })
  @ApiOkResponse({ type: PageDto })
  page(@Param('slug') slug: string): Promise<PageDto> {
    return this.catalog.page(checkSlug(slug));
  }
}

@ApiTags('me')
@ApiBearerAuth()
@Controller('me/favorites')
export class FavoritesController {
  constructor(private readonly catalog: CatalogService) {}

  @Get()
  @ApiOperation({ summary: 'Saved products (screen 32, FR-ACC-06)' })
  @ApiOkResponse({ type: [ProductCardDto] })
  list(@CurrentUser() user: AuthUser): Promise<ProductCardDto[]> {
    return this.catalog.favorites(user.id);
  }

  @Put(':slug')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Save a product' })
  @ApiNoContentResponse()
  async add(
    @CurrentUser() user: AuthUser,
    @Param('slug') slug: string,
  ): Promise<void> {
    await this.catalog.addFavorite(user.id, checkSlug(slug));
  }

  @Delete(':slug')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Remove a saved product' })
  @ApiNoContentResponse()
  async remove(
    @CurrentUser() user: AuthUser,
    @Param('slug') slug: string,
  ): Promise<void> {
    await this.catalog.removeFavorite(user.id, checkSlug(slug));
  }
}
