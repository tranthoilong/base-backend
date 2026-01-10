export class BaseQueryDto {
  page?: number = 1;
  limit?: number = 10;
  search?: string;
  startDate?: string | Date;
  endDate?: string | Date;
  sortBy?: string = 'createdAt';
  sortOrder?: 'asc' | 'desc' = 'desc';
  all?: boolean = false;

  constructor(query?: any) {
    if (query) {
      this.page = query.page ? +query.page : 1;
      this.limit = query.limit ? +query.limit : 10;
      
      this.search = query.search;
      
      this.startDate = query.startDate ? new Date(query.startDate) : undefined;
      this.endDate = query.endDate ? new Date(query.endDate) : undefined;
      
      if (query.sortBy) {
        const sortParts = query.sortBy.split(',');
        this.sortBy = sortParts[0] || 'createdAt';
        this.sortOrder = (sortParts[1] as 'asc' | 'desc') || 'desc';
      } else {
        this.sortBy = 'createdAt';
        this.sortOrder = query.sortOrder || 'desc';
      }
      
      this.all = query.all === 'true' || query.all === true;
    }
  }

  getPage(): number {
    return this.page || 1;
  }

  getLimit(): number | undefined {
    if (this.all) {
      return undefined;
    }
    return this.limit || 10;
  }

  getSkip(): number | undefined {
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
