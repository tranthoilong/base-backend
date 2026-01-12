import { Expose, Type } from 'class-transformer';
import type { UserRole, UserStatus } from '@prisma/client';
import { DriverDto } from '../../drivers/dto/driver.dto';
import { WalletDto } from '../../wallets/dto/wallet.dto';
import { RideDto } from '../../rides/dto/ride.dto';
import { RatingDto } from '../../ratings/dto/rating.dto';
import { NotificationDto } from '../../notifications/dto/notification.dto';
import { PromotionUsageDto } from '../../promotions/dto/promotion.dto';
import { UserRoleDto } from '../../../../common/dto/rbac.dto';

export class UserDto {
  @Expose()
  id: string;

  @Expose()
  email: string;

  @Expose()
  name: string;

  @Expose()
  phone: string;

  @Expose()
  avatar?: string;

  @Expose()
  role: UserRole;

  @Expose()
  status: UserStatus;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional - chỉ load khi cần)
  @Expose()
  @Type(() => DriverDto)
  driver?: DriverDto;

  @Expose()
  @Type(() => WalletDto)
  wallet?: WalletDto;

  @Expose()
  @Type(() => RideDto)
  ridesAsCustomer?: RideDto[];

  @Expose()
  @Type(() => RatingDto)
  ratingsGiven?: RatingDto[];

  @Expose()
  @Type(() => RatingDto)
  ratingsReceived?: RatingDto[];

  @Expose()
  @Type(() => NotificationDto)
  notifications?: NotificationDto[];

  @Expose()
  @Type(() => PromotionUsageDto)
  promotionUsages?: PromotionUsageDto[];

  @Expose()
  @Type(() => UserRoleDto)
  userRoles?: UserRoleDto[];
}
