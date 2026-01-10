import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  constructor(private configService: ConfigService) {
    // Get DATABASE_URL from config or environment
    const databaseUrl = configService.get<string>('database.url') || process.env.DATABASE_URL;

    // Create PostgreSQL connection pool
    const pool = new Pool({
      connectionString: databaseUrl,
      max: 10, // Maximum number of clients in the pool
    });

    // Create Prisma adapter (required for Prisma 7)
    const adapter = new PrismaPg(pool);

    super({
      adapter, // Required for Prisma 7 - replaces datasources configuration
    });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
