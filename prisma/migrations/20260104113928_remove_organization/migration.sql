/*
  Warnings:

  - You are about to drop the column `organizationId` on the `banners` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `blacklists` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `media` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `media_folders` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `notification_delivery_logs` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `notification_preferences` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `notification_threads` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `notifications` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `post_categories` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `posts` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `rate_limits` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `sidebar_configs` table. All the data in the column will be lost.
  - You are about to drop the column `maxOrganizations` on the `subscription_plans` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `tag_assignments` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `tags` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `webhook_endpoints` table. All the data in the column will be lost.
  - You are about to drop the `organization_invitations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `organization_ownership_transfers` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `organization_role_permissions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `organization_roles` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `organization_settings` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `organizations` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user_organization_roles` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[userId,parentId,slug]` on the table `media_folders` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId]` on the table `notification_preferences` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[scope,slug]` on the table `post_categories` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId,endpoint]` on the table `rate_limits` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[roleType,roleName]` on the table `sidebar_configs` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[scope,slug]` on the table `tags` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "banners" DROP CONSTRAINT "banners_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "blacklists" DROP CONSTRAINT "blacklists_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "media" DROP CONSTRAINT "media_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "media_folders" DROP CONSTRAINT "media_folders_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "organization_invitations" DROP CONSTRAINT "organization_invitations_invitedBy_fkey";

-- DropForeignKey
ALTER TABLE "organization_invitations" DROP CONSTRAINT "organization_invitations_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "organization_invitations" DROP CONSTRAINT "organization_invitations_roleId_fkey";

-- DropForeignKey
ALTER TABLE "organization_ownership_transfers" DROP CONSTRAINT "organization_ownership_transfers_fromUserId_fkey";

-- DropForeignKey
ALTER TABLE "organization_ownership_transfers" DROP CONSTRAINT "organization_ownership_transfers_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "organization_ownership_transfers" DROP CONSTRAINT "organization_ownership_transfers_toUserId_fkey";

-- DropForeignKey
ALTER TABLE "organization_role_permissions" DROP CONSTRAINT "organization_role_permissions_permissionId_fkey";

-- DropForeignKey
ALTER TABLE "organization_role_permissions" DROP CONSTRAINT "organization_role_permissions_roleId_fkey";

-- DropForeignKey
ALTER TABLE "organization_roles" DROP CONSTRAINT "organization_roles_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "organization_settings" DROP CONSTRAINT "organization_settings_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "organizations" DROP CONSTRAINT "organizations_ownerId_fkey";

-- DropForeignKey
ALTER TABLE "post_categories" DROP CONSTRAINT "post_categories_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "posts" DROP CONSTRAINT "posts_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "sidebar_configs" DROP CONSTRAINT "sidebar_configs_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "tag_assignments" DROP CONSTRAINT "tag_assignments_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "tags" DROP CONSTRAINT "tags_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "user_organization_roles" DROP CONSTRAINT "user_organization_roles_globalRoleId_fkey";

-- DropForeignKey
ALTER TABLE "user_organization_roles" DROP CONSTRAINT "user_organization_roles_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "user_organization_roles" DROP CONSTRAINT "user_organization_roles_roleId_fkey";

-- DropForeignKey
ALTER TABLE "user_organization_roles" DROP CONSTRAINT "user_organization_roles_userId_fkey";

-- DropForeignKey
ALTER TABLE "webhook_endpoints" DROP CONSTRAINT "webhook_endpoints_organizationId_fkey";

-- DropIndex
DROP INDEX "banners_organizationId_idx";

-- DropIndex
DROP INDEX "banners_scope_organizationId_idx";

-- DropIndex
DROP INDEX "blacklists_organizationId_idx";

-- DropIndex
DROP INDEX "media_organizationId_idx";

-- DropIndex
DROP INDEX "media_folders_organizationId_idx";

-- DropIndex
DROP INDEX "media_folders_userId_organizationId_parentId_slug_key";

-- DropIndex
DROP INDEX "notification_delivery_logs_organizationId_idx";

-- DropIndex
DROP INDEX "notification_preferences_organizationId_idx";

-- DropIndex
DROP INDEX "notification_preferences_userId_organizationId_key";

-- DropIndex
DROP INDEX "notification_threads_organizationId_idx";

-- DropIndex
DROP INDEX "notifications_organizationId_idx";

-- DropIndex
DROP INDEX "post_categories_organizationId_idx";

-- DropIndex
DROP INDEX "post_categories_scope_organizationId_slug_key";

-- DropIndex
DROP INDEX "posts_organizationId_idx";

-- DropIndex
DROP INDEX "posts_scope_organizationId_status_idx";

-- DropIndex
DROP INDEX "rate_limits_organizationId_endpoint_key";

-- DropIndex
DROP INDEX "rate_limits_organizationId_idx";

-- DropIndex
DROP INDEX "sidebar_configs_organizationId_idx";

-- DropIndex
DROP INDEX "sidebar_configs_roleType_roleName_organizationId_key";

-- DropIndex
DROP INDEX "tag_assignments_organizationId_idx";

-- DropIndex
DROP INDEX "tags_organizationId_idx";

-- DropIndex
DROP INDEX "tags_scope_organizationId_isActive_idx";

-- DropIndex
DROP INDEX "tags_scope_organizationId_slug_key";

-- DropIndex
DROP INDEX "webhook_endpoints_organizationId_idx";

-- AlterTable
ALTER TABLE "banners" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "blacklists" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "media" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "media_folders" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "notification_delivery_logs" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "notification_preferences" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "notification_threads" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "notifications" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "post_categories" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "posts" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "rate_limits" DROP COLUMN "organizationId",
ADD COLUMN     "userId" UUID;

-- AlterTable
ALTER TABLE "sidebar_configs" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "subscription_plans" DROP COLUMN "maxOrganizations";

-- AlterTable
ALTER TABLE "tag_assignments" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "tags" DROP COLUMN "organizationId";

-- AlterTable
ALTER TABLE "webhook_endpoints" DROP COLUMN "organizationId",
ADD COLUMN     "userId" UUID;

-- DropTable
DROP TABLE "organization_invitations";

-- DropTable
DROP TABLE "organization_ownership_transfers";

-- DropTable
DROP TABLE "organization_role_permissions";

-- DropTable
DROP TABLE "organization_roles";

-- DropTable
DROP TABLE "organization_settings";

-- DropTable
DROP TABLE "organizations";

-- DropTable
DROP TABLE "user_organization_roles";

-- DropEnum
DROP TYPE "InvitationStatus";

-- DropEnum
DROP TYPE "OwnershipTransferStatus";

-- CreateIndex
CREATE UNIQUE INDEX "media_folders_userId_parentId_slug_key" ON "media_folders"("userId", "parentId", "slug");

-- CreateIndex
CREATE UNIQUE INDEX "notification_preferences_userId_key" ON "notification_preferences"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "post_categories_scope_slug_key" ON "post_categories"("scope", "slug");

-- CreateIndex
CREATE INDEX "posts_scope_status_idx" ON "posts"("scope", "status");

-- CreateIndex
CREATE INDEX "rate_limits_userId_idx" ON "rate_limits"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "rate_limits_userId_endpoint_key" ON "rate_limits"("userId", "endpoint");

-- CreateIndex
CREATE UNIQUE INDEX "sidebar_configs_roleType_roleName_key" ON "sidebar_configs"("roleType", "roleName");

-- CreateIndex
CREATE INDEX "tags_scope_isActive_idx" ON "tags"("scope", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "tags_scope_slug_key" ON "tags"("scope", "slug");

-- CreateIndex
CREATE INDEX "webhook_endpoints_userId_idx" ON "webhook_endpoints"("userId");

-- AddForeignKey
ALTER TABLE "webhook_endpoints" ADD CONSTRAINT "webhook_endpoints_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
