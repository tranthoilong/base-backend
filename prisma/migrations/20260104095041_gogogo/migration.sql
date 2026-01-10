-- CreateEnum
CREATE TYPE "DriverStatus" AS ENUM ('PENDING', 'VERIFIED', 'ACTIVE', 'OFFLINE', 'ON_RIDE', 'SUSPENDED', 'REJECTED');

-- CreateEnum
CREATE TYPE "DriverVerificationStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "VehicleType" AS ENUM ('MOTORBIKE', 'CAR_4_SEATS', 'CAR_7_SEATS', 'CAR_16_SEATS', 'VAN');

-- CreateEnum
CREATE TYPE "VehicleStatus" AS ENUM ('AVAILABLE', 'IN_USE', 'MAINTENANCE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "VehicleVerificationStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "RideStatus" AS ENUM ('PENDING', 'ACCEPTED', 'DRIVER_ARRIVED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "RideType" AS ENUM ('IMMEDIATE', 'SCHEDULED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CASH', 'CARD', 'WALLET', 'BANK_TRANSFER');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'PAID', 'REFUNDED', 'FAILED');

-- CreateTable
CREATE TABLE "drivers" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "fullName" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT,
    "dateOfBirth" TIMESTAMP(3),
    "address" TEXT,
    "city" TEXT,
    "province" TEXT,
    "licenseNumber" TEXT,
    "licenseType" TEXT,
    "licenseExpiry" TIMESTAMP(3),
    "licenseFrontUrl" TEXT,
    "licenseBackUrl" TEXT,
    "idCardNumber" TEXT,
    "idCardFrontUrl" TEXT,
    "idCardBackUrl" TEXT,
    "status" "DriverStatus" NOT NULL DEFAULT 'PENDING',
    "verificationStatus" "DriverVerificationStatus" NOT NULL DEFAULT 'PENDING',
    "verifiedAt" TIMESTAMP(3),
    "verifiedBy" UUID,
    "rejectionReason" TEXT,
    "bankName" TEXT,
    "bankAccount" TEXT,
    "accountHolder" TEXT,
    "totalRides" INTEGER NOT NULL DEFAULT 0,
    "completedRides" INTEGER NOT NULL DEFAULT 0,
    "cancelledRides" INTEGER NOT NULL DEFAULT 0,
    "averageRating" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalEarnings" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastOnlineAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "drivers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicles" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "driverId" UUID NOT NULL,
    "type" "VehicleType" NOT NULL,
    "brand" TEXT,
    "model" TEXT,
    "year" INTEGER,
    "color" TEXT,
    "plateNumber" TEXT NOT NULL,
    "registrationNumber" TEXT,
    "registrationFrontUrl" TEXT,
    "registrationBackUrl" TEXT,
    "insuranceUrl" TEXT,
    "inspectionUrl" TEXT,
    "verificationStatus" "VehicleVerificationStatus" NOT NULL DEFAULT 'PENDING',
    "verifiedAt" TIMESTAMP(3),
    "verifiedBy" UUID,
    "rejectionReason" TEXT,
    "status" "VehicleStatus" NOT NULL DEFAULT 'INACTIVE',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "images" JSONB,
    "totalRides" INTEGER NOT NULL DEFAULT 0,
    "totalKm" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rides" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "driverId" UUID,
    "vehicleId" UUID,
    "type" "RideType" NOT NULL DEFAULT 'IMMEDIATE',
    "scheduledAt" TIMESTAMP(3),
    "pickupLatitude" DECIMAL(10,8) NOT NULL,
    "pickupLongitude" DECIMAL(11,8) NOT NULL,
    "pickupAddress" TEXT NOT NULL,
    "pickupNote" TEXT,
    "destinationLatitude" DECIMAL(10,8) NOT NULL,
    "destinationLongitude" DECIMAL(11,8) NOT NULL,
    "destinationAddress" TEXT NOT NULL,
    "destinationNote" TEXT,
    "estimatedDistance" DECIMAL(10,2),
    "actualDistance" DECIMAL(10,2),
    "estimatedDuration" INTEGER,
    "actualDuration" INTEGER,
    "estimatedPrice" DECIMAL(12,2),
    "actualPrice" DECIMAL(12,2),
    "status" "RideStatus" NOT NULL DEFAULT 'PENDING',
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "acceptedAt" TIMESTAMP(3),
    "driverArrivedAt" TIMESTAMP(3),
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancelledBy" TEXT,
    "cancelReason" TEXT,
    "paymentMethod" "PaymentMethod",
    "paymentStatus" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "paidAt" TIMESTAMP(3),
    "platformFee" DECIMAL(12,2),
    "driverEarning" DECIMAL(12,2),
    "userRating" INTEGER,
    "driverRating" INTEGER,
    "userComment" TEXT,
    "driverComment" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "driver_locations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "driverId" UUID NOT NULL,
    "latitude" DECIMAL(10,8) NOT NULL,
    "longitude" DECIMAL(11,8) NOT NULL,
    "heading" DOUBLE PRECISION,
    "speed" DOUBLE PRECISION,
    "accuracy" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "driver_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vehicle_locations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "vehicleId" UUID NOT NULL,
    "latitude" DECIMAL(10,8) NOT NULL,
    "longitude" DECIMAL(11,8) NOT NULL,
    "heading" DOUBLE PRECISION,
    "speed" DOUBLE PRECISION,
    "accuracy" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "vehicle_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ride_locations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "rideId" UUID NOT NULL,
    "latitude" DECIMAL(10,8) NOT NULL,
    "longitude" DECIMAL(11,8) NOT NULL,
    "heading" DOUBLE PRECISION,
    "speed" DOUBLE PRECISION,
    "accuracy" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ride_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ratings" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "rideId" UUID NOT NULL,
    "raterId" UUID NOT NULL,
    "ratedId" UUID NOT NULL,
    "ratedType" TEXT NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "driverRatingId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ratings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pricing_rules" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "vehicleType" "VehicleType" NOT NULL,
    "baseFare" DECIMAL(12,2) NOT NULL,
    "perKmRate" DECIMAL(12,2) NOT NULL,
    "perMinuteRate" DECIMAL(12,2) NOT NULL,
    "minimumFare" DECIMAL(12,2) NOT NULL,
    "minimumDistance" DECIMAL(10,2) NOT NULL,
    "surgeMultiplier" DECIMAL(4,2) NOT NULL DEFAULT 1,
    "nightTimeStart" TEXT,
    "nightTimeEnd" TEXT,
    "nightMultiplier" DECIMAL(4,2) NOT NULL DEFAULT 1,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "pricing_rules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "revenue_shares" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "platformFeePercent" DECIMAL(5,2) NOT NULL,
    "driverSharePercent" DECIMAL(5,2) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "revenue_shares_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "drivers_userId_key" ON "drivers"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "drivers_phone_key" ON "drivers"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "drivers_email_key" ON "drivers"("email");

