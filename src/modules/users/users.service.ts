import { Injectable } from '@nestjs/common';
import { BaseService } from 'common/base/base.service';
  import  { User } from '@prisma/client';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { UserDto } from './dto/user.dto';
import { ApiResponseHelper } from 'common/response/api-response.helper';
import { UsersRepository } from './users.repository';
import { log } from 'console';

@Injectable()
export class UsersService extends BaseService<User> {
  constructor(private readonly usersRepository: UsersRepository) {
    super();
  }

  async findAll(query: BaseQueryDto) : Promise<ApiResponse<UserDto[]>> {
    try {
      const users: UserDto[] = await this.usersRepository.findAll(query);
      console.log('Users:', users);
      return ApiResponseHelper.success<UserDto[]>(users, 'Users retrieved successfully', null);
    }
    catch (error) {
      console.error('Error retrieving users:', error);
      return ApiResponseHelper.error('Failed to retrieve users', error);
    }
  }
}
