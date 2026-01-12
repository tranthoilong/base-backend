import { Expose, Type } from 'class-transformer';
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';
import { RoleDto } from 'common/dto/rbac.dto';

export class CreatePermissionDto {
  @IsNotEmpty()
  @IsString()
  module: string;

  @IsNotEmpty()
  @IsString()
  action: string;

  @IsNotEmpty()
  @IsString()
  resource: string;

  @IsOptional()
  @IsString()
  description?: string;
}

export class UpdatePermissionDto {
  @IsOptional()
  @IsString()
  description?: string;
}

export class PermissionResponseDto {
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
  @Type(() => RoleDto)
  roles?: RoleDto[];
}
