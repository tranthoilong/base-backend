/*
  Warnings:

  - Changed the type of `type` on the `subscription_plans` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "subscription_plans" DROP COLUMN "type",
ADD COLUMN     "type" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "subscription_plans_type_key" ON "subscription_plans"("type");

-- CreateIndex
CREATE INDEX "subscription_plans_type_idx" ON "subscription_plans"("type");
