import { Expose, Type } from 'class-transformer';
import { RideStatus, VehicleType, PaymentMethod, PaymentStatus } from '@prisma/client';

export class RideDto {
  @Expose()
  id: string;

  @Expose()
  customerId: string;

  @Expose()
  driverId?: string;

  @Expose()
  vehicleId?: string;

  // Locations
  @Expose()
  pickupAddress: string;

  @Expose()
  pickupLat: number;

  @Expose()
  pickupLng: number;

  @Expose()
  dropoffAddress: string;

  @Expose()
  dropoffLat: number;

  @Expose()
  dropoffLng: number;

  // Ride details
  @Expose()
  status: RideStatus;

  @Expose()
  vehicleType: VehicleType;

  @Expose()
  distance: number;

  @Expose()
  duration?: number;

  // Pricing
  @Expose()
  baseFare: number;

  @Expose()
  distanceFare: number;

  @Expose()
  timeFare: number;

  @Expose()
  surgeFare: number;

  @Expose()
  discount: number;

  @Expose()
  totalFare: number;

  // Payment
  @Expose()
  paymentMethod: PaymentMethod;

  @Expose()
  paymentStatus: PaymentStatus;

  // Timestamps
  @Expose()
  requestedAt: Date;

  @Expose()
  acceptedAt?: Date;

  @Expose()
  arrivedAt?: Date;

  @Expose()
  startedAt?: Date;

  @Expose()
  completedAt?: Date;

  @Expose()
  cancelledAt?: Date;

  @Expose()
  cancelReason?: string;

  @Expose()
  notes?: string;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional)
  @Expose()
  customer?: any; // UserDto

  @Expose()
  driver?: any; // DriverDto

  @Expose()
  vehicle?: any; // VehicleDto

  @Expose()
  rating?: any; // RatingDto

  @Expose()
  payment?: any; // PaymentDto

  @Expose()
  promotionUsage?: any; // PromotionUsageDto
}
