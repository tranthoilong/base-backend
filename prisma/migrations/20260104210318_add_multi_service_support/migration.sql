-- Migration: Add Multi-Service Support (Ride, Food Delivery, etc.)
-- This migration adds support for multiple service types in the ride-sharing system

-- Create ServiceType enum
CREATE TYPE "ServiceType" AS ENUM ('RIDE', 'FOOD_DELIVERY', 'PARCEL', 'GROCERY', 'OTHER');

-- Update DriverStatus enum to include ON_DELIVERY
ALTER TYPE "DriverStatus" ADD VALUE IF NOT EXISTS 'ON_DELIVERY';

-- Add serviceTypes column to drivers table
ALTER TABLE "drivers" ADD COLUMN IF NOT EXISTS "serviceTypes" JSONB;

-- Add order statistics to drivers table
ALTER TABLE "drivers" ADD COLUMN IF NOT EXISTS "totalOrders" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "drivers" ADD COLUMN IF NOT EXISTS "completedOrders" INTEGER NOT NULL DEFAULT 0;
ALTER TABLE "drivers" ADD COLUMN IF NOT EXISTS "cancelledOrders" INTEGER NOT NULL DEFAULT 0;

-- Update pricing_rules table
ALTER TABLE "pricing_rules" ADD COLUMN IF NOT EXISTS "serviceType" "ServiceType" NOT NULL DEFAULT 'RIDE';
CREATE INDEX IF NOT EXISTS "pricing_rules_serviceType_idx" ON "pricing_rules"("serviceType");

-- Update unique constraint for pricing_rules
DROP INDEX IF EXISTS "pricing_rules_vehicleType_isActive_key";
CREATE UNIQUE INDEX IF NOT EXISTS "pricing_rules_service_vehicle_active_key" 
  ON "pricing_rules"("serviceType", "vehicleType", "isActive") 
  WHERE "deletedAt" IS NULL;

-- Update revenue_shares table
ALTER TABLE "revenue_shares" ADD COLUMN IF NOT EXISTS "serviceType" "ServiceType";
ALTER TABLE "revenue_shares" ADD COLUMN IF NOT EXISTS "merchantSharePercent" DECIMAL(5,2);
CREATE INDEX IF NOT EXISTS "revenue_shares_serviceType_idx" ON "revenue_shares"("serviceType");

-- Create MerchantStatus enum
CREATE TYPE "MerchantStatus" AS ENUM ('PENDING', 'VERIFIED', 'ACTIVE', 'INACTIVE', 'SUSPENDED', 'REJECTED');

-- Create MerchantVerificationStatus enum
CREATE TYPE "MerchantVerificationStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED', 'EXPIRED');

-- Create ProductStatus enum
CREATE TYPE "ProductStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'OUT_OF_STOCK');

-- Create OrderStatus enum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'CONFIRMED', 'PREPARING', 'READY', 'ASSIGNED', 'PICKED_UP', 'IN_TRANSIT', 'DELIVERED', 'COMPLETED', 'CANCELLED', 'REFUNDED');

-- Create OrderType enum
CREATE TYPE "OrderType" AS ENUM ('IMMEDIATE', 'SCHEDULED');

-- Create merchants table
CREATE TABLE IF NOT EXISTS "merchants" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "phone" TEXT NOT NULL,
    "email" TEXT,
    "address" TEXT NOT NULL,
    "city" TEXT,
    "province" TEXT,
    "district" TEXT,
    "ward" TEXT,
    "latitude" DECIMAL(10,8),
    "longitude" DECIMAL(11,8),
    "businessLicense" TEXT,
    "taxCode" TEXT,
    "bankName" TEXT,
    "bankAccount" TEXT,
    "accountHolder" TEXT,
    "logoUrl" TEXT,
    "coverImageUrl" TEXT,
    "images" JSONB,
    "status" "MerchantStatus" NOT NULL DEFAULT 'PENDING',
    "verificationStatus" "MerchantVerificationStatus" NOT NULL DEFAULT 'PENDING',
    "verifiedAt" TIMESTAMP(3),
    "verifiedBy" UUID,
    "rejectionReason" TEXT,
    "operatingHours" JSONB,
    "deliveryRadius" DECIMAL(10,2),
    "minOrderAmount" DECIMAL(12,2),
    "deliveryFee" DECIMAL(12,2),
    "estimatedPrepTime" INTEGER,
    "totalOrders" INTEGER NOT NULL DEFAULT 0,
    "completedOrders" INTEGER NOT NULL DEFAULT 0,
    "cancelledOrders" INTEGER NOT NULL DEFAULT 0,
    "averageRating" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalRevenue" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isOpen" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "merchants_pkey" PRIMARY KEY ("id")
);

