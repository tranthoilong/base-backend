import { SetMetadata } from '@nestjs/common';

export interface PermissionMetadata {
  module: string;
  action: string;
  resource?: string;
}

export const PERMISSION_KEY = 'permissions';

/**
 * Decorator để định nghĩa quyền cần thiết cho endpoint
 * 
 * @param module - Tên module (ví dụ: 'users', 'drivers', 'rides')
 * @param action - Hành động (ví dụ: 'create', 'read', 'update', 'delete')
 * @param resource - Tài nguyên (mặc định: '*', có thể là 'own' hoặc giá trị cụ thể)
 * 
 * @example
 * @RequirePermission('users', 'delete')
 * @Delete(':id')
 * async deleteUser(@Param('id') id: string) { ... }
 * 
 * @example
 * @RequirePermission('users', 'update', 'own')
 * @Put(':id')
 * async updateOwnProfile(@Param('id') id: string) { ... }
 */
export const RequirePermission = (
  module: string,
  action: string,
  resource: string = '*',
) => SetMetadata(PERMISSION_KEY, { module, action, resource } as PermissionMetadata);
