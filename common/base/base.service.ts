export abstract class BaseService<T> {
    protected paginate(
      data: T[],
      page: number,
      limit: number,
      total: number,
    ) {
      return {
        data,
        pagination: {
          page,
          limit,
          total,
          total_pages: Math.ceil(total / limit),
        },
      };
    }
  }
  