-- Create products table
CREATE TABLE IF NOT EXISTS "products" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "merchantId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DECIMAL(12,2) NOT NULL,
    "imageUrl" TEXT,
    "images" JSONB,
    "category" TEXT,
    "status" "ProductStatus" NOT NULL DEFAULT 'ACTIVE',
    "isAvailable" BOOLEAN NOT NULL DEFAULT true,
    "variants" JSONB,
    "options" JSONB,
    "totalSold" INTEGER NOT NULL DEFAULT 0,
    "averageRating" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- Create orders table
CREATE TABLE IF NOT EXISTS "orders" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "merchantId" UUID NOT NULL,
    "driverId" UUID,
    "type" "OrderType" NOT NULL DEFAULT 'IMMEDIATE',
    "scheduledAt" TIMESTAMP(3),
    "orderNumber" TEXT NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "deliveryFee" DECIMAL(12,2) NOT NULL,
    "discount" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalAmount" DECIMAL(12,2) NOT NULL,
    "deliveryLatitude" DECIMAL(10,8) NOT NULL,
    "deliveryLongitude" DECIMAL(11,8) NOT NULL,
    "deliveryAddress" TEXT NOT NULL,
    "deliveryNote" TEXT,
    "recipientName" TEXT,
    "recipientPhone" TEXT,
    "estimatedDistance" DECIMAL(10,2),
    "actualDistance" DECIMAL(10,2),
    "estimatedDuration" INTEGER,
    "actualDuration" INTEGER,
    "status" "OrderStatus" NOT NULL DEFAULT 'PENDING',
    "requestedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "confirmedAt" TIMESTAMP(3),
    "preparingAt" TIMESTAMP(3),
    "readyAt" TIMESTAMP(3),
    "assignedAt" TIMESTAMP(3),
    "pickedUpAt" TIMESTAMP(3),
    "inTransitAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "cancelledAt" TIMESTAMP(3),
    "cancelledBy" TEXT,
    "cancelReason" TEXT,
    "paymentMethod" "PaymentMethod",
    "paymentStatus" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "paidAt" TIMESTAMP(3),
    "platformFee" DECIMAL(12,2),
    "merchantEarning" DECIMAL(12,2),
    "driverEarning" DECIMAL(12,2),
    "userRating" INTEGER,
    "merchantRating" INTEGER,
    "driverRating" INTEGER,
    "userComment" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "orders_pkey" PRIMARY KEY ("id")
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS "order_items" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "orderId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitPrice" DECIMAL(12,2) NOT NULL,
    "subtotal" DECIMAL(12,2) NOT NULL,
    "selectedVariants" JSONB,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "order_items_pkey" PRIMARY KEY ("id")
);

-- Create order_locations table
CREATE TABLE IF NOT EXISTS "order_locations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "orderId" UUID NOT NULL,
    "latitude" DECIMAL(10,8) NOT NULL,
    "longitude" DECIMAL(11,8) NOT NULL,
    "heading" DOUBLE PRECISION,
    "speed" DOUBLE PRECISION,
    "accuracy" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "order_locations_pkey" PRIMARY KEY ("id")
);

-- Create merchant_locations table
CREATE TABLE IF NOT EXISTS "merchant_locations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "merchantId" UUID NOT NULL,
    "latitude" DECIMAL(10,8) NOT NULL,
    "longitude" DECIMAL(11,8) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "merchant_locations_pkey" PRIMARY KEY ("id")
);

