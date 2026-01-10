import { Injectable } from '@nestjs/common';
import { User } from '@prisma/client/index-browser';
import { BaseService } from 'common/base/base.service';
import { PrismaService } from 'common/database';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';

@Injectable()
export class UsersService extends BaseService<any> {
  constructor(private readonly prisma: PrismaService) {
    super();
  }

  async findAll(pagination: BaseQueryDto) : Promise<ApiResponse<User[]>> {
    const where: any = {
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
        roles: { include: { role: true } },
        favoriteLocations: true,
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

    if (pagination.all) {
      return {
        success: true,
        data: data,
        message: 'Users retrieved successfully',
        error: null,
        pagination: null,
        timestamp: new Date().toISOString(),
      };
    }

    return {
      success: true,
      data: data,
      message: 'Users retrieved successfully',
      error: null,
      pagination: null,
      timestamp: new Date().toISOString(),
    };
  }
}
