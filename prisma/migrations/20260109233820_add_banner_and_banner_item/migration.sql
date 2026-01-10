-- CreateEnum
CREATE TYPE "BannerStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'DRAFT');

-- CreateEnum
CREATE TYPE "BannerPlatform" AS ENUM ('WEB', 'MOBILE', 'ALL');

-- CreateEnum
CREATE TYPE "BannerTargetAudience" AS ENUM ('ALL', 'USER', 'DRIVER');

-- CreateEnum
CREATE TYPE "BannerItemStatus" AS ENUM ('PUBLISH', 'DRAFT');

-- CreateTable
CREATE TABLE "banners" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "key" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "platform" "BannerPlatform" NOT NULL DEFAULT 'ALL',
    "targetAudience" "BannerTargetAudience" NOT NULL DEFAULT 'ALL',
    "thumbnailDesktop" TEXT,
    "thumbnailMobile" TEXT,
    "status" "BannerStatus" NOT NULL DEFAULT 'DRAFT',
    "createdBy" UUID,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "banners_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "banner_items" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "bannerId" UUID NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "link" TEXT,
    "status" "BannerItemStatus" NOT NULL DEFAULT 'DRAFT',
    "orderIndex" INTEGER NOT NULL DEFAULT 0,
    "thumbnailDesktop" TEXT,
    "thumbnailMobile" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "banner_items_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "banners_key_key" ON "banners"("key");

-- CreateIndex
CREATE INDEX "banners_key_idx" ON "banners"("key");

-- CreateIndex
CREATE INDEX "banners_status_idx" ON "banners"("status");

-- CreateIndex
CREATE INDEX "banners_platform_idx" ON "banners"("platform");

-- CreateIndex
CREATE INDEX "banners_targetAudience_idx" ON "banners"("targetAudience");

-- CreateIndex
CREATE INDEX "banners_createdBy_idx" ON "banners"("createdBy");

-- CreateIndex
CREATE INDEX "banners_deletedAt_idx" ON "banners"("deletedAt");

-- CreateIndex
CREATE INDEX "banners_createdAt_idx" ON "banners"("createdAt");

-- CreateIndex
CREATE INDEX "banner_items_bannerId_idx" ON "banner_items"("bannerId");

-- CreateIndex
CREATE INDEX "banner_items_status_idx" ON "banner_items"("status");

-- CreateIndex
CREATE INDEX "banner_items_orderIndex_idx" ON "banner_items"("orderIndex");

-- CreateIndex
CREATE INDEX "banner_items_deletedAt_idx" ON "banner_items"("deletedAt");

-- CreateIndex
CREATE INDEX "banner_items_bannerId_orderIndex_idx" ON "banner_items"("bannerId", "orderIndex");

-- AddForeignKey
ALTER TABLE "banner_items" ADD CONSTRAINT "banner_items_bannerId_fkey" FOREIGN KEY ("bannerId") REFERENCES "banners"("id") ON DELETE CASCADE ON UPDATE CASCADE;
