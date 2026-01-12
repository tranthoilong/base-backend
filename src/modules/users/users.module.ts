import { PrismaModule } from "common/database";
import { UsersService } from "./users.service";
import { Module } from "@nestjs/common";
import { UsersController } from "./users.controller";
import { UsersRepository } from "./users.repository";

@Module({
  imports: [PrismaModule],
  controllers: [UsersController],
  providers: [UsersService, UsersRepository],
  // exports: [UsersService],
})
export class UsersModule {}