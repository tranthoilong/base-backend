import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { BaseService } from 'common/base/base.service';
import { User } from '@prisma/client';
import { BaseQueryDto } from 'common/dto/base-query.dto';
import { ApiResponse } from 'common/exceptions/exception.filter';
import { UserDto, CreateUserDto, UpdateUserDto } from './dto';
import { ApiResponseHelper } from 'common/response/api-response.helper';
import { UsersRepository } from './users.repository';

@Injectable()
export class UsersService extends BaseService<User> {
  constructor(private readonly usersRepository: UsersRepository) {
    super();
  }

  async findAll(query: BaseQueryDto): Promise<ApiResponse<UserDto[]>> {
    try {
      const users: UserDto[] = await this.usersRepository.findAll(query);
      return ApiResponseHelper.success<UserDto[]>(
        users,
        'Lấy danh sách users thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Lấy danh sách users thất bại', error);
    }
  }

  async findById(id: string): Promise<ApiResponse<UserDto>> {
    try {
      const user = await this.usersRepository.findById(id);
      if (!user) {
        throw new NotFoundException('User không tồn tại');
      }
      return ApiResponseHelper.success<UserDto>(
        user,
        'Lấy thông tin user thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Lấy thông tin user thất bại', error);
    }
  }

  async create(createUserDto: CreateUserDto): Promise<ApiResponse<UserDto>> {
    try {
      // Kiểm tra email đã tồn tại chưa
      const existingUserByEmail = await this.usersRepository.findByEmail(
        createUserDto.email,
      );
      if (existingUserByEmail) {
        throw new ConflictException('Email đã được sử dụng');
      }

      // Kiểm tra số điện thoại đã tồn tại chưa
      const existingUserByPhone = await this.usersRepository.findByPhone(
        createUserDto.phone,
      );
      if (existingUserByPhone) {
        throw new ConflictException('Số điện thoại đã được sử dụng');
      }

      const user = await this.usersRepository.create(createUserDto);
      return ApiResponseHelper.success<UserDto>(
        user,
        'Tạo user thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Tạo user thất bại', error);
    }
  }

  async update(
    id: string,
    updateUserDto: UpdateUserDto,
  ): Promise<ApiResponse<UserDto>> {
    try {
      const existingUser = await this.usersRepository.findByIdRaw(id);
      if (!existingUser) {
        throw new NotFoundException('User không tồn tại');
      }

      // Kiểm tra email mới có trùng với user khác không
      if (updateUserDto.email && updateUserDto.email !== existingUser.email) {
        const existingUserByEmail = await this.usersRepository.findByEmail(
          updateUserDto.email,
        );
        if (existingUserByEmail) {
          throw new ConflictException('Email đã được sử dụng');
        }
      }

      // Kiểm tra số điện thoại mới có trùng với user khác không
      if (updateUserDto.phone && updateUserDto.phone !== existingUser.phone) {
        const existingUserByPhone = await this.usersRepository.findByPhone(
          updateUserDto.phone,
        );
        if (existingUserByPhone) {
          throw new ConflictException('Số điện thoại đã được sử dụng');
        }
      }

      const user = await this.usersRepository.update(id, updateUserDto);
      return ApiResponseHelper.success<UserDto>(
        user,
        'Cập nhật user thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Cập nhật user thất bại', error);
    }
  }

  async partialUpdate(
    id: string,
    updateUserDto: UpdateUserDto,
  ): Promise<ApiResponse<UserDto>> {
    // PATCH và PUT có thể dùng chung logic update
    return this.update(id, updateUserDto);
  }

  async delete(id: string): Promise<ApiResponse<null>> {
    try {
      const existingUser = await this.usersRepository.findByIdRaw(id);
      if (!existingUser) {
        throw new NotFoundException('User không tồn tại');
      }

      await this.usersRepository.delete(id);
      return ApiResponseHelper.success<null>(
        null,
        'Xóa user thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Xóa user thất bại', error);
    }
  }
}
