import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PrismaService } from 'common/database/prisma.service';
import { PERMISSION_KEY, PermissionMetadata } from 'common/decorators/require-permission.decorator';

@Injectable()
export class PermissionGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    // Lấy metadata quyền từ decorator
    const requiredPermission = this.reflector.getAllAndOverride<PermissionMetadata>(
      PERMISSION_KEY,
      [context.getHandler(), context.getClass()],
    );

    // Nếu không có decorator @RequirePermission, cho phép truy cập
    if (!requiredPermission) {
      return true;
    }

    // Lấy user từ request (đã được set bởi JwtAuthGuard)
    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user) {
      throw new ForbiddenException('Bạn cần đăng nhập để thực hiện hành động này');
    }

    // Lấy tất cả roles của user cùng với permissions
    const userWithRoles = await this.prisma.user.findUnique({
      where: { id: user.id },
      include: {
        userRoles: {
          include: {
            role: {
              include: {
                permissions: {
                  include: {
                    permission: true,
                  },
                },
              },
            },
          },
        },
      },
    });

    if (!userWithRoles) {
      throw new ForbiddenException('Người dùng không tồn tại');
    }

    // Kiểm tra xem user có quyền tương ứng không
    const hasPermission = userWithRoles.userRoles.some((userRole) =>
      userRole.role.permissions.some((rolePermission) => {
        const permission = rolePermission.permission;
        const moduleMatch = permission.module === requiredPermission.module;
        const actionMatch = permission.action === requiredPermission.action;
        
        // Kiểm tra resource: '*' cho phép tất cả, hoặc khớp chính xác
        const resourceMatch =
          permission.resource === '*' ||
          permission.resource === requiredPermission.resource ||
          requiredPermission.resource === '*';

        return moduleMatch && actionMatch && resourceMatch;
      }),
    );

    if (!hasPermission) {
      throw new ForbiddenException(
        `Bạn không có quyền ${requiredPermission.module}:${requiredPermission.action}:${requiredPermission.resource}`,
      );
    }

    return true;
  }
}
