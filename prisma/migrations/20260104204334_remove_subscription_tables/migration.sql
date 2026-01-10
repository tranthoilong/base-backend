-- Migration: Remove Subscription Tables
-- This migration removes all subscription-related tables (if they exist)

-- Drop foreign key constraints first (only if tables exist)
DO $$ 
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'user_subscriptions') THEN
    ALTER TABLE "user_subscriptions" DROP CONSTRAINT IF EXISTS "user_subscriptions_userId_fkey";
    ALTER TABLE "user_subscriptions" DROP CONSTRAINT IF EXISTS "user_subscriptions_planId_fkey";
  END IF;
END $$;

-- Drop indexes (safe to run even if tables don't exist)
DROP INDEX IF EXISTS "user_subscriptions_userId_idx";
DROP INDEX IF EXISTS "user_subscriptions_planId_idx";
DROP INDEX IF EXISTS "user_subscriptions_status_idx";
DROP INDEX IF EXISTS "user_subscriptions_startDate_idx";
DROP INDEX IF EXISTS "user_subscriptions_endDate_idx";
DROP INDEX IF EXISTS "user_subscriptions_createdAt_idx";
DROP INDEX IF EXISTS "subscription_plans_type_idx";
DROP INDEX IF EXISTS "subscription_plans_isActive_idx";
DROP INDEX IF EXISTS "subscription_plans_isPublic_idx";

-- Drop unique constraints
DROP INDEX IF EXISTS "user_subscriptions_userId_planId_status_key";

-- Drop tables (safe - uses IF EXISTS)
DROP TABLE IF EXISTS "user_subscriptions" CASCADE;
DROP TABLE IF EXISTS "subscription_plans" CASCADE;

-- Drop enum if it exists and is not used elsewhere
DROP TYPE IF EXISTS "SubscriptionStatus";

