-- CreateEnum
CREATE TYPE "DocumentOwnerType" AS ENUM ('USER', 'DRIVER');

-- CreateEnum
CREATE TYPE "DocumentStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- CreateTable
CREATE TABLE "document_fields" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "ownerType" "DocumentOwnerType" NOT NULL,
    "isRequired" BOOLEAN NOT NULL DEFAULT true,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "displayOrder" INTEGER NOT NULL DEFAULT 0,
    "allowedMimeTypes" JSONB,
    "maxFileSize" INTEGER,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "document_fields_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documents" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "fieldId" UUID NOT NULL,
    "userId" UUID,
    "driverId" UUID,
    "mediaId" UUID,
    "fileUrl" TEXT NOT NULL,
    "fileName" TEXT,
    "fileSize" INTEGER,
    "mimeType" TEXT,
    "status" "DocumentStatus" NOT NULL DEFAULT 'PENDING',
    "verifiedBy" UUID,
    "verifiedAt" TIMESTAMP(3),
    "rejectionReason" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "document_fields_key_key" ON "document_fields"("key");

-- CreateIndex
CREATE INDEX "document_fields_ownerType_idx" ON "document_fields"("ownerType");

-- CreateIndex
CREATE INDEX "document_fields_isActive_idx" ON "document_fields"("isActive");

-- CreateIndex
CREATE INDEX "document_fields_isRequired_idx" ON "document_fields"("isRequired");

-- CreateIndex
CREATE INDEX "document_fields_displayOrder_idx" ON "document_fields"("displayOrder");

-- CreateIndex
CREATE INDEX "document_fields_deletedAt_idx" ON "document_fields"("deletedAt");

-- CreateIndex
CREATE INDEX "documents_fieldId_idx" ON "documents"("fieldId");

-- CreateIndex
CREATE INDEX "documents_userId_idx" ON "documents"("userId");

-- CreateIndex
CREATE INDEX "documents_driverId_idx" ON "documents"("driverId");

-- CreateIndex
CREATE INDEX "documents_status_idx" ON "documents"("status");

-- CreateIndex
CREATE INDEX "documents_verifiedBy_idx" ON "documents"("verifiedBy");

-- CreateIndex
CREATE INDEX "documents_createdAt_idx" ON "documents"("createdAt");

-- CreateIndex
CREATE INDEX "documents_deletedAt_idx" ON "documents"("deletedAt");

-- CreateIndex
CREATE INDEX "documents_userId_fieldId_idx" ON "documents"("userId", "fieldId");

-- CreateIndex
CREATE INDEX "documents_driverId_fieldId_idx" ON "documents"("driverId", "fieldId");

-- CreateIndex
-- Unique constraint: một field chỉ có thể có một document cho mỗi owner (userId hoặc driverId)
-- Sử dụng partial unique index vì một document chỉ có userId HOẶC driverId
CREATE UNIQUE INDEX "documents_fieldId_userId_unique" ON "documents"("fieldId", "userId") WHERE "userId" IS NOT NULL AND "deletedAt" IS NULL;
CREATE UNIQUE INDEX "documents_fieldId_driverId_unique" ON "documents"("fieldId", "driverId") WHERE "driverId" IS NOT NULL AND "deletedAt" IS NULL;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_fieldId_fkey" FOREIGN KEY ("fieldId") REFERENCES "document_fields"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "drivers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documents" ADD CONSTRAINT "documents_mediaId_fkey" FOREIGN KEY ("mediaId") REFERENCES "media"("id") ON DELETE SET NULL ON UPDATE CASCADE;