-- Add foreign key constraints
ALTER TABLE "merchants" ADD CONSTRAINT "merchants_userId_fkey" 
    FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "products" ADD CONSTRAINT "products_merchantId_fkey" 
    FOREIGN KEY ("merchantId") REFERENCES "merchants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "orders" ADD CONSTRAINT "orders_userId_fkey" 
    FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "orders" ADD CONSTRAINT "orders_merchantId_fkey" 
    FOREIGN KEY ("merchantId") REFERENCES "merchants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "orders" ADD CONSTRAINT "orders_driverId_fkey" 
    FOREIGN KEY ("driverId") REFERENCES "drivers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "order_items" ADD CONSTRAINT "order_items_orderId_fkey" 
    FOREIGN KEY ("orderId") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order_items" ADD CONSTRAINT "order_items_productId_fkey" 
    FOREIGN KEY ("productId") REFERENCES "products"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "order_locations" ADD CONSTRAINT "order_locations_orderId_fkey" 
    FOREIGN KEY ("orderId") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "merchant_locations" ADD CONSTRAINT "merchant_locations_merchantId_fkey" 
    FOREIGN KEY ("merchantId") REFERENCES "merchants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create indexes for merchants
CREATE UNIQUE INDEX IF NOT EXISTS "merchants_userId_key" ON "merchants"("userId");
CREATE UNIQUE INDEX IF NOT EXISTS "merchants_slug_key" ON "merchants"("slug");
CREATE UNIQUE INDEX IF NOT EXISTS "merchants_phone_key" ON "merchants"("phone");
CREATE UNIQUE INDEX IF NOT EXISTS "merchants_email_key" ON "merchants"("email");
CREATE UNIQUE INDEX IF NOT EXISTS "merchants_businessLicense_key" ON "merchants"("businessLicense");
CREATE UNIQUE INDEX IF NOT EXISTS "merchants_taxCode_key" ON "merchants"("taxCode");
CREATE INDEX IF NOT EXISTS "merchants_userId_idx" ON "merchants"("userId");
CREATE INDEX IF NOT EXISTS "merchants_phone_idx" ON "merchants"("phone");
CREATE INDEX IF NOT EXISTS "merchants_email_idx" ON "merchants"("email");
CREATE INDEX IF NOT EXISTS "merchants_slug_idx" ON "merchants"("slug");
CREATE INDEX IF NOT EXISTS "merchants_status_idx" ON "merchants"("status");
CREATE INDEX IF NOT EXISTS "merchants_verificationStatus_idx" ON "merchants"("verificationStatus");
CREATE INDEX IF NOT EXISTS "merchants_isActive_idx" ON "merchants"("isActive");
CREATE INDEX IF NOT EXISTS "merchants_isOpen_idx" ON "merchants"("isOpen");
CREATE INDEX IF NOT EXISTS "merchants_city_idx" ON "merchants"("city");
CREATE INDEX IF NOT EXISTS "merchants_deletedAt_idx" ON "merchants"("deletedAt");
CREATE INDEX IF NOT EXISTS "merchants_createdAt_idx" ON "merchants"("createdAt");

-- Create indexes for products
CREATE INDEX IF NOT EXISTS "products_merchantId_idx" ON "products"("merchantId");
CREATE INDEX IF NOT EXISTS "products_category_idx" ON "products"("category");
CREATE INDEX IF NOT EXISTS "products_status_idx" ON "products"("status");
CREATE INDEX IF NOT EXISTS "products_isAvailable_idx" ON "products"("isAvailable");
CREATE INDEX IF NOT EXISTS "products_deletedAt_idx" ON "products"("deletedAt");

