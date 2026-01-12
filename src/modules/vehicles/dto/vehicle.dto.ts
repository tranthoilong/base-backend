import { Expose, Type } from 'class-transformer';
import { VehicleType } from '@prisma/client';

export class VehicleDto {
  @Expose()
  id: string;

  @Expose()
  driverId: string;

  @Expose()
  type: VehicleType;

  @Expose()
  brand: string;

  @Expose()
  model: string;

  @Expose()
  year: number;

  @Expose()
  licensePlate: string;

  @Expose()
  color: string;

  @Expose()
  seats: number;

  @Expose()
  registrationPhoto?: string;

  @Expose()
  insurancePhoto?: string;

  @Expose()
  photos: string[];

  @Expose()
  isActive: boolean;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional)
  @Expose()
  driver?: any; // DriverDto

  @Expose()
  rides?: any[]; // RideDto[]
}
