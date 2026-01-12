import { Expose, Type } from 'class-transformer';
import { DriverStatus } from '@prisma/client';

export class DriverDto {
  @Expose()
  id: string;

  @Expose()
  userId: string;

  @Expose()
  licenseNumber: string;

  @Expose()
  licenseExpiry: Date;

  @Expose()
  status: DriverStatus;

  @Expose()
  rating: number;

  @Expose()
  totalTrips: number;

  @Expose()
  currentLat?: number;

  @Expose()
  currentLng?: number;

  @Expose()
  licensePhoto?: string;

  @Expose()
  identityCardPhoto?: string;

  @Expose()
  isVerified: boolean;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional - load khi cần)
  @Expose()
  user?: any; // UserDto - avoid circular dependency

  @Expose()
  @Type(() => VehicleDto)
  vehicles?: VehicleDto[];

  @Expose()
  rides?: any[]; // RideDto[]

  @Expose()
  earnings?: any[]; // EarningDto[]
}

// Import after to avoid circular dependency
import { VehicleDto } from '../../vehicles/dto/vehicle.dto';
