-- CreateTable
CREATE TABLE "banners" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "title" TEXT NOT NULL,
    "description" TEXT,
    "thumbnailDesktop" TEXT,
    "thumbnailMobile" TEXT,
    "scope" TEXT NOT NULL,
    "organizationId" UUID,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
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
    "thumbnailDesktop" TEXT,
    "thumbnailMobile" TEXT,
    "order" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "banner_items_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "banners_scope_idx" ON "banners"("scope");

-- CreateIndex
CREATE INDEX "banners_organizationId_idx" ON "banners"("organizationId");

-- CreateIndex
CREATE INDEX "banners_isActive_idx" ON "banners"("isActive");

-- CreateIndex
CREATE INDEX "banners_deletedAt_idx" ON "banners"("deletedAt");

-- CreateIndex
CREATE INDEX "banners_scope_organizationId_idx" ON "banners"("scope", "organizationId");

-- CreateIndex
CREATE INDEX "banner_items_bannerId_idx" ON "banner_items"("bannerId");

-- CreateIndex
CREATE INDEX "banner_items_order_idx" ON "banner_items"("order");

-- CreateIndex
CREATE INDEX "banner_items_isActive_idx" ON "banner_items"("isActive");

-- CreateIndex
CREATE INDEX "banner_items_deletedAt_idx" ON "banner_items"("deletedAt");

-- CreateIndex
CREATE INDEX "banner_items_bannerId_order_idx" ON "banner_items"("bannerId", "order");

-- AddForeignKey
ALTER TABLE "banners" ADD CONSTRAINT "banners_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "banner_items" ADD CONSTRAINT "banner_items_bannerId_fkey" FOREIGN KEY ("bannerId") REFERENCES "banners"("id") ON DELETE CASCADE ON UPDATE CASCADE;
