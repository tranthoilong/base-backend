-- CreateTable
CREATE TABLE "user_favorite_locations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "city" TEXT,
    "province" TEXT,
    "district" TEXT,
    "ward" TEXT,
    "latitude" DECIMAL(10,8) NOT NULL,
    "longitude" DECIMAL(11,8) NOT NULL,
    "locationType" TEXT,
    "displayOrder" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "user_favorite_locations_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "user_favorite_locations" ADD CONSTRAINT "user_favorite_locations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- CreateIndex
CREATE INDEX "user_favorite_locations_userId_idx" ON "user_favorite_locations"("userId");

-- CreateIndex
CREATE INDEX "user_favorite_locations_isActive_idx" ON "user_favorite_locations"("isActive");

-- CreateIndex
CREATE INDEX "user_favorite_locations_displayOrder_idx" ON "user_favorite_locations"("displayOrder");

-- CreateIndex
CREATE INDEX "user_favorite_locations_deletedAt_idx" ON "user_favorite_locations"("deletedAt");

-- CreateIndex
CREATE INDEX "user_favorite_locations_userId_isActive_idx" ON "user_favorite_locations"("userId", "isActive");
