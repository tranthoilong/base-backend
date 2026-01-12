import { Expose, Type } from 'class-transformer';
import { TransactionType } from '@prisma/client';

export class WalletDto {
  @Expose()
  id: string;

  @Expose()
  userId: string;

  @Expose()
  balance: number;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional)
  @Expose()
  user?: any; // UserDto

  @Expose()
  @Type(() => TransactionDto)
  transactions?: TransactionDto[];
}

export class TransactionDto {
  @Expose()
  id: string;

  @Expose()
  walletId: string;

  @Expose()
  type: TransactionType;

  @Expose()
  amount: number;

  @Expose()
  balanceBefore: number;

  @Expose()
  balanceAfter: number;

  @Expose()
  description: string;

  @Expose()
  referenceId?: string;

  @Expose()
  createdAt: Date;

  // Relations (optional)
  @Expose()
  @Type(() => WalletDto)
  wallet?: WalletDto;
}
