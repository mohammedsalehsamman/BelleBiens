-- CreateEnum
CREATE TYPE "OccasionType" AS ENUM ('BIRTHDAY', 'ANNIVERSARY', 'GRADUATION', 'OTHER');

-- CreateEnum
CREATE TYPE "NotificationChannel" AS ENUM ('WHATSAPP', 'SMS', 'PUSH');

-- CreateEnum
CREATE TYPE "NotificationStatus" AS ENUM ('PENDING', 'SENT', 'FAILED');

-- AlterTable
ALTER TABLE "address" ADD COLUMN     "call_before_arrival" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "is_default" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "app_user" ADD COLUMN     "notify_occasions" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "notify_whatsapp" BOOLEAN NOT NULL DEFAULT true;

-- CreateTable
CREATE TABLE "occasion_reminder" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "person" TEXT NOT NULL,
    "type" "OccasionType" NOT NULL,
    "date" DATE NOT NULL,
    "remind_days_before" INTEGER NOT NULL DEFAULT 7,
    "reminded_for" DATE,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "occasion_reminder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "saved_design" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "spec" JSONB NOT NULL,
    "preview_url" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "saved_design_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification" (
    "id" UUID NOT NULL,
    "user_id" UUID,
    "order_number" TEXT,
    "channel" "NotificationChannel" NOT NULL,
    "template" TEXT NOT NULL,
    "recipient" TEXT NOT NULL,
    "language" "Language" NOT NULL DEFAULT 'ar',
    "title" TEXT NOT NULL DEFAULT '',
    "body" TEXT NOT NULL,
    "data" JSONB,
    "status" "NotificationStatus" NOT NULL DEFAULT 'PENDING',
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "next_attempt_at" TIMESTAMPTZ(3),
    "last_error" TEXT,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sent_at" TIMESTAMPTZ(3),

    CONSTRAINT "notification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "occasion_reminder_user_id_idx" ON "occasion_reminder"("user_id");

-- CreateIndex
CREATE INDEX "saved_design_user_id_idx" ON "saved_design"("user_id");

-- CreateIndex
CREATE INDEX "notification_status_next_attempt_at_idx" ON "notification"("status", "next_attempt_at");

-- CreateIndex
CREATE INDEX "notification_order_number_idx" ON "notification"("order_number");

-- CreateIndex
CREATE INDEX "notification_user_id_idx" ON "notification"("user_id");

-- AddForeignKey
ALTER TABLE "occasion_reminder" ADD CONSTRAINT "occasion_reminder_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "app_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "saved_design" ADD CONSTRAINT "saved_design_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "app_user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