-- Create indexes for orders
CREATE UNIQUE INDEX IF NOT EXISTS "orders_orderNumber_key" ON "orders"("orderNumber");
CREATE INDEX IF NOT EXISTS "orders_userId_idx" ON "orders"("userId");
CREATE INDEX IF NOT EXISTS "orders_merchantId_idx" ON "orders"("merchantId");
CREATE INDEX IF NOT EXISTS "orders_driverId_idx" ON "orders"("driverId");
CREATE INDEX IF NOT EXISTS "orders_orderNumber_idx" ON "orders"("orderNumber");
CREATE INDEX IF NOT EXISTS "orders_status_idx" ON "orders"("status");
CREATE INDEX IF NOT EXISTS "orders_type_idx" ON "orders"("type");
CREATE INDEX IF NOT EXISTS "orders_requestedAt_idx" ON "orders"("requestedAt");
CREATE INDEX IF NOT EXISTS "orders_completedAt_idx" ON "orders"("completedAt");
CREATE INDEX IF NOT EXISTS "orders_paymentStatus_idx" ON "orders"("paymentStatus");
CREATE INDEX IF NOT EXISTS "orders_userId_status_idx" ON "orders"("userId", "status");
CREATE INDEX IF NOT EXISTS "orders_merchantId_status_idx" ON "orders"("merchantId", "status");
CREATE INDEX IF NOT EXISTS "orders_driverId_status_idx" ON "orders"("driverId", "status");

-- Create indexes for order_items
CREATE INDEX IF NOT EXISTS "order_items_orderId_idx" ON "order_items"("orderId");
CREATE INDEX IF NOT EXISTS "order_items_productId_idx" ON "order_items"("productId");

-- Create indexes for order_locations
CREATE INDEX IF NOT EXISTS "order_locations_orderId_idx" ON "order_locations"("orderId");
CREATE INDEX IF NOT EXISTS "order_locations_createdAt_idx" ON "order_locations"("createdAt");

-- Create indexes for merchant_locations
CREATE INDEX IF NOT EXISTS "merchant_locations_merchantId_idx" ON "merchant_locations"("merchantId");
CREATE INDEX IF NOT EXISTS "merchant_locations_createdAt_idx" ON "merchant_locations"("createdAt");

-- Update ratings table to support orders and merchants
ALTER TABLE "ratings" ADD COLUMN IF NOT EXISTS "serviceType" "ServiceType" NOT NULL DEFAULT 'RIDE';
-- Drop old unique constraint if exists (will be recreated conditionally)
DROP INDEX IF EXISTS "ratings_rideId_key";
ALTER TABLE "ratings" ADD COLUMN IF NOT EXISTS "orderId" UUID;
ALTER TABLE "ratings" ADD COLUMN IF NOT EXISTS "merchantRatingId" UUID;

-- Add foreign keys for ratings
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'ratings_orderId_fkey') THEN
    ALTER TABLE "ratings" ADD CONSTRAINT "ratings_orderId_fkey" 
        FOREIGN KEY ("orderId") REFERENCES "orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'ratings_merchantRatingId_fkey') THEN
    ALTER TABLE "ratings" ADD CONSTRAINT "ratings_merchantRatingId_fkey" 
        FOREIGN KEY ("merchantRatingId") REFERENCES "merchants"("id") ON DELETE SET NULL ON UPDATE CASCADE;
  END IF;
END $$;

-- Create unique constraint for order ratings (only one rating per order)
CREATE UNIQUE INDEX IF NOT EXISTS "ratings_orderId_key" ON "ratings"("orderId") WHERE "orderId" IS NOT NULL;
-- Keep unique constraint for ride ratings
CREATE UNIQUE INDEX IF NOT EXISTS "ratings_rideId_key" ON "ratings"("rideId") WHERE "rideId" IS NOT NULL;

-- Create indexes for ratings
CREATE INDEX IF NOT EXISTS "ratings_orderId_idx" ON "ratings"("orderId");
CREATE INDEX IF NOT EXISTS "ratings_merchantRatingId_idx" ON "ratings"("merchantRatingId");
CREATE INDEX IF NOT EXISTS "ratings_serviceType_idx" ON "ratings"("serviceType");

-- Update drivers table to add relation to orders
-- (Foreign key will be added from orders side)

-- Update users table to add relation to merchants and orders
-- (Foreign keys will be added from merchants and orders side)

