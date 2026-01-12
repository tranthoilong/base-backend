import { Expose } from 'class-transformer';

export class NotificationDto {
  @Expose()
  id: string;

  @Expose()
  userId: string;

  @Expose()
  title: string;

  @Expose()
  message: string;

  @Expose()
  type: string;

  @Expose()
  data?: any;

  @Expose()
  isRead: boolean;

  @Expose()
  createdAt: Date;

  // Relations (optional)
  @Expose()
  user?: any; // UserDto
}
