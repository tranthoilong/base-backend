import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Query,
  Patch,
} from '@nestjs/common';
import { BaseController } from 'common/base/base.controller';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { RolesService } from './roles.service';
import {
  CreateRoleDto,
  UpdateRoleDto,
  AssignPermissionsDto,
  RoleResponseDto,
} from './dto';
import { JwtAuthGuard } from 'common/guards';
import { UseGuards } from '@nestjs/common';

@Controller('roles')
@UseGuards(JwtAuthGuard)
export class RolesController extends BaseController {
  constructor(private readonly rolesService: RolesService) {
    super();
  }

  @Get()
  async findAll(
    @Query() query: BaseQueryDto,
  ): Promise<ApiResponse<RoleResponseDto[]>> {
    return this.rolesService.findAll(query);
  }

  @Get(':id')
  async findById(@Param('id') id: string): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.findById(id);
  }

  @Post()
  async create(
    @Body() createRoleDto: CreateRoleDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.create(createRoleDto);
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() updateRoleDto: UpdateRoleDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.update(id, updateRoleDto);
  }

  @Delete(':id')
  async delete(@Param('id') id: string): Promise<ApiResponse<null>> {
    return this.rolesService.delete(id);
  }

  @Post(':id/permissions')
  async assignPermissions(
    @Param('id') id: string,
    @Body() assignPermissionsDto: AssignPermissionsDto,
  ): Promise<ApiResponse<RoleResponseDto>> {
    return this.rolesService.assignPermissions(id, assignPermissionsDto);
  }

  @Delete(':roleId/permissions/:permissionId')
  async removePermission(
    @Param('roleId') roleId: string,
    @Param('permissionId') permissionId: string,
  ): Promise<ApiResponse<null>> {
    return this.rolesService.removePermission(roleId, permissionId);
  }
}
