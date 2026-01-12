import { Controller, Get, Param, Post, Put, Query, Body, Patch } from "@nestjs/common";
import { UsersService } from "./users.service";
import { BaseController } from "common/base/base.controller";
import { BaseQueryDto } from "common/dto/base-query.dto";
import { ApiResponse } from "common/exceptions/exception.filter";
import { CreateUserDto, UpdateUserDto, UserDto } from "./dto/user.dto";

@Controller('users')
export class UsersController extends BaseController {
  constructor(private readonly usersService: UsersService) {
    super();
  }

  @Get()
  async list(@Query() query: BaseQueryDto) : Promise<ApiResponse<UserDto[]>> {
    return this.usersService.findAll(query);
  }


}
