import { Controller, Get, Param, Post, Put, Query, Body, Patch, Delete, UseGuards } from "@nestjs/common";
import { UsersService } from "./users.service";
import { BaseController } from "common/base/base.controller";
import { BaseQueryDto } from "common/dto/base-query.dto";
import { ApiResponse } from "common/exceptions/exception.filter";
import { CreateUserDto, UpdateUserDto, UserDto } from "./dto/user.dto";
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
  async list(@Query() query: BaseQueryDto) : Promise<ApiResponse<UserDto[]>> {
    return this.usersService.findAll(query);
  }

  @Post()
  @RequirePermission('users', 'create', '*')
  async create(@Body() createUserDto: CreateUserDto): Promise<ApiResponse<UserDto>> {
    // TODO: Implement create user
    throw new Error('Not implemented');
  }

  @Put(':id')
  @RequirePermission('users', 'update', '*')
  async update(
    @Param('id') id: string,
    @Body() updateUserDto: UpdateUserDto,
  ): Promise<ApiResponse<UserDto>> {
    // TODO: Implement update user
    throw new Error('Not implemented');
  }

  @Delete(':id')
  @RequirePermission('users', 'delete', '*')
  async delete(@Param('id') id: string): Promise<ApiResponse<null>> {
    // TODO: Implement delete user
    throw new Error('Not implemented');
  }
}
