import {
  Controller,
  Get,
  Post,
  Put,
  Patch,
  Delete,
  Param,
  Body,
  Query,
} from '@nestjs/common';
import { BaseController } from 'common/base/base.controller';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { RolesService } from './roles.service';
import {
  CreateRoleDto,
  UpdateRoleDto,
  AssignPermissionsDto,
  UpdatePermissionsDto,
  RoleResponseDto,
} from './dto';
import { JwtAuthGuard } from 'common/guards';
import { UseGuards } from '@nestjs/common';
import { RequirePermission } from 'common/decorators/require-permission.decorator';

@Controller('roles')
@UseGuards(JwtAuthGuard)
export class RolesController extends BaseController {
  constructor(private readonly rolesService: RolesService) {
    super();
  }

  @Get()
  @RequirePermission('roles', 'read', '*')
  async findAll(
    @Query() query: BaseQueryDto,
  ): Promise<ApiResponse<RoleResponseDto[]>> {
    return this.rolesService.findAll(query);
  }

  @Get(':id')
  @RequirePermission('roles', 'read', '*')
  async findById(@Param('id') id: string): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.findById(id);
  }

  @Post()
  @RequirePermission('roles', 'create', '*')
  async create(
    @Body() createRoleDto: CreateRoleDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.create(createRoleDto);
  }

  @Patch(':id/permissions')
  @RequirePermission('roles', 'update', '*')
  async updatePermissions(
    @Param('id') id: string,
    @Body() updatePermissionsDto: UpdatePermissionsDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.updatePermissions(id, updatePermissionsDto);
  }

  @Put(':id/permissions')
  @RequirePermission('roles', 'update', '*')
  async assignPermissions(
    @Param('id') id: string,
    @Body() assignPermissionsDto: AssignPermissionsDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.assignPermissions(id, assignPermissionsDto);
  }

  @Put(':id')
  @RequirePermission('roles', 'update', '*')
  async update(
    @Param('id') id: string,
    @Body() updateRoleDto: UpdateRoleDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.update(id, updateRoleDto);
  }

  @Delete(':roleId/permissions/:permissionId')
  @RequirePermission('roles', 'update', '*')
  async removePermission(
    @Param('roleId') roleId: string,
    @Param('permissionId') permissionId: string,
  ): Promise<ApiResponse<null>> {
    return this.rolesService.removePermission(roleId, permissionId);
  }
}
