import {
    CallHandler,
    ExecutionContext,
    Injectable,
    NestInterceptor,
  } from '@nestjs/common';
  import { map } from 'rxjs/operators';
  import { ApiResponseHelper } from '../response/api-response.helper';
  
  @Injectable()
  export class ResponseInterceptor implements NestInterceptor {
    intercept(_: ExecutionContext, next: CallHandler) {
      return next.handle().pipe(
        map((result) => {
          // result có thể là:
          // { data, message, pagination }
          if (result?.__raw === true) return result.data;
  
          return ApiResponseHelper.success(
            result?.data ?? result,
            result?.message,
            result?.pagination ?? null,
          );
        }),
      );
    }
  }