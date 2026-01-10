import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { appConfig, databaseConfig } from 'common/configs';
import { PrismaModule } from 'common/database';
import { UsersModule } from './modules/users/users.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, databaseConfig],
    }),
    PrismaModule,
    UsersModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
