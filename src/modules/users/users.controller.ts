import { Controller, Get, Param, Post, Put, Query, Body, Patch, Delete, UseGuards } from "@nestjs/common";
import { UsersService } from "./users.service";
import { BaseController } from "common/base/base.controller";
import { BaseQueryDto } from "common/dto/base-query.dto";
import { ApiResponse } from "common/exceptions/exception.filter";
import { CreateUserDto, UpdateUserDto, UserDto } from "./dto";
import { JwtAuthGuard, PermissionGuard } from "common/guards";
import { RequirePermission } from "common/decorators";

@Controller('users')
@UseGuards(JwtAuthGuard, PermissionGuard)
export class UsersController extends BaseController {
  constructor(private readonly usersService: UsersService) {
    super();
  }

  @Get()
  @RequirePermission('users', 'read', '*')
  async list(
    @Query() query: BaseQueryDto,
  ): Promise<ApiResponse<UserDto[]>> {
    return this.usersService.findAll(query);
  }

  @Get(':id')
  @RequirePermission('users', 'read', '*')
  async findById(@Param('id') id: string): Promise<ApiResponse<UserDto>> {
    return this.usersService.findById(id);
  }

  @Post()
  @RequirePermission('users', 'create', '*')
  async create(
    @Body() createUserDto: CreateUserDto,
  ): Promise<ApiResponse<UserDto>> {
    return this.usersService.create(createUserDto);
  }

  @Put(':id')
  @RequirePermission('users', 'update', '*')
  async update(
    @Param('id') id: string,
    @Body() updateUserDto: UpdateUserDto,
  ): Promise<ApiResponse<UserDto>> {
    return this.usersService.update(id, updateUserDto);
  }

  @Patch(':id')
  @RequirePermission('users', 'update', '*')
  async partialUpdate(
    @Param('id') id: string,
    @Body() updateUserDto: UpdateUserDto,
  ): Promise<ApiResponse<UserDto>> {
    return this.usersService.partialUpdate(id, updateUserDto);
  }

  @Delete(':id')
  @RequirePermission('users', 'delete', '*')
  async delete(@Param('id') id: string): Promise<ApiResponse<null>> {
    return this.usersService.delete(id);
  }
}
