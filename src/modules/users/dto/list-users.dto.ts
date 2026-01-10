import { BaseQueryDto } from 'common/dto/base-query.dto';

/**
 * Ví dụ về cách mở rộng BaseQueryDto với các params khác
 * Bạn có thể thêm các field mới vào đây
 */
export class ListUsersDto extends BaseQueryDto {
  status?: string;

  constructor(query: any) {
    super(query);
    this.status = query.status;
  }
}
