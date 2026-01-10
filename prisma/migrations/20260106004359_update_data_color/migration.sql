/*
  Warnings:

  - You are about to drop the column `licenseType` on the `drivers` table. All the data in the column will be lost.
  - You are about to drop the column `vehicleType` on the `drivers` table. All the data in the column will be lost.
  - The `vehicleType` column on the `pricing_rules` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - You are about to drop the column `brand` on the `vehicles` table. All the data in the column will be lost.
  - Changed the type of `type` on the `vehicles` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "VehicleTypeEnum" AS ENUM ('MOTORBIKE', 'CAR_4_SEATS', 'CAR_7_SEATS', 'CAR_16_SEATS', 'VAN');

-- AlterTable
ALTER TABLE "drivers" DROP COLUMN "licenseType",
DROP COLUMN "vehicleType",
ADD COLUMN     "licenseTypeId" UUID,
ADD COLUMN     "vehicleBrandId" UUID,
ADD COLUMN     "vehicleTypeId" UUID;

-- AlterTable
ALTER TABLE "pricing_rules" DROP COLUMN "vehicleType",
ADD COLUMN     "vehicleType" "VehicleTypeEnum";

-- AlterTable
ALTER TABLE "vehicles" DROP COLUMN "brand",
ADD COLUMN     "brandId" UUID,
ADD COLUMN     "typeId" UUID,
DROP COLUMN "type",
ADD COLUMN     "type" "VehicleTypeEnum" NOT NULL;

-- DropEnum
DROP TYPE "VehicleType";

-- CreateTable
CREATE TABLE "vehicle_types" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameEn" TEXT,
    "description" TEXT,
    "icon" TEXT,
    "displayOrder" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "vehicle_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicle_brands" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameEn" TEXT,
    "logo" TEXT,
    "country" TEXT,
    "description" TEXT,
    "displayOrder" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "vehicle_brands_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "license_types" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameEn" TEXT,
    "description" TEXT,
    "vehicleTypesAllowed" JSONB,
    "minAge" INTEGER,
    "maxAge" INTEGER,
    "validityYears" INTEGER,
    "displayOrder" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "license_types_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "vehicle_types_code_key" ON "vehicle_types"("code");

-- CreateIndex
CREATE INDEX "vehicle_types_code_idx" ON "vehicle_types"("code");

-- CreateIndex
CREATE INDEX "vehicle_types_isActive_idx" ON "vehicle_types"("isActive");

-- CreateIndex
CREATE INDEX "vehicle_types_displayOrder_idx" ON "vehicle_types"("displayOrder");

-- CreateIndex
CREATE INDEX "vehicle_types_deletedAt_idx" ON "vehicle_types"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "vehicle_brands_code_key" ON "vehicle_brands"("code");

-- CreateIndex
CREATE INDEX "vehicle_brands_code_idx" ON "vehicle_brands"("code");

-- CreateIndex
CREATE INDEX "vehicle_brands_isActive_idx" ON "vehicle_brands"("isActive");

-- CreateIndex
CREATE INDEX "vehicle_brands_displayOrder_idx" ON "vehicle_brands"("displayOrder");

-- CreateIndex
CREATE INDEX "vehicle_brands_deletedAt_idx" ON "vehicle_brands"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "license_types_code_key" ON "license_types"("code");

-- CreateIndex
CREATE INDEX "license_types_code_idx" ON "license_types"("code");

-- CreateIndex
CREATE INDEX "license_types_isActive_idx" ON "license_types"("isActive");

-- CreateIndex
CREATE INDEX "license_types_displayOrder_idx" ON "license_types"("displayOrder");

-- CreateIndex
CREATE INDEX "license_types_deletedAt_idx" ON "license_types"("deletedAt");

-- CreateIndex
CREATE INDEX "drivers_vehicleTypeId_idx" ON "drivers"("vehicleTypeId");

-- CreateIndex
CREATE INDEX "drivers_vehicleBrandId_idx" ON "drivers"("vehicleBrandId");

-- CreateIndex
CREATE INDEX "drivers_licenseTypeId_idx" ON "drivers"("licenseTypeId");

-- CreateIndex
CREATE INDEX "pricing_rules_vehicleType_idx" ON "pricing_rules"("vehicleType");

-- CreateIndex
CREATE INDEX "pricing_rules_serviceType_vehicleType_isActive_idx" ON "pricing_rules"("serviceType", "vehicleType", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "pricing_rules_serviceType_vehicleType_key" ON "pricing_rules"("serviceType", "vehicleType");

-- CreateIndex
CREATE INDEX "vehicles_typeId_idx" ON "vehicles"("typeId");

-- CreateIndex
CREATE INDEX "vehicles_brandId_idx" ON "vehicles"("brandId");

-- AddForeignKey
ALTER TABLE "drivers" ADD CONSTRAINT "drivers_vehicleTypeId_fkey" FOREIGN KEY ("vehicleTypeId") REFERENCES "vehicle_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drivers" ADD CONSTRAINT "drivers_vehicleBrandId_fkey" FOREIGN KEY ("vehicleBrandId") REFERENCES "vehicle_brands"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drivers" ADD CONSTRAINT "drivers_licenseTypeId_fkey" FOREIGN KEY ("licenseTypeId") REFERENCES "license_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicles" ADD CONSTRAINT "vehicles_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "vehicle_types"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicles" ADD CONSTRAINT "vehicles_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES "vehicle_brands"("id") ON DELETE SET NULL ON UPDATE CASCADE;
