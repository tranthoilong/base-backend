import { Controller, Get, Query } from '@nestjs/common';
import { BaseController } from 'common/base/base.controller';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { UsersService } from './users.service';
import { ApiResponse } from 'common/exceptions/exception.filter';
import type { UserDto } from './dto/user.dto';

@Controller('users')
export class UsersController extends BaseController {
  constructor(private readonly usersService: UsersService) {
    super();
  }

  @Get()
  async list(@Query() query: BaseQueryDto) : Promise<ApiResponse<UserDto[]>> {
    const pagination = new BaseQueryDto(query);
    return this.usersService.findAll(pagination);
  }

}
