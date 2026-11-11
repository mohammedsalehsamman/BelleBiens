-- AlterEnum
ALTER TYPE "DesignerItemType" ADD VALUE 'FILLER';

-- CreateTable
CREATE TABLE "designer_size" (
    "key" TEXT NOT NULL,
    "name_ar" TEXT NOT NULL,
    "name_en" TEXT NOT NULL,
    "min_stems" INTEGER NOT NULL,
    "max_stems" INTEGER NOT NULL,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "designer_size_pkey" PRIMARY KEY ("key")
);
