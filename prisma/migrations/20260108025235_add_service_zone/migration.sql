-- CreateEnum
CREATE TYPE "ZoneStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateTable
CREATE TABLE "service_zones" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "code" TEXT,
    "coordinates" JSONB NOT NULL,
    "status" "ZoneStatus" NOT NULL DEFAULT 'ACTIVE',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "serviceTypes" JSONB,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "service_zones_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "service_zones_code_key" ON "service_zones"("code");

-- CreateIndex
CREATE INDEX "service_zones_status_idx" ON "service_zones"("status");

-- CreateIndex
CREATE INDEX "service_zones_isActive_idx" ON "service_zones"("isActive");

-- CreateIndex
CREATE INDEX "service_zones_code_idx" ON "service_zones"("code");

-- CreateIndex
CREATE INDEX "service_zones_deletedAt_idx" ON "service_zones"("deletedAt");
