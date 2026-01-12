import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'common/database/prisma.service';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { Role, Permission } from '@prisma/client';
import { CreateRoleDto, UpdateRoleDto, RoleResponseDto } from './dto';
import { plainToInstance } from 'class-transformer';

@Injectable()
export class RolesRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(query: BaseQueryDto): Promise<RoleResponseDto[]> {
    const roles = await this.prisma.role.findMany({
      where: query.hasSearch()
        ? {
            OR: [
              { name: { contains: query.search, mode: 'insensitive' } },
              { displayName: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : undefined,
      orderBy: query.getOrderBy(),
      skip: query.getSkip(),
      take: query.getTake(),
      include: {
        permissions: {
          include: {
            permission: true,
          },
        },
        users: true,
      },
    });

    // Transform permissions từ RolePermission[] sang PermissionDto[]
    const transformedRoles = roles.map((role) => ({
      ...role,
      permissions: role.permissions.map((rp) => rp.permission),
    }));

    return plainToInstance(RoleResponseDto, transformedRoles, {
      excludeExtraneousValues: true,
    });
  }

  async findById(id: string): Promise<RoleResponseDto | null> {
    const role = await this.prisma.role.findUnique({
      where: { id },
      include: {
        permissions: {
          include: {
            permission: true,
          },
        },
        users: {
          include: {
            user: true,
          },
        },
      },
    });

    if (!role) {
      return null;
    }

    // Transform permissions từ RolePermission[] sang PermissionDto[]
    const transformedRole = {
      ...role,
      permissions: role.permissions.map((rp) => rp.permission),
    };

    return plainToInstance(RoleResponseDto, transformedRole, {
      excludeExtraneousValues: true,
    });
  }

  async findByName(name: string): Promise<Role | null> {
    return this.prisma.role.findUnique({
      where: { name },
    });
  }

  async create(createRoleDto: CreateRoleDto): Promise<RoleResponseDto> {
    const role = await this.prisma.role.create({
      data: {
        name: createRoleDto.name,
        displayName: createRoleDto.displayName,
        description: createRoleDto.description,
        isSystem: createRoleDto.isSystem || false,
      },
      include: {
        permissions: {
          include: {
            permission: true,
          },
        },
      },
    });

    // Transform permissions từ RolePermission[] sang PermissionDto[]
    const transformedRole = {
      ...role,
      permissions: role.permissions.map((rp) => rp.permission),
    };

    return plainToInstance(RoleResponseDto, transformedRole, {
      excludeExtraneousValues: true,
    });
  }

  async update(
    id: string,
    updateRoleDto: UpdateRoleDto,
  ): Promise<RoleResponseDto> {
    const role = await this.prisma.role.update({
      where: { id },
      data: updateRoleDto,
      include: {
        permissions: {
          include: {
            permission: true,
          },
        },
      },
    });

    // Transform permissions từ RolePermission[] sang PermissionDto[]
    const transformedRole = {
      ...role,
      permissions: role.permissions.map((rp) => rp.permission),
    };

    return plainToInstance(RoleResponseDto, transformedRole, {
      excludeExtraneousValues: true,
    });
  }

  async delete(id: string): Promise<void> {
    const role = await this.prisma.role.findUnique({
      where: { id },
    });

    if (!role) {
      throw new NotFoundException('Role không tồn tại');
    }

    if (role.isSystem) {
      throw new Error('Không thể xóa role hệ thống');
    }

    await this.prisma.role.delete({
      where: { id },
    });
  }

  async assignPermissions(
    roleId: string,
    permissionIds: string[],
  ): Promise<RoleResponseDto> {
    // Kiểm tra role tồn tại
    const existingRole = await this.prisma.role.findUnique({
      where: { id: roleId },
    });

    if (!existingRole) {
      throw new NotFoundException('Role không tồn tại');
    }

    // Xóa tất cả permissions hiện tại
    await this.prisma.rolePermission.deleteMany({
      where: { roleId },
    });

    // Thêm permissions mới
    if (permissionIds.length > 0) {
      await this.prisma.rolePermission.createMany({
        data: permissionIds.map((permissionId) => ({
          roleId,
          permissionId,
        })),
      });
    }

    const role = await this.findById(roleId);
    if (!role) {
      throw new NotFoundException('Role không tồn tại');
    }

    return role;
  }

  async removePermission(roleId: string, permissionId: string): Promise<void> {
    await this.prisma.rolePermission.delete({
      where: {
        roleId_permissionId: {
          roleId,
          permissionId,
        },
      },
    });
  }
}
