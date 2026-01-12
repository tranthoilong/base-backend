import { Expose, Type } from 'class-transformer';
import { PromotionType } from '@prisma/client';

export class PromotionDto {
  @Expose()
  id: string;

  @Expose()
  code: string;

  @Expose()
  title: string;

  @Expose()
  description: string;

  @Expose()
  type: PromotionType;

  @Expose()
  value: number;

  @Expose()
  maxDiscount?: number;

  @Expose()
  minRideAmount: number;

  @Expose()
  maxUsage?: number;

  @Expose()
  maxUsagePerUser: number;

  @Expose()
  currentUsage: number;

  @Expose()
  startDate: Date;

  @Expose()
  endDate: Date;

  @Expose()
  isActive: boolean;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional)
  @Expose()
  @Type(() => PromotionUsageDto)
  usages?: PromotionUsageDto[];
}

export class PromotionUsageDto {
  @Expose()
  id: string;

  @Expose()
  promotionId: string;

  @Expose()
  userId: string;

  @Expose()
  rideId: string;

  @Expose()
  discount: number;

  @Expose()
  createdAt: Date;

  // Relations (optional)
  @Expose()
  @Type(() => PromotionDto)
  promotion?: PromotionDto;

  @Expose()
  user?: any; // UserDto

  @Expose()
  ride?: any; // RideDto
}
