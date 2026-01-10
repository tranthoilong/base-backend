-- CreateEnum
CREATE TYPE "OwnershipTransferStatus" AS ENUM ('PENDING', 'ACCEPTED', 'CANCELED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "InvitationStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "SubscriptionPlanType" AS ENUM ('FREE', 'BASIC', 'PREMIUM', 'VIP');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('ACTIVE', 'EXPIRED', 'CANCELED', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "WebhookDeliveryStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'SUCCESS', 'FAILED', 'DISCARDED');

-- CreateEnum
CREATE TYPE "BlacklistType" AS ENUM ('USER', 'ORGANIZATION', 'EMAIL', 'IP', 'PHONE');

-- CreateEnum
CREATE TYPE "BlacklistStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'EXPIRED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('INFO', 'SUCCESS', 'WARNING', 'ERROR', 'SYSTEM');

-- CreateEnum
CREATE TYPE "NotificationStatus" AS ENUM ('UNREAD', 'READ', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "DeliveryChannel" AS ENUM ('WEBSOCKET', 'EMAIL', 'PUSH', 'SMS');

-- CreateEnum
CREATE TYPE "DeliveryStatus" AS ENUM ('PENDING', 'SENT', 'DELIVERED', 'READ', 'FAILED', 'BOUNCED', 'UNSUBSCRIBED');

-- CreateEnum
CREATE TYPE "SessionStatus" AS ENUM ('ACTIVE', 'EXPIRED', 'REVOKED', 'LOGGED_OUT');

-- CreateEnum
CREATE TYPE "SensitiveActionType" AS ENUM ('EMAIL_CHANGE', 'PASSWORD_CHANGE', 'ACCOUNT_DELETE', 'DEVICE_ADD');

-- CreateTable
CREATE TABLE "organizations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "description" TEXT,
    "ownerId" UUID NOT NULL,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "website" TEXT,
    "logo" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "organizations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_ownership_transfers" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "organizationId" UUID NOT NULL,
    "fromUserId" UUID NOT NULL,
    "toUserId" UUID NOT NULL,
    "status" "OwnershipTransferStatus" NOT NULL DEFAULT 'PENDING',
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),
    "acceptedAt" TIMESTAMP(3),
    "canceledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_ownership_transfers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_invitations" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "organizationId" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "roleId" UUID NOT NULL,
    "invitedBy" UUID NOT NULL,
    "status" "InvitationStatus" NOT NULL DEFAULT 'PENDING',
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "acceptedAt" TIMESTAMP(3),
    "rejectedAt" TIMESTAMP(3),
    "canceledAt" TIMESTAMP(3),
    "message" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_invitations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "avatar" TEXT,
    "phone" TEXT,
    "bio" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "emailVerifiedAt" TIMESTAMP(3),
    "emailVerificationToken" TEXT,
    "emailVerificationExpires" TIMESTAMP(3),
    "lastLoginAt" TIMESTAMP(3),
    "lastLoginIp" TEXT,
    "passwordChangedAt" TIMESTAMP(3),
    "twoFactorEnabled" BOOLEAN NOT NULL DEFAULT false,
    "twoFactorSecret" TEXT,
    "passwordResetToken" TEXT,
    "passwordResetExpires" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_providers" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "provider" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "email" TEXT,
    "name" TEXT,
    "avatar" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_providers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "resource" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "roleId" UUID NOT NULL,
    "permissionId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "roleId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_roles" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "organizationId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "organization_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_role_permissions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "roleId" UUID NOT NULL,
    "permissionId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "organization_role_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_organization_roles" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "roleId" UUID NOT NULL,
    "globalRoleId" UUID,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isPrimary" BOOLEAN NOT NULL DEFAULT false,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leftAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_organization_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID,
    "userEmail" TEXT,
    "userName" TEXT,
    "action" TEXT NOT NULL,
    "resource" TEXT NOT NULL,
    "resourceId" UUID,
    "method" TEXT,
    "endpoint" TEXT,
    "statusCode" INTEGER,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "oldData" JSONB,
    "newData" JSONB,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_history" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "hash" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "password_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "settings" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "key" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "description" TEXT,
    "category" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_settings" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "organizationId" UUID NOT NULL,
    "key" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "description" TEXT,
    "category" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_settings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "media" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "filename" TEXT NOT NULL,
    "originalName" TEXT NOT NULL,
    "name" TEXT,
    "mimeType" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "path" TEXT NOT NULL,
    "url" TEXT,
    "width" INTEGER,
    "height" INTEGER,
    "duration" DOUBLE PRECISION,
    "userId" UUID,
    "organizationId" UUID,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "media_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "seepay_webhook_logs" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "eventType" TEXT NOT NULL,
    "eventId" TEXT,
    "status" TEXT NOT NULL,
    "method" TEXT,
    "endpoint" TEXT,
    "headers" JSONB,
    "body" JSONB,
    "signature" TEXT,
    "responseStatus" INTEGER,
    "responseBody" JSONB,
    "processedAt" TIMESTAMP(3),
    "errorMessage" TEXT,
    "retryCount" INTEGER NOT NULL DEFAULT 0,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "seepay_webhook_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription_plans" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "type" "SubscriptionPlanType" NOT NULL,
    "description" TEXT,
    "price" INTEGER NOT NULL DEFAULT 0,
    "currency" TEXT NOT NULL DEFAULT 'VND',
    "billingPeriod" TEXT NOT NULL DEFAULT 'monthly',
    "maxOrganizations" INTEGER NOT NULL DEFAULT 0,
    "maxMembers" INTEGER NOT NULL DEFAULT 10,
    "maxStorage" BIGINT,
    "maxMediaSize" INTEGER NOT NULL DEFAULT 5242880,
    "features" JSONB,
    "rateLimitPerMinute" INTEGER NOT NULL DEFAULT 60,
    "rateLimitPerHour" INTEGER NOT NULL DEFAULT 1000,
    "rateLimitPerDay" INTEGER NOT NULL DEFAULT 10000,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isPublic" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "subscription_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_subscriptions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "planId" UUID NOT NULL,
    "status" "SubscriptionStatus" NOT NULL DEFAULT 'ACTIVE',
    "startDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endDate" TIMESTAMP(3),
    "paymentMethod" TEXT,
    "paymentId" TEXT,
    "amount" INTEGER,
    "autoRenew" BOOLEAN NOT NULL DEFAULT false,
    "renewalDate" TIMESTAMP(3),
    "canceledAt" TIMESTAMP(3),
    "cancelReason" TEXT,
    "organizationsCreated" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "user_subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rate_limits" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "organizationId" UUID NOT NULL,
    "endpoint" TEXT NOT NULL,
    "requestsInMinute" INTEGER NOT NULL DEFAULT 0,
    "requestsInHour" INTEGER NOT NULL DEFAULT 0,
    "requestsInDay" INTEGER NOT NULL DEFAULT 0,
    "minuteResetAt" TIMESTAMP(3) NOT NULL,
    "hourResetAt" TIMESTAMP(3) NOT NULL,
    "dayResetAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rate_limits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "webhook_endpoints" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "organizationId" UUID NOT NULL,
    "url" TEXT NOT NULL,
    "description" TEXT,
    "secret" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "webhook_endpoints_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "webhook_event_subscriptions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "endpointId" UUID NOT NULL,
    "eventType" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "webhook_event_subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "webhook_deliveries" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "endpointId" UUID NOT NULL,
    "eventType" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "signature" TEXT,
    "attempt" INTEGER NOT NULL DEFAULT 0,
    "maxAttempts" INTEGER NOT NULL DEFAULT 5,
    "status" "WebhookDeliveryStatus" NOT NULL DEFAULT 'PENDING',
    "nextAttemptAt" TIMESTAMP(3),
    "responseStatus" INTEGER,
    "responseBody" TEXT,
    "errorMessage" TEXT,
    "durationMs" INTEGER,
    "retryBackoffMs" INTEGER,
    "startedAt" TIMESTAMP(3),
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "webhook_deliveries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "blacklists" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "type" "BlacklistType" NOT NULL,
    "status" "BlacklistStatus" NOT NULL DEFAULT 'ACTIVE',
    "organizationId" UUID,
    "targetId" UUID,
    "value" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "description" TEXT,
    "createdBy" UUID,
    "createdByName" TEXT,
    "expiresAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "blacklists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sidebar_configs" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "roleType" TEXT NOT NULL,
    "roleName" TEXT,
    "organizationId" UUID,
    "sections" JSONB NOT NULL,
    "settings" JSONB,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sidebar_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "organizationId" UUID,
    "type" "NotificationType" NOT NULL DEFAULT 'INFO',
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "data" JSONB,
    "status" "NotificationStatus" NOT NULL DEFAULT 'UNREAD',
    "readAt" TIMESTAMP(3),
    "actionUrl" TEXT,
    "actionLabel" TEXT,
    "category" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "expiresAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_preferences" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "organizationId" UUID,
    "enableWebSocket" BOOLEAN NOT NULL DEFAULT true,
    "enableEmail" BOOLEAN NOT NULL DEFAULT true,
    "enablePush" BOOLEAN NOT NULL DEFAULT false,
    "categories" JSONB,
    "dndEnabled" BOOLEAN NOT NULL DEFAULT false,
    "dndStartTime" TEXT,
    "dndEndTime" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_preferences_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_templates" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "displayName" TEXT NOT NULL,
    "description" TEXT,
    "subject" TEXT,
    "emailBody" TEXT,
    "pushTitle" TEXT,
    "pushBody" TEXT,
    "webTitle" TEXT,
    "webBody" TEXT,
    "variables" JSONB,
    "category" TEXT,
    "type" "NotificationType" NOT NULL DEFAULT 'INFO',
    "priority" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdBy" UUID,

    CONSTRAINT "notification_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_threads" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "organizationId" UUID,
    "subject" TEXT NOT NULL,
    "category" TEXT,
    "lastNotificationAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notificationCount" INTEGER NOT NULL DEFAULT 0,
    "unreadCount" INTEGER NOT NULL DEFAULT 0,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "archivedAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_threads_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_delivery_logs" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "organizationId" UUID,
    "notificationId" UUID,
    "templateId" UUID,
    "threadId" UUID,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL DEFAULT 'INFO',
    "category" TEXT,
    "channel" "DeliveryChannel" NOT NULL,
    "status" "DeliveryStatus" NOT NULL DEFAULT 'PENDING',
    "recipient" TEXT NOT NULL,
    "sentAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),
    "readAt" TIMESTAMP(3),
    "failedAt" TIMESTAMP(3),
    "errorMessage" TEXT,
    "retryCount" INTEGER NOT NULL DEFAULT 0,
    "maxRetries" INTEGER NOT NULL DEFAULT 3,
    "nextRetryAt" TIMESTAMP(3),
    "provider" TEXT,
    "providerId" TEXT,
    "providerResponse" JSONB,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_delivery_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_device_tokens" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "platform" TEXT NOT NULL,
    "deviceId" TEXT,
    "deviceName" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "lastUsedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notification_device_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_devices" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "deviceId" TEXT NOT NULL,
    "deviceName" TEXT,
    "os" TEXT,
    "osVersion" TEXT,
    "browser" TEXT,
    "browserVersion" TEXT,
    "deviceType" TEXT,
    "ip" TEXT,
    "country" TEXT,
    "city" TEXT,
    "userAgent" TEXT,
    "firstSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastLoginAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isTrusted" BOOLEAN NOT NULL DEFAULT false,
    "isBlocked" BOOLEAN NOT NULL DEFAULT false,
    "failedLoginAttempts" INTEGER NOT NULL DEFAULT 0,
    "lastFailedLoginAt" TIMESTAMP(3),
    "blockedAt" TIMESTAMP(3),
    "blockedReason" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "deviceId" UUID NOT NULL,
    "token" TEXT NOT NULL,
    "refreshToken" TEXT,
    "status" "SessionStatus" NOT NULL DEFAULT 'ACTIVE',
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "country" TEXT,
    "city" TEXT,
    "lastActivityAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "activityCount" INTEGER NOT NULL DEFAULT 0,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "revokeReason" TEXT,
    "loggedOutAt" TIMESTAMP(3),
    "isRenewed" BOOLEAN NOT NULL DEFAULT false,
    "renewedFrom" UUID,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sensitive_action_verifications" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID NOT NULL,
    "action" "SensitiveActionType" NOT NULL,
    "token" TEXT NOT NULL,
    "code" TEXT,
    "payload" JSONB,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "usedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sensitive_action_verifications_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "organizations_code_key" ON "organizations"("code");

-- CreateIndex
CREATE INDEX "organizations_code_idx" ON "organizations"("code");

-- CreateIndex
CREATE INDEX "organizations_name_idx" ON "organizations"("name");

-- CreateIndex
CREATE INDEX "organizations_ownerId_idx" ON "organizations"("ownerId");

-- CreateIndex
CREATE INDEX "organizations_isActive_idx" ON "organizations"("isActive");

-- CreateIndex
CREATE INDEX "organizations_deletedAt_idx" ON "organizations"("deletedAt");

-- CreateIndex
CREATE INDEX "organizations_createdAt_idx" ON "organizations"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "organization_ownership_transfers_token_key" ON "organization_ownership_transfers"("token");

-- CreateIndex
CREATE INDEX "organization_ownership_transfers_organizationId_idx" ON "organization_ownership_transfers"("organizationId");

-- CreateIndex
CREATE INDEX "organization_ownership_transfers_fromUserId_idx" ON "organization_ownership_transfers"("fromUserId");

-- CreateIndex
CREATE INDEX "organization_ownership_transfers_toUserId_idx" ON "organization_ownership_transfers"("toUserId");

-- CreateIndex
CREATE INDEX "organization_ownership_transfers_status_idx" ON "organization_ownership_transfers"("status");

-- CreateIndex
CREATE UNIQUE INDEX "organization_invitations_token_key" ON "organization_invitations"("token");

-- CreateIndex
CREATE INDEX "organization_invitations_organizationId_idx" ON "organization_invitations"("organizationId");

-- CreateIndex
CREATE INDEX "organization_invitations_email_idx" ON "organization_invitations"("email");

-- CreateIndex
CREATE INDEX "organization_invitations_invitedBy_idx" ON "organization_invitations"("invitedBy");

-- CreateIndex
CREATE INDEX "organization_invitations_status_idx" ON "organization_invitations"("status");

-- CreateIndex
CREATE INDEX "organization_invitations_expiresAt_idx" ON "organization_invitations"("expiresAt");

-- CreateIndex
CREATE INDEX "organization_invitations_token_idx" ON "organization_invitations"("token");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_phone_idx" ON "users"("phone");

-- CreateIndex
CREATE INDEX "users_isActive_idx" ON "users"("isActive");

-- CreateIndex
CREATE INDEX "users_isVerified_idx" ON "users"("isVerified");

-- CreateIndex
CREATE INDEX "users_deletedAt_idx" ON "users"("deletedAt");

-- CreateIndex
CREATE INDEX "users_createdAt_idx" ON "users"("createdAt");

-- CreateIndex
CREATE INDEX "user_providers_userId_idx" ON "user_providers"("userId");

-- CreateIndex
CREATE INDEX "user_providers_provider_idx" ON "user_providers"("provider");

-- CreateIndex
CREATE UNIQUE INDEX "user_providers_provider_providerId_key" ON "user_providers"("provider", "providerId");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE INDEX "roles_name_idx" ON "roles"("name");

-- CreateIndex
CREATE INDEX "permissions_resource_idx" ON "permissions"("resource");

-- CreateIndex
CREATE UNIQUE INDEX "permissions_resource_action_key" ON "permissions"("resource", "action");

-- CreateIndex
CREATE INDEX "role_permissions_roleId_idx" ON "role_permissions"("roleId");

-- CreateIndex
CREATE INDEX "role_permissions_permissionId_idx" ON "role_permissions"("permissionId");

-- CreateIndex
CREATE UNIQUE INDEX "role_permissions_roleId_permissionId_key" ON "role_permissions"("roleId", "permissionId");

-- CreateIndex
CREATE INDEX "user_roles_userId_idx" ON "user_roles"("userId");

-- CreateIndex
CREATE INDEX "user_roles_roleId_idx" ON "user_roles"("roleId");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_userId_roleId_key" ON "user_roles"("userId", "roleId");

-- CreateIndex
CREATE INDEX "organization_roles_organizationId_idx" ON "organization_roles"("organizationId");

-- CreateIndex
CREATE INDEX "organization_roles_name_idx" ON "organization_roles"("name");

-- CreateIndex
CREATE INDEX "organization_roles_isActive_idx" ON "organization_roles"("isActive");

-- CreateIndex
CREATE INDEX "organization_roles_deletedAt_idx" ON "organization_roles"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "organization_roles_organizationId_name_key" ON "organization_roles"("organizationId", "name");

-- CreateIndex
CREATE INDEX "organization_role_permissions_roleId_idx" ON "organization_role_permissions"("roleId");

-- CreateIndex
CREATE INDEX "organization_role_permissions_permissionId_idx" ON "organization_role_permissions"("permissionId");

-- CreateIndex
CREATE UNIQUE INDEX "organization_role_permissions_roleId_permissionId_key" ON "organization_role_permissions"("roleId", "permissionId");

-- CreateIndex
CREATE INDEX "user_organization_roles_userId_idx" ON "user_organization_roles"("userId");

-- CreateIndex
CREATE INDEX "user_organization_roles_organizationId_idx" ON "user_organization_roles"("organizationId");

-- CreateIndex
CREATE INDEX "user_organization_roles_roleId_idx" ON "user_organization_roles"("roleId");

-- CreateIndex
CREATE INDEX "user_organization_roles_globalRoleId_idx" ON "user_organization_roles"("globalRoleId");

-- CreateIndex
CREATE INDEX "user_organization_roles_isActive_idx" ON "user_organization_roles"("isActive");

-- CreateIndex
CREATE INDEX "user_organization_roles_isPrimary_idx" ON "user_organization_roles"("isPrimary");

-- CreateIndex
CREATE INDEX "user_organization_roles_userId_organizationId_idx" ON "user_organization_roles"("userId", "organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "user_organization_roles_userId_organizationId_roleId_key" ON "user_organization_roles"("userId", "organizationId", "roleId");

-- CreateIndex
CREATE INDEX "audit_logs_userId_idx" ON "audit_logs"("userId");

-- CreateIndex
CREATE INDEX "audit_logs_action_idx" ON "audit_logs"("action");

-- CreateIndex
CREATE INDEX "audit_logs_resource_idx" ON "audit_logs"("resource");

-- CreateIndex
CREATE INDEX "audit_logs_resourceId_idx" ON "audit_logs"("resourceId");

-- CreateIndex
CREATE INDEX "audit_logs_createdAt_idx" ON "audit_logs"("createdAt");

-- CreateIndex
CREATE INDEX "password_history_userId_idx" ON "password_history"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "settings_key_key" ON "settings"("key");

-- CreateIndex
CREATE INDEX "settings_key_idx" ON "settings"("key");

-- CreateIndex
CREATE INDEX "settings_category_idx" ON "settings"("category");

-- CreateIndex
CREATE INDEX "settings_isActive_idx" ON "settings"("isActive");

-- CreateIndex
CREATE INDEX "organization_settings_organizationId_idx" ON "organization_settings"("organizationId");

-- CreateIndex
CREATE INDEX "organization_settings_key_idx" ON "organization_settings"("key");

-- CreateIndex
CREATE INDEX "organization_settings_category_idx" ON "organization_settings"("category");

-- CreateIndex
CREATE INDEX "organization_settings_isActive_idx" ON "organization_settings"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "organization_settings_organizationId_key_key" ON "organization_settings"("organizationId", "key");

-- CreateIndex
CREATE INDEX "media_userId_idx" ON "media"("userId");

-- CreateIndex
CREATE INDEX "media_organizationId_idx" ON "media"("organizationId");

-- CreateIndex
CREATE INDEX "media_mimeType_idx" ON "media"("mimeType");

-- CreateIndex
CREATE INDEX "media_createdAt_idx" ON "media"("createdAt");

-- CreateIndex
CREATE INDEX "media_deletedAt_idx" ON "media"("deletedAt");

-- CreateIndex
CREATE INDEX "seepay_webhook_logs_eventType_idx" ON "seepay_webhook_logs"("eventType");

-- CreateIndex
CREATE INDEX "seepay_webhook_logs_status_idx" ON "seepay_webhook_logs"("status");

-- CreateIndex
CREATE INDEX "seepay_webhook_logs_eventId_idx" ON "seepay_webhook_logs"("eventId");

-- CreateIndex
CREATE INDEX "seepay_webhook_logs_createdAt_idx" ON "seepay_webhook_logs"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_plans_name_key" ON "subscription_plans"("name");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_plans_type_key" ON "subscription_plans"("type");

-- CreateIndex
CREATE INDEX "subscription_plans_type_idx" ON "subscription_plans"("type");

-- CreateIndex
CREATE INDEX "subscription_plans_isActive_idx" ON "subscription_plans"("isActive");

-- CreateIndex
CREATE INDEX "subscription_plans_isPublic_idx" ON "subscription_plans"("isPublic");

-- CreateIndex
CREATE INDEX "user_subscriptions_userId_idx" ON "user_subscriptions"("userId");

-- CreateIndex
CREATE INDEX "user_subscriptions_planId_idx" ON "user_subscriptions"("planId");

-- CreateIndex
CREATE INDEX "user_subscriptions_status_idx" ON "user_subscriptions"("status");

-- CreateIndex
CREATE INDEX "user_subscriptions_startDate_idx" ON "user_subscriptions"("startDate");

-- CreateIndex
CREATE INDEX "user_subscriptions_endDate_idx" ON "user_subscriptions"("endDate");

-- CreateIndex
CREATE INDEX "user_subscriptions_createdAt_idx" ON "user_subscriptions"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "user_subscriptions_userId_planId_status_key" ON "user_subscriptions"("userId", "planId", "status");

-- CreateIndex
CREATE INDEX "rate_limits_organizationId_idx" ON "rate_limits"("organizationId");

-- CreateIndex
CREATE INDEX "rate_limits_minuteResetAt_idx" ON "rate_limits"("minuteResetAt");

-- CreateIndex
CREATE INDEX "rate_limits_hourResetAt_idx" ON "rate_limits"("hourResetAt");

-- CreateIndex
CREATE INDEX "rate_limits_dayResetAt_idx" ON "rate_limits"("dayResetAt");

-- CreateIndex
CREATE UNIQUE INDEX "rate_limits_organizationId_endpoint_key" ON "rate_limits"("organizationId", "endpoint");

-- CreateIndex
CREATE INDEX "webhook_endpoints_organizationId_idx" ON "webhook_endpoints"("organizationId");

-- CreateIndex
CREATE INDEX "webhook_endpoints_isActive_idx" ON "webhook_endpoints"("isActive");

-- CreateIndex
CREATE INDEX "webhook_event_subscriptions_eventType_idx" ON "webhook_event_subscriptions"("eventType");

-- CreateIndex
CREATE UNIQUE INDEX "webhook_event_subscriptions_endpointId_eventType_key" ON "webhook_event_subscriptions"("endpointId", "eventType");

-- CreateIndex
CREATE INDEX "webhook_deliveries_status_nextAttemptAt_idx" ON "webhook_deliveries"("status", "nextAttemptAt");

-- CreateIndex
CREATE INDEX "webhook_deliveries_eventType_idx" ON "webhook_deliveries"("eventType");

-- CreateIndex
CREATE INDEX "blacklists_type_idx" ON "blacklists"("type");

-- CreateIndex
CREATE INDEX "blacklists_status_idx" ON "blacklists"("status");

-- CreateIndex
CREATE INDEX "blacklists_organizationId_idx" ON "blacklists"("organizationId");

-- CreateIndex
CREATE INDEX "blacklists_targetId_idx" ON "blacklists"("targetId");

-- CreateIndex
CREATE INDEX "blacklists_value_idx" ON "blacklists"("value");

-- CreateIndex
CREATE INDEX "blacklists_createdBy_idx" ON "blacklists"("createdBy");

-- CreateIndex
CREATE INDEX "blacklists_expiresAt_idx" ON "blacklists"("expiresAt");

-- CreateIndex
CREATE INDEX "blacklists_createdAt_idx" ON "blacklists"("createdAt");

-- CreateIndex
CREATE INDEX "blacklists_deletedAt_idx" ON "blacklists"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "sidebar_configs_name_key" ON "sidebar_configs"("name");

-- CreateIndex
CREATE INDEX "sidebar_configs_roleType_idx" ON "sidebar_configs"("roleType");

-- CreateIndex
CREATE INDEX "sidebar_configs_roleName_idx" ON "sidebar_configs"("roleName");

-- CreateIndex
CREATE INDEX "sidebar_configs_organizationId_idx" ON "sidebar_configs"("organizationId");

-- CreateIndex
CREATE INDEX "sidebar_configs_isActive_idx" ON "sidebar_configs"("isActive");

-- CreateIndex
CREATE INDEX "sidebar_configs_priority_idx" ON "sidebar_configs"("priority");

-- CreateIndex
CREATE UNIQUE INDEX "sidebar_configs_roleType_roleName_organizationId_key" ON "sidebar_configs"("roleType", "roleName", "organizationId");

-- CreateIndex
CREATE INDEX "notifications_userId_idx" ON "notifications"("userId");

-- CreateIndex
CREATE INDEX "notifications_organizationId_idx" ON "notifications"("organizationId");

-- CreateIndex
CREATE INDEX "notifications_status_idx" ON "notifications"("status");

-- CreateIndex
CREATE INDEX "notifications_type_idx" ON "notifications"("type");

-- CreateIndex
CREATE INDEX "notifications_category_idx" ON "notifications"("category");

-- CreateIndex
CREATE INDEX "notifications_createdAt_idx" ON "notifications"("createdAt");

-- CreateIndex
CREATE INDEX "notifications_readAt_idx" ON "notifications"("readAt");

-- CreateIndex
CREATE INDEX "notifications_expiresAt_idx" ON "notifications"("expiresAt");

-- CreateIndex
CREATE INDEX "notifications_deletedAt_idx" ON "notifications"("deletedAt");

-- CreateIndex
CREATE INDEX "notifications_userId_status_createdAt_idx" ON "notifications"("userId", "status", "createdAt");

-- CreateIndex
CREATE INDEX "notification_preferences_userId_idx" ON "notification_preferences"("userId");

-- CreateIndex
CREATE INDEX "notification_preferences_organizationId_idx" ON "notification_preferences"("organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "notification_preferences_userId_organizationId_key" ON "notification_preferences"("userId", "organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "notification_templates_name_key" ON "notification_templates"("name");

-- CreateIndex
CREATE INDEX "notification_templates_name_idx" ON "notification_templates"("name");

-- CreateIndex
CREATE INDEX "notification_templates_category_idx" ON "notification_templates"("category");

-- CreateIndex
CREATE INDEX "notification_templates_isActive_idx" ON "notification_templates"("isActive");

-- CreateIndex
CREATE INDEX "notification_threads_userId_idx" ON "notification_threads"("userId");

-- CreateIndex
CREATE INDEX "notification_threads_organizationId_idx" ON "notification_threads"("organizationId");

-- CreateIndex
CREATE INDEX "notification_threads_category_idx" ON "notification_threads"("category");

-- CreateIndex
CREATE INDEX "notification_threads_isArchived_idx" ON "notification_threads"("isArchived");

-- CreateIndex
CREATE INDEX "notification_threads_userId_isArchived_lastNotificationAt_idx" ON "notification_threads"("userId", "isArchived", "lastNotificationAt");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_userId_idx" ON "notification_delivery_logs"("userId");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_organizationId_idx" ON "notification_delivery_logs"("organizationId");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_notificationId_idx" ON "notification_delivery_logs"("notificationId");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_templateId_idx" ON "notification_delivery_logs"("templateId");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_threadId_idx" ON "notification_delivery_logs"("threadId");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_channel_idx" ON "notification_delivery_logs"("channel");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_status_idx" ON "notification_delivery_logs"("status");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_category_idx" ON "notification_delivery_logs"("category");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_createdAt_idx" ON "notification_delivery_logs"("createdAt");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_sentAt_idx" ON "notification_delivery_logs"("sentAt");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_deliveredAt_idx" ON "notification_delivery_logs"("deliveredAt");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_readAt_idx" ON "notification_delivery_logs"("readAt");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_nextRetryAt_idx" ON "notification_delivery_logs"("nextRetryAt");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_userId_channel_status_idx" ON "notification_delivery_logs"("userId", "channel", "status");

-- CreateIndex
CREATE INDEX "notification_delivery_logs_status_nextRetryAt_idx" ON "notification_delivery_logs"("status", "nextRetryAt");

-- CreateIndex
CREATE UNIQUE INDEX "notification_device_tokens_token_key" ON "notification_device_tokens"("token");

-- CreateIndex
CREATE INDEX "notification_device_tokens_userId_idx" ON "notification_device_tokens"("userId");

-- CreateIndex
CREATE INDEX "notification_device_tokens_token_idx" ON "notification_device_tokens"("token");

-- CreateIndex
CREATE INDEX "notification_device_tokens_platform_idx" ON "notification_device_tokens"("platform");

-- CreateIndex
CREATE INDEX "notification_device_tokens_isActive_idx" ON "notification_device_tokens"("isActive");

-- CreateIndex
CREATE INDEX "notification_device_tokens_userId_isActive_idx" ON "notification_device_tokens"("userId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "user_devices_deviceId_key" ON "user_devices"("deviceId");

-- CreateIndex
CREATE INDEX "user_devices_userId_idx" ON "user_devices"("userId");

-- CreateIndex
CREATE INDEX "user_devices_deviceId_idx" ON "user_devices"("deviceId");

-- CreateIndex
CREATE INDEX "user_devices_isActive_idx" ON "user_devices"("isActive");

-- CreateIndex
CREATE INDEX "user_devices_isBlocked_idx" ON "user_devices"("isBlocked");

-- CreateIndex
CREATE INDEX "user_devices_lastSeenAt_idx" ON "user_devices"("lastSeenAt");

-- CreateIndex
CREATE INDEX "user_devices_userId_isActive_idx" ON "user_devices"("userId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_token_key" ON "user_sessions"("token");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_refreshToken_key" ON "user_sessions"("refreshToken");

-- CreateIndex
CREATE INDEX "user_sessions_userId_idx" ON "user_sessions"("userId");

-- CreateIndex
CREATE INDEX "user_sessions_deviceId_idx" ON "user_sessions"("deviceId");

-- CreateIndex
CREATE INDEX "user_sessions_token_idx" ON "user_sessions"("token");

-- CreateIndex
CREATE INDEX "user_sessions_refreshToken_idx" ON "user_sessions"("refreshToken");

-- CreateIndex
CREATE INDEX "user_sessions_status_idx" ON "user_sessions"("status");

-- CreateIndex
CREATE INDEX "user_sessions_expiresAt_idx" ON "user_sessions"("expiresAt");

-- CreateIndex
CREATE INDEX "user_sessions_lastActivityAt_idx" ON "user_sessions"("lastActivityAt");

-- CreateIndex
CREATE INDEX "user_sessions_userId_status_idx" ON "user_sessions"("userId", "status");

-- CreateIndex
CREATE INDEX "user_sessions_status_expiresAt_idx" ON "user_sessions"("status", "expiresAt");

-- CreateIndex
CREATE UNIQUE INDEX "sensitive_action_verifications_token_key" ON "sensitive_action_verifications"("token");

-- CreateIndex
CREATE INDEX "sensitive_action_verifications_userId_idx" ON "sensitive_action_verifications"("userId");

-- CreateIndex
CREATE INDEX "sensitive_action_verifications_action_idx" ON "sensitive_action_verifications"("action");

-- CreateIndex
CREATE INDEX "sensitive_action_verifications_expiresAt_idx" ON "sensitive_action_verifications"("expiresAt");

-- AddForeignKey
ALTER TABLE "organizations" ADD CONSTRAINT "organizations_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_ownership_transfers" ADD CONSTRAINT "organization_ownership_transfers_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_ownership_transfers" ADD CONSTRAINT "organization_ownership_transfers_fromUserId_fkey" FOREIGN KEY ("fromUserId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_ownership_transfers" ADD CONSTRAINT "organization_ownership_transfers_toUserId_fkey" FOREIGN KEY ("toUserId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_invitations" ADD CONSTRAINT "organization_invitations_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_invitations" ADD CONSTRAINT "organization_invitations_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "organization_roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_invitations" ADD CONSTRAINT "organization_invitations_invitedBy_fkey" FOREIGN KEY ("invitedBy") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_providers" ADD CONSTRAINT "user_providers_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_roles" ADD CONSTRAINT "organization_roles_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_role_permissions" ADD CONSTRAINT "organization_role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "organization_roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_role_permissions" ADD CONSTRAINT "organization_role_permissions_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_organization_roles" ADD CONSTRAINT "user_organization_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_organization_roles" ADD CONSTRAINT "user_organization_roles_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_organization_roles" ADD CONSTRAINT "user_organization_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "organization_roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_organization_roles" ADD CONSTRAINT "user_organization_roles_globalRoleId_fkey" FOREIGN KEY ("globalRoleId") REFERENCES "roles"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_history" ADD CONSTRAINT "password_history_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization_settings" ADD CONSTRAINT "organization_settings_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media" ADD CONSTRAINT "media_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media" ADD CONSTRAINT "media_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_subscriptions" ADD CONSTRAINT "user_subscriptions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_subscriptions" ADD CONSTRAINT "user_subscriptions_planId_fkey" FOREIGN KEY ("planId") REFERENCES "subscription_plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "webhook_endpoints" ADD CONSTRAINT "webhook_endpoints_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "webhook_event_subscriptions" ADD CONSTRAINT "webhook_event_subscriptions_endpointId_fkey" FOREIGN KEY ("endpointId") REFERENCES "webhook_endpoints"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "webhook_deliveries" ADD CONSTRAINT "webhook_deliveries_endpointId_fkey" FOREIGN KEY ("endpointId") REFERENCES "webhook_endpoints"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blacklists" ADD CONSTRAINT "blacklists_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sidebar_configs" ADD CONSTRAINT "sidebar_configs_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_delivery_logs" ADD CONSTRAINT "notification_delivery_logs_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "notification_templates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_delivery_logs" ADD CONSTRAINT "notification_delivery_logs_threadId_fkey" FOREIGN KEY ("threadId") REFERENCES "notification_threads"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_deviceId_fkey" FOREIGN KEY ("deviceId") REFERENCES "user_devices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sensitive_action_verifications" ADD CONSTRAINT "sensitive_action_verifications_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
