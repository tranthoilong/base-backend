
import { registerAs } from '@nestjs/config';

export const appConfig = registerAs('app', () => ({
  name: process.env.APP_NAME,
  env: process.env.NODE_ENV,
  port: Number(process.env.PORT || 3000),
}));
