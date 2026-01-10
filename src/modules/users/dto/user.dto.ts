import { Expose, Transform } from 'class-transformer';
import { RoleDto } from './role.dto';
import { UserFavoriteLocationDto } from './user-favorite-location.dto';
import { UserRoleDto } from './user-roles.dto';

export class UserDto {
  @Expose()
  id: string;

  @Expose()
  email: string;

  @Expose()
  name: string;

  @Expose()
  phone?: string;

  @Expose()
  avatar?: string;

  @Expose()
  bio?: string;

  @Expose()
  isActive: boolean;

  @Expose()
  isVerified: boolean;

  @Expose()
  emailVerifiedAt?: Date;

  @Expose()
  lastLoginAt?: Date;

  @Expose()
  lastLoginIp?: string;

  @Expose()
  passwordChangedAt?: Date;

  @Expose()
  twoFactorEnabled: boolean;

  @Expose()
  metadata?: any;

  @Expose()
  createdAt: Date;

  @Expose()
  updatedAt: Date;

  @Expose()
  deletedAt?: Date;

//   @Expose()
//   roles?: RoleDto[];

  @Expose()
  roles?: UserRoleDto[];

  @Expose()
  favoriteLocations?: UserFavoriteLocationDto[];
}