import { Pagination } from "common/response/pagination.interface";

export interface ApiResponse<T> {
    success: boolean;
    message: string;
    data: T | null;
    error: any | null;
    pagination: Pagination | null;
    timestamp: string;
  }
  