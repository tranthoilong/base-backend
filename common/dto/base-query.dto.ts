import { Type, Transform } from 'class-transformer';
import { IsOptional, IsString, IsInt, IsBoolean, IsIn } from 'class-validator';

export class BaseQueryDto {
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  page?: number = 1;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  limit?: number = 10;

  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @Transform(({ value }) => value ? new Date(value) : undefined)
  startDate?: Date;

  @IsOptional()
  @Transform(({ value }) => value ? new Date(value) : undefined)
  endDate?: Date;

  @IsOptional()
  @Transform(({ value, obj }) => {
    // Hỗ trợ format "createdAt,desc" hoặc riêng lẻ
    if (typeof value === 'string' && value.includes(',')) {
      const parts = value.split(',');
      obj.sortOrder = (parts[1] as 'asc' | 'desc') || 'desc';
      return parts[0] || 'createdAt';
    }
    return value || 'createdAt';
  })
  @IsString()
  sortBy?: string = 'createdAt';

  @IsOptional()
  @IsIn(['asc', 'desc'])
  sortOrder?: 'asc' | 'desc' = 'desc';

  @IsOptional()
  @Transform(({ value }) => {
    if (value === 'true' || value === true) return true;
    if (value === 'false' || value === false) return false;
    return false;
  })
  @IsBoolean()
  all?: boolean = false;

  getPage(): number {
    return this.page || 1;
  }

  getLimit(): number | undefined {
    // Nếu all = true, không giới hạn limit
    if (this.all) {
      return undefined;
    }
    return this.limit || 10;
  }

  getSkip(): number | undefined {
    // Nếu all = true, không skip
    if (this.all) {
      return undefined;
    }
    return (this.getPage() - 1) * (this.limit || 10);
  }

  getTake(): number | undefined {
    return this.getLimit();
  }

  getOrderBy(): Record<string, 'asc' | 'desc'> {
    return {
      [this.sortBy || 'createdAt']: this.sortOrder || 'desc',
    };
  }

  hasSearch(): boolean {
    return !!this.search && this.search.trim().length > 0;
  }

  hasDateRange(): boolean {
    return !!this.startDate || !!this.endDate;
  }

  getDateRange(): { startDate?: Date; endDate?: Date } {
    return {
      startDate: this.startDate ? new Date(this.startDate) : undefined,
      endDate: this.endDate ? new Date(this.endDate) : undefined,
    };
  }
}
