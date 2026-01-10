-- Migration: Add unique index for rate_limits (already applied, kept for history)
-- This migration was created to add unique constraint on rate_limits table

-- CreateIndex (with IF NOT EXISTS check)
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

