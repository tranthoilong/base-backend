import { Injectable } from '@nestjs/common';
import { User } from '@prisma/client/index-browser';
import { BaseService } from 'common/base/base.service';
import { PrismaService } from 'common/database';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { UserDto } from './dto/user.dto';
import { Prisma } from '@prisma/client/index-browser';
import { plainToInstance } from 'class-transformer';
import { RoleDto } from './dto/role.dto';
import { UserFavoriteLocationDto } from './dto/user-favorite-location.dto';
import { UserRoleDto } from './dto/user-roles.dto';

@Injectable()
export class UsersService extends BaseService<any> {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async findAll(pagination: BaseQueryDto) : Promise<ApiResponse<UserDto[]>> {
    const where: Prisma.UserWhereInput = {
      deletedAt: null,
    };

    if (pagination.hasSearch()) {
      where.OR = [
        { email: { contains: pagination.search, mode: 'insensitive' } },
        { name: { contains: pagination.search, mode: 'insensitive' } },
        { phone: { contains: pagination.search, mode: 'insensitive' } },
      ];
    }

    if (pagination.hasDateRange()) {
      const dateRange = pagination.getDateRange();
      where.createdAt = {};
      if (dateRange.startDate) {
        where.createdAt.gte = dateRange.startDate;
      }
      if (dateRange.endDate) {
        where.createdAt.lte = dateRange.endDate;
      }
    }

    const queryOptions: any = {
      where,
      include: {
        roles: {
          include: {
            role: true,
            user: true,
          },
        },
        favoriteLocations: {
          where: {
            deletedAt: null,
          },
        },
      },
      orderBy: pagination.getOrderBy(),
    };

    if (!pagination.all) {
      const skip = pagination.getSkip();
      const take = pagination.getTake();
      if (skip !== undefined) queryOptions.skip = skip;
      if (take !== undefined) queryOptions.take = take;
    }

    const [data, total] = await Promise.all([
      (this.prisma as any).user.findMany(queryOptions),
      (this.prisma as any).user.count({ where }),
    ]);

    // Transform roles từ [{ role: {...} }] thành [{...}] và convert thành RoleDto
    // Transform userRoles thành UserRoleDto[]
    // Transform favoriteLocations thành UserFavoriteLocationDto[]
    const transformedRolesData = data.map((user: any) => {
      // Transform roles và userRoles từ cùng một dữ liệu
      let roles: RoleDto[] = [];
      let userRoles: UserRoleDto[] = [];
      
      if (user.roles && Array.isArray(user.roles) && user.roles.length > 0) {
        // Transform userRoles (toàn bộ UserRole objects với role relation)
        userRoles = plainToInstance(UserRoleDto, user.roles, {
          excludeExtraneousValues: true,
          enableImplicitConversion: true,
        }) as unknown as UserRoleDto[];

        // Transform roles (chỉ lấy Role objects)
        roles = user.roles
          .map((userRole: any) => {
            // Lấy role từ userRole.role
            const role = userRole?.role;
            // Kiểm tra role tồn tại và có dữ liệu
            if (role && typeof role === 'object' && role.id) {
              try {
                const transformedRole = plainToInstance(RoleDto, role, {
                  excludeExtraneousValues: true,
                  enableImplicitConversion: true,
                });
                return transformedRole;
              } catch (error) {
                console.error('Error transforming role:', error, role);
                return null;
              }
            }
            // Debug: log nếu role không tồn tại
            if (!role) {
              console.warn('UserRole without role:', userRole);
            }
            return null;
          })
          .filter((role: RoleDto | null): role is RoleDto => role !== null);
      }

      // Transform favoriteLocations
      let favoriteLocations: UserFavoriteLocationDto[] = [];
      if (user.favoriteLocations && Array.isArray(user.favoriteLocations) && user.favoriteLocations.length > 0) {
        favoriteLocations = plainToInstance(UserFavoriteLocationDto, user.favoriteLocations, {
          excludeExtraneousValues: true,
          enableImplicitConversion: true,
        }) as unknown as UserFavoriteLocationDto[];
      }

      return {
        ...user,
        roles,
        userRoles,
        favoriteLocations,
      };
    });

    const transformedData = plainToInstance(UserDto, transformedRolesData, {
      excludeExtraneousValues: true,
      enableImplicitConversion: true,
    }) as unknown as UserDto[];

    if (pagination.all) {
      return {
        success: true,
        data: transformedData,
        message: 'Users retrieved successfully',
        error: null,
        pagination: null,
        timestamp: new Date().toISOString(),
      };
    }

    return {
      success: true,
      data: transformedData as unknown as UserDto[],
      message: 'Users retrieved successfully',
      error: null,
      pagination: null,
      timestamp: new Date().toISOString(),
    };
  }
}
