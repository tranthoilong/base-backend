import { Expose, Type } from 'class-transformer';
import { IsNotEmpty, IsString, IsOptional, IsBoolean, IsArray } from 'class-validator';
import { PermissionDto } from 'common/dto/rbac.dto';

export class CreateRoleDto {
  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNotEmpty()
  @IsString()
  displayName: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsBoolean()
  isSystem?: boolean;
}

export class UpdateRoleDto {
  @IsOptional()
  @IsString()
  displayName?: string;

  @IsOptional()
  @IsString()
  description?: string;
}

export class AssignPermissionsDto {
  @IsNotEmpty()
  @IsArray()
  @IsString({ each: true })
  permissionIds: string[];
}

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
