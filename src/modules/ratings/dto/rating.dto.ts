import { Expose } from 'class-transformer';

export class RatingDto {
  @Expose()
  id: string;

  @Expose()
  rideId: string;

  @Expose()
  fromUserId: string;

  @Expose()
  toUserId: string;

  @Expose()
  rating: number;

  @Expose()
  comment?: string;

  @Expose()
  tags: string[];

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  // Relations (optional)
  @Expose()
  ride?: any; // RideDto

  @Expose()
  fromUser?: any; // UserDto

  @Expose()
  toUser?: any; // UserDto
}
