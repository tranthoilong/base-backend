-- CreateTable
CREATE TABLE "tags" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "scope" TEXT NOT NULL,
    "organizationId" UUID,
    "color" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "usageCount" INTEGER NOT NULL DEFAULT 0,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tag_assignments" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "tagId" UUID NOT NULL,
    "resourceType" TEXT NOT NULL,
    "resourceId" UUID NOT NULL,
    "organizationId" UUID,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tag_assignments_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "tags_scope_idx" ON "tags"("scope");

-- CreateIndex
CREATE INDEX "tags_organizationId_idx" ON "tags"("organizationId");

-- CreateIndex
CREATE INDEX "tags_slug_idx" ON "tags"("slug");

-- CreateIndex
CREATE INDEX "tags_name_idx" ON "tags"("name");

-- CreateIndex
CREATE INDEX "tags_isActive_idx" ON "tags"("isActive");

-- CreateIndex
CREATE INDEX "tags_deletedAt_idx" ON "tags"("deletedAt");

-- CreateIndex
CREATE INDEX "tags_scope_organizationId_isActive_idx" ON "tags"("scope", "organizationId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "tags_scope_organizationId_slug_key" ON "tags"("scope", "organizationId", "slug");

-- CreateIndex
CREATE INDEX "tag_assignments_tagId_idx" ON "tag_assignments"("tagId");

-- CreateIndex
CREATE INDEX "tag_assignments_resourceType_idx" ON "tag_assignments"("resourceType");

-- CreateIndex
CREATE INDEX "tag_assignments_resourceId_idx" ON "tag_assignments"("resourceId");

-- CreateIndex
CREATE INDEX "tag_assignments_organizationId_idx" ON "tag_assignments"("organizationId");

-- CreateIndex
CREATE INDEX "tag_assignments_resourceType_resourceId_idx" ON "tag_assignments"("resourceType", "resourceId");

-- CreateIndex
CREATE INDEX "tag_assignments_tagId_resourceType_idx" ON "tag_assignments"("tagId", "resourceType");

-- CreateIndex
CREATE INDEX "tag_assignments_createdAt_idx" ON "tag_assignments"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "tag_assignments_tagId_resourceType_resourceId_key" ON "tag_assignments"("tagId", "resourceType", "resourceId");

-- AddForeignKey
ALTER TABLE "tags" ADD CONSTRAINT "tags_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tag_assignments" ADD CONSTRAINT "tag_assignments_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "tags"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tag_assignments" ADD CONSTRAINT "tag_assignments_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organizations"("id") ON DELETE CASCADE ON UPDATE CASCADE;
