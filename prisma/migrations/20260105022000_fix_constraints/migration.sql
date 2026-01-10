-- Fix constraints that may have failed in previous migration
-- This migration handles cases where constraints already exist

-- Fix rate_limits unique constraint
DO $$ 
BEGIN
  -- Drop existing constraint if exists
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'rate_limits_userId_endpoint_key'
  ) THEN
    ALTER TABLE "rate_limits" DROP CONSTRAINT "rate_limits_userId_endpoint_key";
  END IF;
  
  -- Drop existing index if exists
  IF EXISTS (
    SELECT 1 FROM pg_indexes 
    WHERE indexname = 'rate_limits_userId_endpoint_key'
  ) THEN
    DROP INDEX IF EXISTS "rate_limits_userId_endpoint_key";
  END IF;
  
  -- Create new unique index if not exists
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes 
    WHERE indexname = 'rate_limits_userId_endpoint_key'
  ) THEN
    CREATE UNIQUE INDEX "rate_limits_userId_endpoint_key" 
    ON "rate_limits"("userId", "endpoint");
  END IF;
END $$;

-- Fix pricing_rules unique constraint
DO $$ 
BEGIN
  -- Drop existing constraint if exists
  IF EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'pricing_rules_serviceType_vehicleType_key'
  ) THEN
    ALTER TABLE "pricing_rules" DROP CONSTRAINT "pricing_rules_serviceType_vehicleType_key";
  END IF;
  
  -- Drop existing index if exists
  IF EXISTS (
    SELECT 1 FROM pg_indexes 
    WHERE indexname = 'pricing_rules_serviceType_vehicleType_key'
  ) THEN
    DROP INDEX IF EXISTS "pricing_rules_serviceType_vehicleType_key";
  END IF;
  
  -- Create new unique index if not exists
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes 
    WHERE indexname = 'pricing_rules_serviceType_vehicleType_key'
  ) THEN
    CREATE UNIQUE INDEX "pricing_rules_serviceType_vehicleType_key" 
    ON "pricing_rules"("serviceType", "vehicleType");
  END IF;
END $$;

