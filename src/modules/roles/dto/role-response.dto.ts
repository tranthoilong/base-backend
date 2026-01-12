import { Expose, Type } from 'class-transformer';
import { PermissionDto } from 'common/dto/rbac.dto';

export class RoleResponseDto {
  @Expose()
  id: string;

  @Expose()
  name: string;

  @Expose()
  displayName: string;

  @Expose()
  description?: string;

  @Expose()
  isSystem: boolean;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  @Expose()
  @Type(() => PermissionDto)
  permissions?: PermissionDto[];
}
