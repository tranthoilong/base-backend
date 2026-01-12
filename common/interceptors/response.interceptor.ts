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
  
          // Nếu result đã là ApiResponse (có success, message, data, timestamp)
          // thì trả về trực tiếp, không wrap lại
          if (
            result &&
            typeof result === 'object' &&
            'success' in result &&
            'message' in result &&
            'data' in result &&
            'timestamp' in result
          ) {
            return result;
          }
  
          return ApiResponseHelper.success(
            result?.data ?? result,
            result?.message,
            result?.pagination ?? null,
          );
        }),
      );
    }
  }