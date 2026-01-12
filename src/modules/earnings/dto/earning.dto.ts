import { Expose } from 'class-transformer';

export class EarningDto {
  @Expose()
  id: string;

  @Expose()
  driverId: string;

  @Expose()
  totalEarnings: number;

  @Expose()
  commission: number;

  @Expose()
  netEarnings: number;

  @Expose()
  date: Date;

  @Expose()
  weekNumber: number;

  @Expose()
  month: number;

  @Expose()
  year: number;

  @Expose()
  totalTrips: number;

  @Expose()
  totalDistance: number;

  @Expose()
  totalHours: number;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional)
  @Expose()
  driver?: any; // DriverDto
}
