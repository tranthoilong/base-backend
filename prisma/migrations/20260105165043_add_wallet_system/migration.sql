-- CreateEnum
CREATE TYPE "WalletRole" AS ENUM ('AVAILABLE', 'PENDING', 'DEPOSIT');

-- CreateEnum
CREATE TYPE "WalletLedgerStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "WalletLedgerType" AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER_IN', 'TRANSFER_OUT', 'PAYMENT', 'REFUND', 'ADJUSTMENT', 'EARNING', 'FEE');

-- CreateEnum
CREATE TYPE "WalletReferenceType" AS ENUM ('RIDE', 'ORDER', 'PAYMENT_TRANSACTION', 'WITHDRAWAL_REQUEST', 'DEPOSIT_REQUEST', 'ADMIN_ADJUSTMENT');

-- CreateTable
CREATE TABLE "wallets" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "userId" UUID,
    "driverId" UUID,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "lockedReason" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "wallets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "wallet_ledgers" (
    "id" UUID NOT NULL DEFAULT uuid_v7(),
    "walletId" UUID NOT NULL,
    "walletRole" "WalletRole" NOT NULL,
    "type" "WalletLedgerType" NOT NULL,
    "status" "WalletLedgerStatus" NOT NULL DEFAULT 'PENDING',
    "amount" DECIMAL(12,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'VND',
    "referenceType" "WalletReferenceType",
    "referenceId" UUID,
    "description" TEXT,
    "transactionNumber" TEXT,
    "provider" TEXT,
    "providerId" TEXT,
    "providerResponse" JSONB,
    "processedAt" TIMESTAMP(3),
    "processedBy" UUID,
    "failureReason" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "wallet_ledgers_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "wallets_userId_key" ON "wallets"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "wallets_driverId_key" ON "wallets"("driverId");

-- CreateIndex
CREATE INDEX "wallets_userId_idx" ON "wallets"("userId");

-- CreateIndex
CREATE INDEX "wallets_driverId_idx" ON "wallets"("driverId");

-- CreateIndex
CREATE INDEX "wallets_isActive_idx" ON "wallets"("isActive");

-- CreateIndex
CREATE INDEX "wallets_isLocked_idx" ON "wallets"("isLocked");

-- CreateIndex
CREATE UNIQUE INDEX "wallet_ledgers_transactionNumber_key" ON "wallet_ledgers"("transactionNumber");

-- CreateIndex
CREATE INDEX "wallet_ledgers_walletId_idx" ON "wallet_ledgers"("walletId");

-- CreateIndex
CREATE INDEX "wallet_ledgers_walletRole_idx" ON "wallet_ledgers"("walletRole");

-- CreateIndex
CREATE INDEX "wallet_ledgers_type_idx" ON "wallet_ledgers"("type");

-- CreateIndex
CREATE INDEX "wallet_ledgers_status_idx" ON "wallet_ledgers"("status");

-- CreateIndex
CREATE INDEX "wallet_ledgers_referenceType_idx" ON "wallet_ledgers"("referenceType");

-- CreateIndex
CREATE INDEX "wallet_ledgers_referenceId_idx" ON "wallet_ledgers"("referenceId");

-- CreateIndex
CREATE INDEX "wallet_ledgers_transactionNumber_idx" ON "wallet_ledgers"("transactionNumber");

-- CreateIndex
CREATE INDEX "wallet_ledgers_createdAt_idx" ON "wallet_ledgers"("createdAt");

-- CreateIndex
CREATE INDEX "wallet_ledgers_walletId_walletRole_status_idx" ON "wallet_ledgers"("walletId", "walletRole", "status");

-- CreateIndex
CREATE INDEX "wallet_ledgers_walletId_createdAt_idx" ON "wallet_ledgers"("walletId", "createdAt");

-- AddForeignKey
ALTER TABLE "wallets" ADD CONSTRAINT "wallets_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallets" ADD CONSTRAINT "wallets_driverId_fkey" FOREIGN KEY ("driverId") REFERENCES "drivers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_ledgers" ADD CONSTRAINT "wallet_ledgers_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "wallets"("id") ON DELETE CASCADE ON UPDATE CASCADE;
