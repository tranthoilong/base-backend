import {
  Injectable,
  OnModuleInit,
  OnModuleDestroy,
  Logger,
} from '@nestjs/common';
import { PrismaClient, Prisma } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

@Injectable()
export class PrismaService
  extends PrismaClient<Prisma.PrismaClientOptions, 'query' | 'error'>
  implements OnModuleInit, OnModuleDestroy
{
  private readonly logger = new Logger(PrismaService.name);

  constructor() {
    // Create PostgreSQL connection pool
    const pool = new Pool({
      connectionString: process.env.DATABASE_URL,
      max: 10, // Maximum number of clients in the pool
    });

    // Create Prisma adapter
    const adapter = new PrismaPg(pool);

    super({
      adapter, // Required for Prisma 7
      log: [
        { emit: 'event', level: 'query' },
        { emit: 'event', level: 'error' },
        { emit: 'event', level: 'info' },
        { emit: 'event', level: 'warn' },
      ],
      errorFormat: 'pretty',
    });

    // Log queries in development
    if (process.env.NODE_ENV === 'development') {
      this.$on('query' as never, (e: Prisma.QueryEvent) => {
        // Log all queries in debug mode
        this.logger.debug(`Query: ${e.query}`);
        this.logger.debug(`Params: ${e.params}`);
        this.logger.debug(`Duration: ${e.duration}ms`);

        // Highlight slow queries
        if (e.duration > 100) {
          this.logger.warn(
            `🐌 SLOW QUERY (${e.duration}ms): ${e.query.substring(0, 200)}...`,
          );
        }
      });
    }

    // Log errors
    this.$on('error' as never, (e: Prisma.LogEvent) => {
      this.logger.error(`Prisma Error: ${e.message}`);
    });
  }

  async onModuleInit() {
    try {
      await this.$connect();
      this.logger.log('Database connected successfully');
    } catch (error) {
      this.logger.error('Failed to connect to database', error);
      throw error;
    }
  }

  async onModuleDestroy() {
    try {
      await this.$disconnect();
      this.logger.log('Database disconnected successfully');
    } catch (error) {
      this.logger.error('Error disconnecting from database', error);
    }
  }

  /**
   * Health check for database connection
   */
  async healthCheck(): Promise<boolean> {
    try {
      await this.$queryRaw`SELECT 1`;
      return true;
    } catch {
      return false;
    }
  }

  /**
   * Execute transaction with error handling
   */
  async executeTransaction<T>(
    callback: (tx: Prisma.TransactionClient) => Promise<T>,
  ): Promise<T> {
    return this.$transaction(callback, {
      maxWait: 5000, // Maximum time to wait for a transaction slot
      timeout: 10000, // Maximum time the transaction can run
    });
  }

  /**
   * Soft delete helper
   */
  async softDelete(model: string, id: string): Promise<void> {
    const modelName = model.toLowerCase();
    await (this as any)[modelName].update({
      where: { id },
      data: { deletedAt: new Date() },
    });
  }

  /**
   * Restore soft deleted record
   */
  async restore(model: string, id: string): Promise<void> {
    const modelName = model.toLowerCase();
    await (this as any)[modelName].update({
      where: { id },
      data: { deletedAt: null },
    });
  }
}
