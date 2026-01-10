/*
  Warnings:

  - A unique constraint covering the columns `[serviceType,vehicleType]` on the table `pricing_rules` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId,endpoint]` on the table `rate_limits` will be added. If there are existing duplicate values, this will fail.
  - Changed the type of `ratedType` on the `ratings` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "RatedType" AS ENUM ('DRIVER', 'MERCHANT', 'USER');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('PAYMENT', 'REFUND', 'PARTIAL_REFUND', 'ADJUSTMENT');

-- CreateEnum
CREATE TYPE "TransactionStatus" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "PromotionType" AS ENUM ('PERCENTAGE', 'FIXED_AMOUNT', 'FREE_SHIPPING');

-- CreateEnum
CREATE TYPE "PromotionStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'EXPIRED', 'SCHEDULED');

-- CreateEnum
CREATE TYPE "CouponStatus" AS ENUM ('ACTIVE', 'USED', 'EXPIRED', 'DISABLED');

-- DropIndex (with check if exists)
DROP INDEX IF EXISTS "pricing_rules_serviceType_vehicleType_isActive_key";

-- AlterTable
ALTER TABLE "ratings" DROP COLUMN "ratedType",
ADD COLUMN     "ratedType" "RatedType" NOT NULL;

-- CreateTable
CREATE TABLE "payment_transactions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "orderId" UUID,
    "rideId" UUID,
    "transactionNumber" TEXT NOT NULL,
    "type" "TransactionType" NOT NULL,
    "status" "TransactionStatus" NOT NULL DEFAULT 'PENDING',
    "amount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'VND',
    "paymentMethod" "PaymentMethod" NOT NULL,
    "provider" TEXT,
    "providerId" TEXT,
    "providerResponse" JSONB,
    "refundReason" TEXT,
    "refundedAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "payment_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_addresses" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "label" TEXT,
    "recipientName" TEXT NOT NULL,
    "recipientPhone" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "city" TEXT,
    "province" TEXT,
    "district" TEXT,
    "ward" TEXT,
    "latitude" DECIMAL(10,8),
    "longitude" DECIMAL(11,8),
    "isDefault" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "user_addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "promotions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "code" TEXT NOT NULL,
    "type" "PromotionType" NOT NULL,
    "discountPercent" DECIMAL(5,2),
    "discountAmount" DECIMAL(12,2),
    "minOrderAmount" DECIMAL(12,2),
    "maxDiscountAmount" DECIMAL(12,2),
    "maxUsage" INTEGER,
    "maxUsagePerUser" INTEGER DEFAULT 1,
    "serviceTypes" JSONB,
    "status" "PromotionStatus" NOT NULL DEFAULT 'ACTIVE',
    "startsAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "totalUsage" INTEGER NOT NULL DEFAULT 0,
    "totalDiscount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "promotions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "coupons" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "code" TEXT NOT NULL,
    "promotionId" UUID,
    "userId" UUID,
    "status" "CouponStatus" NOT NULL DEFAULT 'ACTIVE',
    "expiresAt" TIMESTAMP(3),
    "usedAt" TIMESTAMP(3),
    "usedBy" UUID,
    "usedInOrderId" UUID,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "coupons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "order_discounts" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "orderId" UUID NOT NULL,
    "promotionId" UUID,
    "couponId" UUID,
    "discountAmount" DECIMAL(12,2) NOT NULL,
    "discountType" "PromotionType" NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "order_discounts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "payment_transactions_transactionNumber_key" ON "payment_transactions"("transactionNumber");

-- CreateIndex
CREATE INDEX "payment_transactions_orderId_idx" ON "payment_transactions"("orderId");

-- CreateIndex
CREATE INDEX "payment_transactions_rideId_idx" ON "payment_transactions"("rideId");

-- CreateIndex
CREATE INDEX "payment_transactions_transactionNumber_idx" ON "payment_transactions"("transactionNumber");

-- CreateIndex
CREATE INDEX "payment_transactions_type_idx" ON "payment_transactions"("type");

-- CreateIndex
CREATE INDEX "payment_transactions_status_idx" ON "payment_transactions"("status");

-- CreateIndex
CREATE INDEX "payment_transactions_provider_idx" ON "payment_transactions"("provider");

-- CreateIndex
CREATE INDEX "payment_transactions_providerId_idx" ON "payment_transactions"("providerId");

-- CreateIndex
CREATE INDEX "payment_transactions_createdAt_idx" ON "payment_transactions"("createdAt");

-- CreateIndex
CREATE INDEX "payment_transactions_status_createdAt_idx" ON "payment_transactions"("status", "createdAt");

-- CreateIndex
CREATE INDEX "user_addresses_userId_idx" ON "user_addresses"("userId");

-- CreateIndex
CREATE INDEX "user_addresses_isDefault_idx" ON "user_addresses"("isDefault");

-- CreateIndex
CREATE INDEX "user_addresses_isActive_idx" ON "user_addresses"("isActive");

-- CreateIndex
CREATE INDEX "user_addresses_deletedAt_idx" ON "user_addresses"("deletedAt");

-- CreateIndex
CREATE INDEX "user_addresses_userId_isDefault_idx" ON "user_addresses"("userId", "isDefault");

-- CreateIndex
CREATE UNIQUE INDEX "promotions_code_key" ON "promotions"("code");

-- CreateIndex
CREATE INDEX "promotions_code_idx" ON "promotions"("code");

-- CreateIndex
CREATE INDEX "promotions_status_idx" ON "promotions"("status");

-- CreateIndex
CREATE INDEX "promotions_startsAt_idx" ON "promotions"("startsAt");

-- CreateIndex
CREATE INDEX "promotions_expiresAt_idx" ON "promotions"("expiresAt");

-- CreateIndex
CREATE INDEX "promotions_status_expiresAt_idx" ON "promotions"("status", "expiresAt");

-- CreateIndex
CREATE UNIQUE INDEX "coupons_code_key" ON "coupons"("code");

-- CreateIndex
CREATE INDEX "coupons_code_idx" ON "coupons"("code");

-- CreateIndex
CREATE INDEX "coupons_promotionId_idx" ON "coupons"("promotionId");

-- CreateIndex
CREATE INDEX "coupons_userId_idx" ON "coupons"("userId");

-- CreateIndex
CREATE INDEX "coupons_status_idx" ON "coupons"("status");

-- CreateIndex
CREATE INDEX "coupons_expiresAt_idx" ON "coupons"("expiresAt");

-- CreateIndex
CREATE INDEX "coupons_usedBy_idx" ON "coupons"("usedBy");

-- CreateIndex
CREATE INDEX "order_discounts_orderId_idx" ON "order_discounts"("orderId");

-- CreateIndex
CREATE INDEX "order_discounts_promotionId_idx" ON "order_discounts"("promotionId");

-- CreateIndex
CREATE INDEX "order_discounts_couponId_idx" ON "order_discounts"("couponId");

-- CreateIndex
CREATE INDEX "pricing_rules_serviceType_vehicleType_isActive_idx" ON "pricing_rules"("serviceType", "vehicleType", "isActive");

-- CreateIndex (with check for existing constraint)
DO $$ 
BEGIN
  -- Drop existing unique constraint if exists
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'pricing_rules_serviceType_vehicleType_key'
  ) THEN
    ALTER TABLE "pricing_rules" DROP CONSTRAINT "pricing_rules_serviceType_vehicleType_key";
  END IF;
  
  -- Create new unique constraint
  CREATE UNIQUE INDEX "pricing_rules_serviceType_vehicleType_key" 
  ON "pricing_rules"("serviceType", "vehicleType");
END $$;

-- CreateIndex (with check for existing constraint)
DO $$ 
BEGIN
  -- Drop existing unique constraint if exists
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'rate_limits_userId_endpoint_key'
  ) THEN
    ALTER TABLE "rate_limits" DROP CONSTRAINT "rate_limits_userId_endpoint_key";
  END IF;
  
  -- Check if index exists (might be index instead of constraint)
  IF EXISTS (
    SELECT 1 FROM pg_indexes 
    WHERE indexname = 'rate_limits_userId_endpoint_key'
  ) THEN
    DROP INDEX IF EXISTS "rate_limits_userId_endpoint_key";
  END IF;
  
  -- Create new unique index
  CREATE UNIQUE INDEX "rate_limits_userId_endpoint_key" 
  ON "rate_limits"("userId", "endpoint");
END $$;

-- CreateIndex
CREATE INDEX "ratings_ratedType_idx" ON "ratings"("ratedType");

-- AddForeignKey
ALTER TABLE "notification_delivery_logs" ADD CONSTRAINT "notification_delivery_logs_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES "notifications"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_devices" ADD CONSTRAINT "user_devices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_transactions" ADD CONSTRAINT "payment_transactions_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "orders"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_transactions" ADD CONSTRAINT "payment_transactions_rideId_fkey" FOREIGN KEY ("rideId") REFERENCES "rides"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_addresses" ADD CONSTRAINT "user_addresses_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coupons" ADD CONSTRAINT "coupons_promotionId_fkey" FOREIGN KEY ("promotionId") REFERENCES "promotions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coupons" ADD CONSTRAINT "coupons_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_discounts" ADD CONSTRAINT "order_discounts_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_discounts" ADD CONSTRAINT "order_discounts_promotionId_fkey" FOREIGN KEY ("promotionId") REFERENCES "promotions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_discounts" ADD CONSTRAINT "order_discounts_couponId_fkey" FOREIGN KEY ("couponId") REFERENCES "coupons"("id") ON DELETE SET NULL ON UPDATE CASCADE;
