import { IsEmail, IsNotEmpty, MinLength, IsOptional, IsString } from 'class-validator';
import type { UserRole } from '@prisma/client';

export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsNotEmpty()
  @MinLength(6)
  password: string;

  @IsNotEmpty()
  @IsString()
  name: string;

  @IsNotEmpty()
  @IsString()
  phone: string;

  @IsOptional()
  @IsString()
  avatar?: string;

  @IsOptional()
  role?: UserRole;
}
