-- AlterTable
ALTER TABLE "drivers" ADD COLUMN     "heading" DOUBLE PRECISION,
ADD COLUMN     "isOnline" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "latitude" DECIMAL(10,8),
ADD COLUMN     "locationUpdatedAt" TIMESTAMP(3),
ADD COLUMN     "longitude" DECIMAL(11,8),
ADD COLUMN     "speed" DOUBLE PRECISION;

-- CreateIndex
CREATE INDEX "drivers_isOnline_idx" ON "drivers"("isOnline");

-- CreateIndex
CREATE INDEX "drivers_latitude_longitude_idx" ON "drivers"("latitude", "longitude");

-- CreateIndex
CREATE INDEX "drivers_isOnline_status_latitude_longitude_idx" ON "drivers"("isOnline", "status", "latitude", "longitude");
