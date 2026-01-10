import { Expose } from 'class-transformer';
export class RoleDto {
  @Expose()
  id: string;

  @Expose()
  name: string;

  @Expose()
  description?: string;

  @Expose()
  isSystem: boolean;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;
}