-- CreateIndex
CREATE UNIQUE INDEX "drivers_licenseNumber_key" ON "drivers"("licenseNumber");

-- CreateIndex
CREATE UNIQUE INDEX "drivers_idCardNumber_key" ON "drivers"("idCardNumber");

-- CreateIndex
CREATE INDEX "drivers_userId_idx" ON "drivers"("userId");

-- CreateIndex
CREATE INDEX "drivers_phone_idx" ON "drivers"("phone");

-- CreateIndex
CREATE INDEX "drivers_email_idx" ON "drivers"("email");

-- CreateIndex
CREATE INDEX "drivers_status_idx" ON "drivers"("status");

-- CreateIndex
CREATE INDEX "drivers_verificationStatus_idx" ON "drivers"("verificationStatus");

-- CreateIndex
CREATE INDEX "drivers_isActive_idx" ON "drivers"("isActive");

-- CreateIndex
CREATE INDEX "drivers_deletedAt_idx" ON "drivers"("deletedAt");

-- CreateIndex
CREATE INDEX "drivers_createdAt_idx" ON "drivers"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "vehicles_plateNumber_key" ON "vehicles"("plateNumber");

-- CreateIndex
CREATE UNIQUE INDEX "vehicles_registrationNumber_key" ON "vehicles"("registrationNumber");

-- CreateIndex
CREATE INDEX "vehicles_driverId_idx" ON "vehicles"("driverId");

-- CreateIndex
CREATE INDEX "vehicles_plateNumber_idx" ON "vehicles"("plateNumber");

-- CreateIndex
CREATE INDEX "vehicles_registrationNumber_idx" ON "vehicles"("registrationNumber");

-- CreateIndex
CREATE INDEX "vehicles_status_idx" ON "vehicles"("status");

-- CreateIndex
CREATE INDEX "vehicles_verificationStatus_idx" ON "vehicles"("verificationStatus");

-- CreateIndex
CREATE INDEX "vehicles_isActive_idx" ON "vehicles"("isActive");

