import { Pagination } from "./pagination.interface";
import { ApiResponse } from "common/exceptions/exception.filter";
export class ApiResponseHelper {
    static success<T>(
      data: T,
      message = 'Success',
      pagination: Pagination | null = null,
    ): ApiResponse<T> {
      return {
        success: true,
        message,
        data,
        error: null,
        pagination,
        timestamp: new Date().toISOString(),
      };
    }
  
    static error(message: string, error: Error | null = null) {
      return {
        success: false,
        message,
        data: null,
        error,
        pagination: null,
        timestamp: new Date().toISOString(),
      };
    }
  }
  