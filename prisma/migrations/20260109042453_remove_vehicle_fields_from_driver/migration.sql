/*
  Warnings:

  - You are about to drop the column `engineCapacity` on the `drivers` table. All the data in the column will be lost.
  - You are about to drop the column `licensePlate` on the `drivers` table. All the data in the column will be lost.
  - You are about to drop the column `vehicleBrandId` on the `drivers` table. All the data in the column will be lost.
  - You are about to drop the column `vehicleColor` on the `drivers` table. All the data in the column will be lost.
  - You are about to drop the column `vehicleTypeId` on the `drivers` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "drivers" DROP CONSTRAINT "drivers_vehicleBrandId_fkey";

-- DropForeignKey
ALTER TABLE "drivers" DROP CONSTRAINT "drivers_vehicleTypeId_fkey";

-- DropIndex
DROP INDEX "drivers_vehicleBrandId_idx";

-- DropIndex
DROP INDEX "drivers_vehicleTypeId_idx";

-- AlterTable
ALTER TABLE "drivers" DROP COLUMN "engineCapacity",
DROP COLUMN "licensePlate",
DROP COLUMN "vehicleBrandId",
DROP COLUMN "vehicleColor",
DROP COLUMN "vehicleTypeId";
