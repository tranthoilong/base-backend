import { Expose, Type } from 'class-transformer';

// ============= ROLE DTO =============
export class RoleDto {
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
  @Type(() => RolePermissionDto)
  permissions?: RolePermissionDto[];

  @Expose()
  @Type(() => UserRoleDto)
  users?: UserRoleDto[];
}

// ============= PERMISSION DTO =============
export class PermissionDto {
  @Expose()
  id: string;

  @Expose()
  module: string;

  @Expose()
  action: string;

  @Expose()
  resource: string;

  @Expose()
  description?: string;

  @Expose()
  code: string;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  @Expose()
  @Type(() => RolePermissionDto)
  roles?: RolePermissionDto[];
}

// ============= ROLE PERMISSION DTO =============
export class RolePermissionDto {
  @Expose()
  id: string;

  @Expose()
  roleId: string;

  @Expose()
  permissionId: string;

  @Expose()
  createdAt: Date;

  @Expose()
  @Type(() => RoleDto)
  role?: RoleDto;

  @Expose()
  @Type(() => PermissionDto)
  permission?: PermissionDto;
}

// ============= USER ROLE DTO =============
export class UserRoleDto {
  @Expose()
  id: string;

  @Expose()
  userId: string;

  @Expose()
  roleId: string;

  @Expose()
  assignedAt: Date;

  @Expose()
  assignedBy?: string;

  @Expose()
  expiresAt?: Date;

  @Expose()
  @Type(() => RoleDto)
  role?: RoleDto;
}
