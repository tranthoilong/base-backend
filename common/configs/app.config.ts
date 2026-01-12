import { registerAs } from '@nestjs/config';

export const appConfig = registerAs('app', () => ({
  env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  logLevel: process.env.LOG_LEVEL || 'debug',
  corsOrigins: (process.env.CORS_ORIGINS || '')
    .split(',')
    .map((v) => v.trim())
    .filter(Boolean),
  enableSwagger: process.env.ENABLE_SWAGGER !== 'false',
  apiPrefix: process.env.API_PREFIX || 'api/v1',
  swaggerTitle: process.env.SWAGGER_TITLE || 'Octo-Go API',
  swaggerDescription: process.env.SWAGGER_DESCRIPTION || 'API documentation for Octo-Go application',
  swaggerVersion: process.env.SWAGGER_VERSION || '1.0',
  jwt: {
    accessTokenSecret: process.env.JWT_ACCESS_TOKEN_SECRET || 'your-access-token-secret-key-change-in-production',
    accessTokenExpiresIn: process.env.JWT_ACCESS_TOKEN_EXPIRES_IN || '15m',
    refreshTokenSecret: process.env.JWT_REFRESH_TOKEN_SECRET || 'your-refresh-token-secret-key-change-in-production',
    refreshTokenExpiresIn: process.env.JWT_REFRESH_TOKEN_EXPIRES_IN || '7d',
  },
}));
