import { Expose } from 'class-transformer';
import { RoleDto } from './role.dto';

export class UserRoleDto {
  @Expose()
  id: string;

  @Expose()
  userId: string;

  @Expose()
  roleId: string;

  @Expose()
  createdAt: Date;

  @Expose()
  role?: RoleDto;
}
