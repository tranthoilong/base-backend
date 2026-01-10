-- AlterTable
ALTER TABLE "media" ADD COLUMN     "folderId" UUID;

-- CreateTable
CREATE TABLE "media_folders" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "description" TEXT,
    "path" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "parentId" UUID,
    "userId" UUID,
    "organizationId" UUID,
    "metadata" JSONB,
    "color" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "media_folders_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "media_folders_userId_idx" ON "media_folders"("userId");

-- CreateIndex
CREATE INDEX "media_folders_organizationId_idx" ON "media_folders"("organizationId");

-- CreateIndex
CREATE INDEX "media_folders_parentId_idx" ON "media_folders"("parentId");

-- CreateIndex
CREATE INDEX "media_folders_path_idx" ON "media_folders"("path");

-- CreateIndex
CREATE INDEX "media_folders_slug_idx" ON "media_folders"("slug");

-- CreateIndex
CREATE INDEX "media_folders_deletedAt_idx" ON "media_folders"("deletedAt");

-- CreateIndex
CREATE UNIQUE INDEX "media_folders_userId_organizationId_parentId_slug_key" ON "media_folders"("userId", "organizationId", "parentId", "slug");

-- CreateIndex
CREATE INDEX "media_folderId_idx" ON "media"("folderId");

-- AddForeignKey
ALTER TABLE "media_folders" ADD CONSTRAINT "media_folders_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "media_folders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media_folders" ADD CONSTRAINT "media_folders_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media_folders" ADD CONSTRAINT "media_folders_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "media" ADD CONSTRAINT "media_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES "media_folders"("id") ON DELETE SET NULL ON UPDATE CASCADE;
