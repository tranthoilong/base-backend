import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Param,
  Body,
  Query,
} from '@nestjs/common';
import { BaseController } from 'common/base/base.controller';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { PermissionsService } from './permissions.service';
import {
  CreatePermissionDto,
  UpdatePermissionDto,
  PermissionResponseDto,
} from './dto';
import { JwtAuthGuard } from 'common/guards';
import { UseGuards } from '@nestjs/common';

@Controller('permissions')
@UseGuards(JwtAuthGuard)
export class PermissionsController extends BaseController {
  constructor(private readonly permissionsService: PermissionsService) {
    super();
  }

  @Get()
  async findAll(
    @Query() query: BaseQueryDto,
  ): Promise<ApiResponse<PermissionResponseDto[]>> {
    return this.permissionsService.findAll(query);
  }

  @Get('module/:module')
  async findByModule(
    @Param('module') module: string,
  ): Promise<ApiResponse<PermissionResponseDto[]>> {
    return this.permissionsService.findByModule(module);
  }

  @Get(':id')
  async findById(
    @Param('id') id: string,
  ): Promise<ApiResponse<PermissionResponseDto>> {
    return this.permissionsService.findById(id);
  }

  @Post()
  async create(
    @Body() createPermissionDto: CreatePermissionDto,
  ): Promise<ApiResponse<PermissionResponseDto>> {
    return this.permissionsService.create(createPermissionDto);
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() updatePermissionDto: UpdatePermissionDto,
  ): Promise<ApiResponse<PermissionResponseDto>> {
    return this.permissionsService.update(id, updatePermissionDto);
  }

  @Delete(':id')
  async delete(@Param('id') id: string): Promise<ApiResponse<null>> {
    return this.permissionsService.delete(id);
  }
}
