import { Expose, Transform } from 'class-transformer';

export class UserFavoriteLocationDto {
  @Expose()
  id: string;

  @Expose()
  userId: string;

  @Expose()
  name: string;

  @Expose()
  address: string;

  @Expose()
  city?: string;

  @Expose()
  province?: string;

  @Expose()
  district?: string;

  @Expose()
  ward?: string;

  @Expose()
  @Transform(({ value }) => {
    if (value === null || value === undefined) return value;
    return typeof value === 'object' && value !== null && 'toNumber' in value
      ? value.toNumber()
      : Number(value);
  })
  latitude: number;

  @Expose()
  @Transform(({ value }) => {
    if (value === null || value === undefined) return value;
    return typeof value === 'object' && value !== null && 'toNumber' in value
      ? value.toNumber()
      : Number(value);
  })
  longitude: number;

  @Expose()
  locationType?: string;

  @Expose()
  displayOrder: number;

  @Expose()
  isActive: boolean;

  @Expose()
  metadata?: any;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  @Expose()
  deletedAt?: Date;
}
