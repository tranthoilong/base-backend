import { Injectable } from "@nestjs/common";
import { User } from "@prisma/client";
import { PrismaService } from "common/database/prisma.service";
import { BaseQueryDto } from "common/dto/base-query.dto";
import { UserDto } from "./dto";
import { plainToInstance } from "class-transformer";

@Injectable()
export class UsersRepository {
  constructor(private readonly prisma: PrismaService) {}


  findAll(query: BaseQueryDto) : Promise<UserDto[]> {
    return this.prisma.user.findMany({
        where: query.hasSearch() ? {
          OR: [
            { email: { contains: query.search, mode: 'insensitive' } },
            { name: { contains: query.search, mode: 'insensitive' } },
            { phone: { contains: query.search, mode: 'insensitive' } },
          ],
        } : undefined,
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
    }).then((users) => plainToInstance(UserDto, users, { excludeExtraneousValues: true }));
  } 
}