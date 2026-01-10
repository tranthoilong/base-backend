-- Migration: Remove Organization Domain
-- This migration removes all organization-related tables and columns

-- Drop foreign key constraints first
ALTER TABLE "media" DROP CONSTRAINT IF EXISTS "media_organizationId_fkey";
ALTER TABLE "media_folders" DROP CONSTRAINT IF EXISTS "media_folders_organizationId_fkey";
ALTER TABLE "rate_limits" DROP CONSTRAINT IF EXISTS "rate_limits_organizationId_fkey";
ALTER TABLE "webhook_endpoints" DROP CONSTRAINT IF EXISTS "webhook_endpoints_organizationId_fkey";
ALTER TABLE "blacklists" DROP CONSTRAINT IF EXISTS "blacklists_organizationId_fkey";
ALTER TABLE "sidebar_configs" DROP CONSTRAINT IF EXISTS "sidebar_configs_organizationId_fkey";
ALTER TABLE "notifications" DROP CONSTRAINT IF EXISTS "notifications_organizationId_fkey";
ALTER TABLE "notification_preferences" DROP CONSTRAINT IF EXISTS "notification_preferences_organizationId_fkey";
ALTER TABLE "notification_threads" DROP CONSTRAINT IF EXISTS "notification_threads_organizationId_fkey";
ALTER TABLE "notification_delivery_logs" DROP CONSTRAINT IF EXISTS "notification_delivery_logs_organizationId_fkey";
ALTER TABLE "post_categories" DROP CONSTRAINT IF EXISTS "post_categories_organizationId_fkey";
ALTER TABLE "posts" DROP CONSTRAINT IF EXISTS "posts_organizationId_fkey";
ALTER TABLE "tags" DROP CONSTRAINT IF EXISTS "tags_organizationId_fkey";
ALTER TABLE "tag_assignments" DROP CONSTRAINT IF EXISTS "tag_assignments_organizationId_fkey";
ALTER TABLE "banners" DROP CONSTRAINT IF EXISTS "banners_organizationId_fkey";

-- Drop indexes
DROP INDEX IF EXISTS "media_organizationId_idx";
DROP INDEX IF EXISTS "media_folders_organizationId_idx";
DROP INDEX IF EXISTS "rate_limits_organizationId_idx";
DROP INDEX IF EXISTS "webhook_endpoints_organizationId_idx";
DROP INDEX IF EXISTS "blacklists_organizationId_idx";
DROP INDEX IF EXISTS "sidebar_configs_organizationId_idx";
DROP INDEX IF EXISTS "notifications_organizationId_idx";
DROP INDEX IF EXISTS "notification_preferences_organizationId_idx";
DROP INDEX IF EXISTS "notification_threads_organizationId_idx";
DROP INDEX IF EXISTS "notification_delivery_logs_organizationId_idx";
DROP INDEX IF EXISTS "post_categories_organizationId_idx";
DROP INDEX IF EXISTS "posts_organizationId_idx";
DROP INDEX IF EXISTS "tags_organizationId_idx";
DROP INDEX IF EXISTS "tag_assignments_organizationId_idx";
DROP INDEX IF EXISTS "banners_organizationId_idx";

-- Drop unique constraints that include organizationId
DROP INDEX IF EXISTS "media_folders_unique_folder_slug";
DROP INDEX IF EXISTS "rate_limits_organizationId_endpoint_key";
DROP INDEX IF EXISTS "sidebar_configs_roleType_roleName_organizationId_key";
DROP INDEX IF EXISTS "notification_preferences_userId_organizationId_key";
DROP INDEX IF EXISTS "post_categories_scope_organizationId_slug_key";
DROP INDEX IF EXISTS "tags_scope_organizationId_slug_key";
DROP INDEX IF EXISTS "banners_scope_organizationId_key";

-- Drop columns
ALTER TABLE "media" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "media_folders" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "rate_limits" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "webhook_endpoints" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "blacklists" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "sidebar_configs" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "notifications" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "notification_preferences" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "notification_threads" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "notification_delivery_logs" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "post_categories" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "posts" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "tags" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "tag_assignments" DROP COLUMN IF EXISTS "organizationId";
ALTER TABLE "banners" DROP COLUMN IF EXISTS "organizationId";

-- Update rate_limits: change organizationId to userId (optional)
-- First, add userId column
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'rate_limits' AND column_name = 'userId') THEN
    ALTER TABLE "rate_limits" ADD COLUMN "userId" UUID;
  END IF;
END $$;

-- Handle duplicate data: if multiple rows have same endpoint with different organizationId but same endpoint,
-- keep only the first one (by id) and aggregate the counts
DO $$
DECLARE
  dup_record RECORD;
  org_col_exists BOOLEAN;
