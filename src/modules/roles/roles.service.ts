import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { BaseService } from 'common/base/base.service';
import { Role } from '@prisma/client';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { ApiResponseHelper } from 'common/response/api-response.helper';
import { RolesRepository } from './roles.repository';
import {
  CreateRoleDto,
  UpdateRoleDto,
  AssignPermissionsDto,
  RoleResponseDto,
} from './dto';

@Injectable()
export class RolesService extends BaseService<Role> {
  constructor(private readonly rolesRepository: RolesRepository) {
    super();
  }

  async findAll(query: BaseQueryDto): Promise<ApiResponse<RoleResponseDto[]>> {
    try {
      const roles = await this.rolesRepository.findAll(query);
      return ApiResponseHelper.success<RoleResponseDto[]>(
        roles,
        'Lấy danh sách roles thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Lấy danh sách roles thất bại', error);
    }
  }

  async findById(id: string): Promise<ApiResponse<RoleResponseDto>> {
    try {
      const role = await this.rolesRepository.findById(id);
      if (!role) {
        throw new NotFoundException('Role không tồn tại');
      }
      return ApiResponseHelper.success<RoleResponseDto>(
        role,
        'Lấy thông tin role thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Lấy thông tin role thất bại', error);
    }
  }

  async create(createRoleDto: CreateRoleDto): Promise<ApiResponse<RoleResponseDto>> {
    try {
      // Kiểm tra role name đã tồn tại chưa
      const existingRole = await this.rolesRepository.findByName(
        createRoleDto.name,
      );
      if (existingRole) {
        throw new ConflictException('Tên role đã tồn tại');
      }

      const role = await this.rolesRepository.create(createRoleDto);
      return ApiResponseHelper.success<RoleResponseDto>(
        role,
        'Tạo role thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Tạo role thất bại', error);
    }
  }

  async update(
    id: string,
    updateRoleDto: UpdateRoleDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    try {
      const existingRole = await this.rolesRepository.findById(id);
      if (!existingRole) {
        throw new NotFoundException('Role không tồn tại');
      }

      const role = await this.rolesRepository.update(id, updateRoleDto);
      return ApiResponseHelper.success<RoleResponseDto>(
        role,
        'Cập nhật role thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Cập nhật role thất bại', error);
    }
  }

  async delete(id: string): Promise<ApiResponse<null>> {
    try {
      await this.rolesRepository.delete(id);
      return ApiResponseHelper.success<null>(
        null,
        'Xóa role thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Xóa role thất bại', error);
    }
  }

  async assignPermissions(
    id: string,
    assignPermissionsDto: AssignPermissionsDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    try {
      const existingRole = await this.rolesRepository.findById(id);
      if (!existingRole) {
        throw new NotFoundException('Role không tồn tại');
      }

      const role = await this.rolesRepository.assignPermissions(
        id,
        assignPermissionsDto.permissionIds,
      );
      return ApiResponseHelper.success<RoleResponseDto>(
        role,
        'Gán permissions cho role thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error(
        'Gán permissions cho role thất bại',
        error,
      );
    }
  }

  async removePermission(
    roleId: string,
    permissionId: string,
  ): Promise<ApiResponse<null>> {
    try {
      await this.rolesRepository.removePermission(roleId, permissionId);
      return ApiResponseHelper.success<null>(
        null,
        'Xóa permission khỏi role thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error(
        'Xóa permission khỏi role thất bại',
        error,
      );
    }
  }
}
