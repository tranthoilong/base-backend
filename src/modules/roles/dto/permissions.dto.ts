import { IsNotEmpty, IsArray, IsString, IsOptional } from 'class-validator';

export class AssignPermissionsDto {
  @IsNotEmpty()
  @IsArray()
  @IsString({ each: true })
  permissionIds: string[];
}

export class UpdatePermissionsDto {
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  add?: string[];

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  remove?: string[];
}
