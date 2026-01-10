-- Migration: Add missing indexes that were in migration 20260104141156
-- This migration ensures indexes are created safely with proper checks

-- CreateIndex for pricing_rules (with column existence check)
DO $$ 
BEGIN
  -- Check if serviceType column exists and index doesn't exist
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'pricing_rules' AND column_name = 'serviceType'
  ) AND NOT EXISTS (
    SELECT 1 FROM pg_indexes 
    WHERE indexname = 'pricing_rules_serviceType_vehicleType_isActive_key'
  ) THEN
    CREATE UNIQUE INDEX "pricing_rules_serviceType_vehicleType_isActive_key" 
      ON "pricing_rules"("serviceType", "vehicleType", "isActive");
  END IF;
END $$;

-- CreateIndex for rate_limits (already handled in previous migration, but ensure it exists)
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes 
    WHERE indexname = 'rate_limits_userId_endpoint_key'
  ) THEN
    CREATE UNIQUE INDEX "rate_limits_userId_endpoint_key" 
      ON "rate_limits"("userId", "endpoint");
  END IF;
END $$;