BEGIN
  -- Check if organizationId column exists
  SELECT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'rate_limits' AND column_name = 'organizationId'
  ) INTO org_col_exists;
  
  -- Only process if column exists
  IF org_col_exists THEN
    -- For rows with same endpoint but different organizationId (now NULL), keep only one
    -- Aggregate counts from duplicates before deleting
    FOR dup_record IN 
      SELECT endpoint, COUNT(*) as cnt, (array_agg(id ORDER BY id))[1] as keep_id
      FROM rate_limits
      WHERE "organizationId" IS NOT NULL
      GROUP BY endpoint
      HAVING COUNT(*) > 1
    LOOP
      -- Update the kept record with aggregated values
      UPDATE rate_limits
      SET 
        "requestsInMinute" = (
          SELECT MAX("requestsInMinute") FROM rate_limits 
          WHERE endpoint = dup_record.endpoint AND "organizationId" IS NOT NULL
        ),
        "requestsInHour" = (
          SELECT MAX("requestsInHour") FROM rate_limits 
          WHERE endpoint = dup_record.endpoint AND "organizationId" IS NOT NULL
        ),
        "requestsInDay" = (
          SELECT MAX("requestsInDay") FROM rate_limits 
          WHERE endpoint = dup_record.endpoint AND "organizationId" IS NOT NULL
        )
      WHERE id = dup_record.keep_id;
      
      -- Delete duplicates
      DELETE FROM rate_limits
      WHERE endpoint = dup_record.endpoint 
        AND "organizationId" IS NOT NULL
        AND id != dup_record.keep_id;
    END LOOP;
  END IF;
END $$;

-- Now drop organizationId column
ALTER TABLE "rate_limits" DROP COLUMN IF EXISTS "organizationId";

-- Add foreign key constraint
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'rate_limits_userId_fkey') THEN
    ALTER TABLE "rate_limits" ADD CONSTRAINT "rate_limits_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;

-- Create indexes
CREATE INDEX IF NOT EXISTS "rate_limits_userId_idx" ON "rate_limits"("userId");
DROP INDEX IF EXISTS "rate_limits_organizationId_endpoint_key";
DROP INDEX IF EXISTS "rate_limits_userId_endpoint_key";
DROP INDEX IF EXISTS "rate_limits_endpoint_key";

-- Create unique constraints (after handling duplicates)
-- For user-specific rate limits
CREATE UNIQUE INDEX IF NOT EXISTS "rate_limits_userId_endpoint_key" 
  ON "rate_limits"("userId", "endpoint") 
  WHERE "userId" IS NOT NULL;

-- For global/system rate limits (userId is NULL)
CREATE UNIQUE INDEX IF NOT EXISTS "rate_limits_endpoint_key" 
  ON "rate_limits"("endpoint") 
  WHERE "userId" IS NULL;

-- Update webhook_endpoints: change organizationId to userId (optional)
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'webhook_endpoints' AND column_name = 'userId') THEN
    ALTER TABLE "webhook_endpoints" ADD COLUMN "userId" UUID;
  END IF;
END $$;

DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'webhook_endpoints_userId_fkey') THEN
    ALTER TABLE "webhook_endpoints" ADD CONSTRAINT "webhook_endpoints_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS "webhook_endpoints_userId_idx" ON "webhook_endpoints"("userId");

-- Recreate unique constraints without organizationId
CREATE UNIQUE INDEX IF NOT EXISTS "media_folders_unique_folder_slug" ON "media_folders"("userId", "parentId", "slug") WHERE "userId" IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS "media_folders_unique_folder_slug_anonymous" ON "media_folders"("parentId", "slug") WHERE "userId" IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS "sidebar_configs_roleType_roleName_key" ON "sidebar_configs"("roleType", "roleName");
CREATE UNIQUE INDEX IF NOT EXISTS "notification_preferences_userId_key" ON "notification_preferences"("userId");
CREATE UNIQUE INDEX IF NOT EXISTS "post_categories_scope_slug_key" ON "post_categories"("scope", "slug");
CREATE UNIQUE INDEX IF NOT EXISTS "tags_scope_slug_key" ON "tags"("scope", "slug");

-- Recreate indexes without organizationId
CREATE INDEX IF NOT EXISTS "post_categories_scope_idx" ON "post_categories"("scope");
CREATE INDEX IF NOT EXISTS "posts_scope_idx" ON "posts"("scope");
CREATE INDEX IF NOT EXISTS "tags_scope_idx" ON "tags"("scope");
CREATE INDEX IF NOT EXISTS "banners_scope_idx" ON "banners"("scope");

-- Drop organization-related tables (in reverse dependency order)
DROP TABLE IF EXISTS "user_organization_roles" CASCADE;
DROP TABLE IF EXISTS "organization_role_permissions" CASCADE;
DROP TABLE IF EXISTS "organization_roles" CASCADE;
DROP TABLE IF EXISTS "organization_invitations" CASCADE;
DROP TABLE IF EXISTS "organization_ownership_transfers" CASCADE;
DROP TABLE IF EXISTS "organization_settings" CASCADE;
DROP TABLE IF EXISTS "organizations" CASCADE;

-- Drop enums if they exist and are not used elsewhere
DROP TYPE IF EXISTS "OwnershipTransferStatus";
DROP TYPE IF EXISTS "InvitationStatus";

-- Update subscription_plans: remove maxOrganizations column
ALTER TABLE "subscription_plans" DROP COLUMN IF EXISTS "maxOrganizations";
