/*
  Warnings:

  - You are about to drop the `banner_items` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `banners` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `post_categories` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `posts` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tag_assignments` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tags` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[serviceType,vehicleType,isActive]` on the table `pricing_rules` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId,endpoint]` on the table `rate_limits` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "banner_items" DROP CONSTRAINT "banner_items_bannerId_fkey";

-- DropForeignKey
ALTER TABLE "posts" DROP CONSTRAINT "posts_authorId_fkey";

-- DropForeignKey
ALTER TABLE "posts" DROP CONSTRAINT "posts_categoryId_fkey";

-- DropForeignKey
ALTER TABLE "rate_limits" DROP CONSTRAINT "rate_limits_userId_fkey";

-- DropForeignKey
ALTER TABLE "tag_assignments" DROP CONSTRAINT "tag_assignments_tagId_fkey";

-- AlterTable
ALTER TABLE "pricing_rules" ALTER COLUMN "vehicleType" DROP NOT NULL;

-- AlterTable
ALTER TABLE "ratings" ALTER COLUMN "rideId" DROP NOT NULL;

-- DropTable
DROP TABLE "banner_items";

-- DropTable
DROP TABLE "banners";

-- DropTable
DROP TABLE "post_categories";

-- DropTable
DROP TABLE "posts";

-- DropTable
DROP TABLE "tag_assignments";

-- DropTable
DROP TABLE "tags";

-- DropEnum
DROP TYPE "PostStatus";

-- CreateIndex (with IF NOT EXISTS check and column existence check)
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