-- CreateIndex
CREATE INDEX "vehicles_deletedAt_idx" ON "vehicles"("deletedAt");

-- CreateIndex
CREATE INDEX "rides_userId_idx" ON "rides"("userId");

-- CreateIndex
CREATE INDEX "rides_driverId_idx" ON "rides"("driverId");

-- CreateIndex
CREATE INDEX "rides_vehicleId_idx" ON "rides"("vehicleId");

-- CreateIndex
CREATE INDEX "rides_status_idx" ON "rides"("status");

-- CreateIndex
CREATE INDEX "rides_type_idx" ON "rides"("type");

-- CreateIndex
CREATE INDEX "rides_requestedAt_idx" ON "rides"("requestedAt");

-- CreateIndex
CREATE INDEX "rides_completedAt_idx" ON "rides"("completedAt");

-- CreateIndex
CREATE INDEX "rides_paymentStatus_idx" ON "rides"("paymentStatus");

-- CreateIndex
CREATE INDEX "rides_userId_status_idx" ON "rides"("userId", "status");

-- CreateIndex
CREATE INDEX "rides_driverId_status_idx" ON "rides"("driverId", "status");

-- CreateIndex
CREATE INDEX "driver_locations_driverId_idx" ON "driver_locations"("driverId");

-- CreateIndex
CREATE INDEX "driver_locations_createdAt_idx" ON "driver_locations"("createdAt");

-- CreateIndex
CREATE INDEX "driver_locations_driverId_createdAt_idx" ON "driver_locations"("driverId", "createdAt");

-- CreateIndex
CREATE INDEX "vehicle_locations_vehicleId_idx" ON "vehicle_locations"("vehicleId");

-- CreateIndex
CREATE INDEX "vehicle_locations_createdAt_idx" ON "vehicle_locations"("createdAt");

-- CreateIndex
CREATE INDEX "ride_locations_rideId_idx" ON "ride_locations"("rideId");

-- CreateIndex
CREATE INDEX "ride_locations_createdAt_idx" ON "ride_locations"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "ratings_rideId_key" ON "ratings"("rideId");

-- CreateIndex
CREATE INDEX "ratings_rideId_idx" ON "ratings"("rideId");

-- CreateIndex
CREATE INDEX "ratings_raterId_idx" ON "ratings"("raterId");

-- CreateIndex
CREATE INDEX "ratings_ratedId_idx" ON "ratings"("ratedId");

-- CreateIndex
CREATE INDEX "ratings_driverRatingId_idx" ON "ratings"("driverRatingId");

-- CreateIndex
CREATE INDEX "ratings_ratedType_idx" ON "ratings"("ratedType");

-- CreateIndex
CREATE INDEX "ratings_createdAt_idx" ON "ratings"("createdAt");

-- CreateIndex
CREATE INDEX "pricing_rules_vehicleType_idx" ON "pricing_rules"("vehicleType");

-- CreateIndex
CREATE INDEX "pricing_rules_isActive_idx" ON "pricing_rules"("isActive");

-- CreateIndex
CREATE INDEX "pricing_rules_deletedAt_idx" ON "pricing_rules"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "pricing_rules_vehicleType_isActive_key" ON "pricing_rules"("vehicleType", "isActive");

-- CreateIndex
CREATE INDEX "revenue_shares_isActive_idx" ON "revenue_shares"("isActive");

-- AddForeignKey
ALTER TABLE "drivers" ADD CONSTRAINT "drivers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicles" ADD CONSTRAINT "vehicles_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "drivers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rides" ADD CONSTRAINT "rides_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rides" ADD CONSTRAINT "rides_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "drivers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rides" ADD CONSTRAINT "rides_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "vehicles"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "driver_locations" ADD CONSTRAINT "driver_locations_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "drivers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vehicle_locations" ADD CONSTRAINT "vehicle_locations_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "vehicles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ride_locations" ADD CONSTRAINT "ride_locations_rideId_fkey" FOREIGN KEY ("rideId") REFERENCES "rides"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ratings" ADD CONSTRAINT "ratings_rideId_fkey" FOREIGN KEY ("rideId") REFERENCES "rides"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ratings" ADD CONSTRAINT "ratings_raterId_fkey" FOREIGN KEY ("raterId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ratings" ADD CONSTRAINT "ratings_driverRatingId_fkey" FOREIGN KEY ("driverRatingId") REFERENCES "drivers"("id") ON DELETE SET NULL ON UPDATE CASCADE;
