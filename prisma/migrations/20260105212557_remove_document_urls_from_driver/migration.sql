-- Remove document URL fields from drivers table
-- These fields are now stored in the documents table

-- AlterTable
ALTER TABLE "drivers" DROP COLUMN IF EXISTS "licenseFrontUrl";
ALTER TABLE "drivers" DROP COLUMN IF EXISTS "licenseBackUrl";
ALTER TABLE "drivers" DROP COLUMN IF EXISTS "idCardFrontUrl";
ALTER TABLE "drivers" DROP COLUMN IF EXISTS "idCardBackUrl";

