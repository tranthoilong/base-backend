import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { BaseService } from 'common/base/base.service';
import { Permission } from '@prisma/client';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { ApiResponseHelper } from 'common/response/api-response.helper';
import { PermissionsRepository } from './permissions.repository';
import {
  CreatePermissionDto,
  UpdatePermissionDto,
  PermissionResponseDto,
} from './dto';

@Injectable()
export class PermissionsService extends BaseService<Permission> {
  constructor(
    private readonly permissionsRepository: PermissionsRepository,
  ) {
    super();
  }

  async findAll(
    query: BaseQueryDto,
  ): Promise<ApiResponse<PermissionResponseDto[]>> {
    try {
      const permissions = await this.permissionsRepository.findAll(query);
      return ApiResponseHelper.success<PermissionResponseDto[]>(
        permissions,
        'Lấy danh sách permissions thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error(
        'Lấy danh sách permissions thất bại',
        error,
      );
    }
  }

  async findById(
    id: string,
  ): Promise<ApiResponse<PermissionResponseDto>> {
    try {
      const permission = await this.permissionsRepository.findById(id);
      if (!permission) {
        throw new NotFoundException('Permission không tồn tại');
      }
      return ApiResponseHelper.success<PermissionResponseDto>(
        permission,
        'Lấy thông tin permission thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error(
        'Lấy thông tin permission thất bại',
        error,
      );
    }
  }

  async create(
    createPermissionDto: CreatePermissionDto,
  ): Promise<ApiResponse<PermissionResponseDto>> {
    try {
      // Kiểm tra permission đã tồn tại chưa (theo module, action, resource)
      const existingPermission =
        await this.permissionsRepository.findByModuleActionResource(
          createPermissionDto.module,
          createPermissionDto.action,
          createPermissionDto.resource,
        );
      if (existingPermission) {
        throw new ConflictException('Permission đã tồn tại');
      }

      const permission = await this.permissionsRepository.create(
        createPermissionDto,
      );
      return ApiResponseHelper.success<PermissionResponseDto>(
        permission,
        'Tạo permission thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Tạo permission thất bại', error);
    }
  }

  async update(
    id: string,
    updatePermissionDto: UpdatePermissionDto,
  ): Promise<ApiResponse<PermissionResponseDto>> {
    try {
      const existingPermission = await this.permissionsRepository.findById(id);
      if (!existingPermission) {
        throw new NotFoundException('Permission không tồn tại');
      }

      const permission = await this.permissionsRepository.update(
        id,
        updatePermissionDto,
      );
      return ApiResponseHelper.success<PermissionResponseDto>(
        permission,
        'Cập nhật permission thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error(
        'Cập nhật permission thất bại',
        error,
      );
    }
  }

  async delete(id: string): Promise<ApiResponse<null>> {
    try {
      await this.permissionsRepository.delete(id);
      return ApiResponseHelper.success<null>(
        null,
        'Xóa permission thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Xóa permission thất bại', error);
    }
  }

  async findByModule(module: string): Promise<ApiResponse<PermissionResponseDto[]>> {
    try {
      const permissions = await this.permissionsRepository.findByModule(module);
      return ApiResponseHelper.success<PermissionResponseDto[]>(
        permissions,
        'Lấy danh sách permissions theo module thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error(
        'Lấy danh sách permissions theo module thất bại',
        error,
      );
    }
  }
}
