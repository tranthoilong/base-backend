import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'common/database/prisma.service';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { Permission } from '@prisma/client';
import { CreatePermissionDto, UpdatePermissionDto, PermissionResponseDto } from './dto';
import { plainToInstance } from 'class-transformer';

@Injectable()
export class PermissionsRepository {
  constructor(private readonly prisma: PrismaService) {}

  private generateCode(module: string, action: string, resource: string): string {
    return `${module}_${action}_${resource}`;
  }

  async findAll(query: BaseQueryDto): Promise<PermissionResponseDto[]> {
    const permissions = await this.prisma.permission.findMany({
      where: query.hasSearch()
        ? {
            OR: [
              { module: { contains: query.search, mode: 'insensitive' } },
              { action: { contains: query.search, mode: 'insensitive' } },
              { resource: { contains: query.search, mode: 'insensitive' } },
              { code: { contains: query.search, mode: 'insensitive' } },
              { description: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : undefined,
      orderBy: query.getOrderBy(),
      skip: query.getSkip(),
      take: query.getTake(),
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    // Transform roles từ RolePermission[] sang RoleDto[]
    const transformedPermissions = permissions.map((permission) => ({
      ...permission,
      roles: permission.roles.map((rp) => rp.role),
    }));

    return plainToInstance(PermissionResponseDto, transformedPermissions, {
      excludeExtraneousValues: true,
    });
  }

  async findById(id: string): Promise<PermissionResponseDto | null> {
    const permission = await this.prisma.permission.findUnique({
      where: { id },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    if (!permission) {
      return null;
    }

    // Transform roles từ RolePermission[] sang RoleDto[]
    const transformedPermission = {
      ...permission,
      roles: permission.roles.map((rp) => rp.role),
    };

    return plainToInstance(PermissionResponseDto, transformedPermission, {
      excludeExtraneousValues: true,
    });
  }

  async findByCode(code: string): Promise<Permission | null> {
    return this.prisma.permission.findUnique({
      where: { code },
    });
  }

  async findByModuleActionResource(
    module: string,
    action: string,
    resource: string,
  ): Promise<Permission | null> {
    return this.prisma.permission.findUnique({
      where: {
        module_action_resource: {
          module,
          action,
          resource,
        },
      },
    });
  }

  async create(
    createPermissionDto: CreatePermissionDto,
  ): Promise<PermissionResponseDto> {
    const code = this.generateCode(
      createPermissionDto.module,
      createPermissionDto.action,
      createPermissionDto.resource,
    );

    const permission = await this.prisma.permission.create({
      data: {
        module: createPermissionDto.module,
        action: createPermissionDto.action,
        resource: createPermissionDto.resource,
        code,
        description: createPermissionDto.description,
      },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    // Transform roles từ RolePermission[] sang RoleDto[]
    const transformedPermission = {
      ...permission,
      roles: permission.roles.map((rp) => rp.role),
    };

    return plainToInstance(PermissionResponseDto, transformedPermission, {
      excludeExtraneousValues: true,
    });
  }

  async update(
    id: string,
    updatePermissionDto: UpdatePermissionDto,
  ): Promise<PermissionResponseDto> {
    const permission = await this.prisma.permission.update({
      where: { id },
      data: updatePermissionDto,
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    // Transform roles từ RolePermission[] sang RoleDto[]
    const transformedPermission = {
      ...permission,
      roles: permission.roles.map((rp) => rp.role),
    };

    return plainToInstance(PermissionResponseDto, transformedPermission, {
      excludeExtraneousValues: true,
    });
  }

  async delete(id: string): Promise<void> {
    const permission = await this.prisma.permission.findUnique({
      where: { id },
    });

    if (!permission) {
      throw new NotFoundException('Permission không tồn tại');
    }

    await this.prisma.permission.delete({
      where: { id },
    });
  }

  async findByModule(module: string): Promise<PermissionResponseDto[]> {
    const permissions = await this.prisma.permission.findMany({
      where: { module },
      include: {
        roles: {
          include: {
            role: true,
          },
        },
      },
    });

    // Transform roles từ RolePermission[] sang RoleDto[]
    const transformedPermissions = permissions.map((permission) => ({
      ...permission,
      roles: permission.roles.map((rp) => rp.role),
    }));

    return plainToInstance(PermissionResponseDto, transformedPermissions, {
      excludeExtraneousValues: true,
    });
  }
}
