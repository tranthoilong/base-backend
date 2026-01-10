-- Migration Template: Add Check Constraints and Validations
-- Run this after applying the schema changes

-- ============================================
-- Check Constraints for Data Validation
-- ============================================

-- Rating constraint: 1-5 stars
ALTER TABLE "ratings" 
ADD CONSTRAINT "ratings_rating_check" 
CHECK (rating >= 1 AND rating <= 5);

-- Ride price constraints
ALTER TABLE "rides"
ADD CONSTRAINT "rides_actualPrice_check"
CHECK (actualPrice IS NULL OR actualPrice >= 0);

ALTER TABLE "rides"
ADD CONSTRAINT "rides_estimatedPrice_check"
CHECK (estimatedPrice IS NULL OR estimatedPrice >= 0);

-- Order amount constraints
ALTER TABLE "orders"
ADD CONSTRAINT "orders_totalAmount_check"
CHECK (totalAmount >= 0);

ALTER TABLE "orders"
ADD CONSTRAINT "orders_subtotal_check"
CHECK (subtotal >= 0);

ALTER TABLE "orders"
ADD CONSTRAINT "orders_deliveryFee_check"
CHECK (deliveryFee >= 0);

ALTER TABLE "orders"
ADD CONSTRAINT "orders_discount_check"
CHECK (discount >= 0);

-- Payment transaction constraints
ALTER TABLE "payment_transactions"
ADD CONSTRAINT "payment_transactions_amount_check"
CHECK (amount != 0); -- Amount cannot be zero

-- User address: Only one default address per user
-- Note: This requires a partial unique index
CREATE UNIQUE INDEX "user_addresses_userId_default_unique" 
ON "user_addresses" ("userId") 
WHERE "isDefault" = true AND "deletedAt" IS NULL;

-- ============================================
-- Spatial Indexes for Location Queries (PostGIS)
-- ============================================
-- Note: Requires PostGIS extension. Uncomment if needed.

-- Enable PostGIS extension
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- Add spatial columns
-- ALTER TABLE "driver_locations" 
-- ADD COLUMN IF NOT EXISTS location_point geometry(Point, 4326);

-- ALTER TABLE "vehicle_locations" 
-- ADD COLUMN IF NOT EXISTS location_point geometry(Point, 4326);

-- ALTER TABLE "ride_locations" 
-- ADD COLUMN IF NOT EXISTS location_point geometry(Point, 4326);

-- ALTER TABLE "order_locations" 
-- ADD COLUMN IF NOT EXISTS location_point geometry(Point, 4326);

-- ALTER TABLE "merchant_locations" 
-- ADD COLUMN IF NOT EXISTS location_point geometry(Point, 4326);

-- ALTER TABLE "user_addresses" 
-- ADD COLUMN IF NOT EXISTS location_point geometry(Point, 4326);

-- Update existing records
-- UPDATE "driver_locations"
-- SET location_point = ST_SetSRID(ST_MakePoint(longitude::float, latitude::float), 4326)
-- WHERE location_point IS NULL;

-- UPDATE "vehicle_locations"
-- SET location_point = ST_SetSRID(ST_MakePoint(longitude::float, latitude::float), 4326)
-- WHERE location_point IS NULL;

-- UPDATE "ride_locations"
-- SET location_point = ST_SetSRID(ST_MakePoint(longitude::float, latitude::float), 4326)
-- WHERE location_point IS NULL;

-- UPDATE "order_locations"
-- SET location_point = ST_SetSRID(ST_MakePoint(longitude::float, latitude::float), 4326)
-- WHERE location_point IS NULL;

-- UPDATE "merchant_locations"
-- SET location_point = ST_SetSRID(ST_MakePoint(longitude::float, latitude::float), 4326)
-- WHERE location_point IS NULL;

-- UPDATE "user_addresses"
-- SET location_point = ST_SetSRID(ST_MakePoint(longitude::float, latitude::float), 4326)
-- WHERE location_point IS NULL AND longitude IS NOT NULL AND latitude IS NOT NULL;

-- Create spatial indexes
-- CREATE INDEX IF NOT EXISTS driver_locations_location_idx 
-- ON driver_locations USING GIST (location_point);

-- CREATE INDEX IF NOT EXISTS vehicle_locations_location_idx 
-- ON vehicle_locations USING GIST (location_point);

-- CREATE INDEX IF NOT EXISTS ride_locations_location_idx 
-- ON ride_locations USING GIST (location_point);

-- CREATE INDEX IF NOT EXISTS order_locations_location_idx 
-- ON order_locations USING GIST (location_point);

-- CREATE INDEX IF NOT EXISTS merchant_locations_location_idx 
-- ON merchant_locations USING GIST (location_point);

-- CREATE INDEX IF NOT EXISTS user_addresses_location_idx 
-- ON user_addresses USING GIST (location_point);

-- ============================================
-- Additional Indexes for Performance
-- ============================================

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS "rides_status_requestedAt_idx" 
ON "rides" ("status", "requestedAt" DESC);

CREATE INDEX IF NOT EXISTS "orders_status_requestedAt_idx" 
ON "orders" ("status", "requestedAt" DESC);

CREATE INDEX IF NOT EXISTS "driver_locations_driverId_createdAt_idx" 
ON "driver_locations" ("driverId", "createdAt" DESC);

CREATE INDEX IF NOT EXISTS "payment_transactions_status_createdAt_idx" 
ON "payment_transactions" ("status", "createdAt" DESC);

-- ============================================
-- Full-Text Search Indexes (Optional)
-- ============================================
-- Note: Requires pg_trgm extension for Vietnamese text search

-- CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Product search
-- CREATE INDEX IF NOT EXISTS product_name_search_idx 
-- ON products USING GIN (name gin_trgm_ops);

-- CREATE INDEX IF NOT EXISTS product_description_search_idx 
-- ON products USING GIN (description gin_trgm_ops);

-- Merchant search
-- CREATE INDEX IF NOT EXISTS merchant_name_search_idx 
-- ON merchants USING GIN (name gin_trgm_ops);

-- User search
-- CREATE INDEX IF NOT EXISTS user_name_search_idx 
-- ON users USING GIN (name gin_trgm_ops);

