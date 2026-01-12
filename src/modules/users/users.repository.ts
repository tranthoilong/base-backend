import { Injectable } from "@nestjs/common";
import { User } from "@prisma/client";
import { PrismaService } from "common/database/prisma.service";
import { BaseQueryDto } from "common/dto/base-query.dto";
import { UserDto, CreateUserDto, UpdateUserDto } from "./dto";
import { plainToInstance } from "class-transformer";
import * as bcrypt from 'bcryptjs';

@Injectable()
export class UsersRepository {
  constructor(private readonly prisma: PrismaService) {}

  findAll(query: BaseQueryDto): Promise<UserDto[]> {
    return this.prisma.user.findMany({
      where: query.hasSearch()
        ? {
            OR: [
              { email: { contains: query.search, mode: 'insensitive' } },
              { name: { contains: query.search, mode: 'insensitive' } },
              { phone: { contains: query.search, mode: 'insensitive' } },
            ],
          }
        : undefined,
      orderBy: query.getOrderBy(),
      skip: query.getSkip(),
      take: query.getTake(),
      include: {
        userRoles: { include: { role: true } },
        driver: true,
        wallet: true,
        ridesAsCustomer: true,
        ratingsGiven: true,
        ratingsReceived: true,
        notifications: true,
        promotionUsages: true,
      },
    }).then((users) =>
      plainToInstance(UserDto, users, { excludeExtraneousValues: true }),
    );
  }

  async findById(id: string): Promise<UserDto | null> {
    const user = await this.prisma.user.findUnique({
      where: { id },
      include: {
        userRoles: { include: { role: true } },
        driver: true,
        wallet: true,
        ridesAsCustomer: true,
        ratingsGiven: true,
        ratingsReceived: true,
        notifications: true,
        promotionUsages: true,
      },
    });

    if (!user) {
      return null;
    }

    return plainToInstance(UserDto, user, { excludeExtraneousValues: true });
  }

  async findByIdRaw(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id },
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { email },
    });
  }

  async findByPhone(phone: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { phone },
    });
  }

  async create(createUserDto: CreateUserDto): Promise<UserDto> {
    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);

    const user = await this.prisma.user.create({
      data: {
        email: createUserDto.email,
        password: hashedPassword,
        name: createUserDto.name,
        phone: createUserDto.phone,
        avatar: createUserDto.avatar,
      },
      include: {
        userRoles: { include: { role: true } },
        driver: true,
        wallet: true,
        ridesAsCustomer: true,
        ratingsGiven: true,
        ratingsReceived: true,
        notifications: true,
        promotionUsages: true,
      },
    });

    return plainToInstance(UserDto, user, { excludeExtraneousValues: true });
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<UserDto> {
    const user = await this.prisma.user.update({
      where: { id },
      data: updateUserDto,
      include: {
        userRoles: { include: { role: true } },
        driver: true,
        wallet: true,
        ridesAsCustomer: true,
        ratingsGiven: true,
        ratingsReceived: true,
        notifications: true,
        promotionUsages: true,
      },
    });

    return plainToInstance(UserDto, user, { excludeExtraneousValues: true });
  }

  async delete(id: string): Promise<void> {
    await this.prisma.user.delete({
      where: { id },
    });
  }
}