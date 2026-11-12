-- AlterEnum
ALTER TYPE "PaymentStatus" ADD VALUE 'SUBMITTED';

-- AlterTable
ALTER TABLE "order" ADD COLUMN     "payment_due_at" TIMESTAMPTZ(3),
ADD COLUMN     "payment_note" TEXT NOT NULL DEFAULT '';

-- CreateTable
CREATE TABLE "payment_event" (
    "id" UUID NOT NULL,
    "order_id" UUID NOT NULL,
    "kind" TEXT NOT NULL,
    "method" "PaymentMethod" NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "amount_minor" INTEGER NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'SYP',
    "reference" TEXT,
    "receipt_url" TEXT,
    "note" TEXT NOT NULL DEFAULT '',
    "by_user_id" UUID,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_event_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "payment_event_order_id_idx" ON "payment_event"("order_id");

-- CreateIndex
CREATE INDEX "order_payment_status_payment_due_at_idx" ON "order"("payment_status", "payment_due_at");

-- AddForeignKey
ALTER TABLE "payment_event" ADD CONSTRAINT "payment_event_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "order"("id") ON DELETE CASCADE ON UPDATE CASCADE;
