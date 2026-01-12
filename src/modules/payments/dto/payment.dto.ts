import { Expose } from 'class-transformer';
import { PaymentMethod, PaymentStatus } from '@prisma/client';

export class PaymentDto {
  @Expose()
  id: string;

  @Expose()
  rideId: string;

  @Expose()
  amount: number;

  @Expose()
  method: PaymentMethod;

  @Expose()
  status: PaymentStatus;

  @Expose()
  transactionId?: string;

  @Expose()
  gatewayResponse?: any;

  @Expose()
  paidAt?: Date;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional)
  @Expose()
  ride?: any; // RideDto
}
