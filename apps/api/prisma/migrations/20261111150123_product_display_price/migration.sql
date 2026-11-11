-- AlterTable
ALTER TABLE "product" ADD COLUMN     "display_price_minor" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "pairings" TEXT[] DEFAULT ARRAY[]::TEXT[],
ADD COLUMN     "price_from" BOOLEAN NOT NULL DEFAULT false;
