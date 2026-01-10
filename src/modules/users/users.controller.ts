import { Controller, Get, Query } from '@nestjs/common';
import { BaseController } from 'common/base/base.controller';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { UsersService } from './users.service';
// import { ListUsersDto } from './dto/list-users.dto'; // Ví dụ DTO mở rộng

@Controller('users')
export class UsersController extends BaseController {
  constructor(private readonly usersService: UsersService) {
    super();
  }

  @Get()
  async list(@Query() query: BaseQueryDto) {
    const pagination = new BaseQueryDto(query);
    return this.usersService.findAll(pagination);
  }

}
