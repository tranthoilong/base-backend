export abstract class BaseController {
    protected ok<T>(data: T, message?: string, pagination?: any) {
      return { data, message, pagination };
    }
  }
  