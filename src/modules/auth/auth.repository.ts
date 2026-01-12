import { Injectable } from '@nestjs/common';
import { PrismaService } from 'common/database/prisma.service';
import { User, RefreshToken } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

@Injectable()
export class AuthRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findUserByEmail(email: string): Promise<(User & { userRoles?: { role: { name: string } }[] }) | null> {
    return this.prisma.user.findUnique({
      where: { email },
      include: {
        userRoles: {
          include: {
            role: true,
          },
        },
      },
    });
  }

  async findUserByPhone(phone: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { phone },
    });
  }

  async createUser(data: {
    email: string;
    password: string;
    name: string;
    phone: string;
    avatar?: string;
  }): Promise<User> {
    const hashedPassword = await bcrypt.hash(data.password, 10);
    
    return this.prisma.user.create({
      data: {
        ...data,
        password: hashedPassword,
      },
    });
  }

  async validatePassword(plainPassword: string, hashedPassword: string): Promise<boolean> {
    return bcrypt.compare(plainPassword, hashedPassword);
  }

  async createRefreshToken(data: {
    userId: string;
    token: string;
    expiresAt: Date;
  }): Promise<RefreshToken> {
    return this.prisma.refreshToken.create({
      data,
    });
  }

  async findRefreshToken(token: string): Promise<(RefreshToken & { user: User & { userRoles?: { role: { name: string } }[] } }) | null> {
    return this.prisma.refreshToken.findUnique({
      where: { token },
      include: { 
        user: {
          include: {
            userRoles: {
              include: {
                role: true,
              },
            },
          },
        },
      },
    });
  }

  async revokeRefreshToken(token: string): Promise<void> {
    await this.prisma.refreshToken.update({
      where: { token },
      data: { isRevoked: true },
    });
  }

  async revokeAllUserTokens(userId: string): Promise<void> {
    await this.prisma.refreshToken.updateMany({
      where: { userId, isRevoked: false },
      data: { isRevoked: true },
    });
  }

  async deleteExpiredTokens(): Promise<void> {
    await this.prisma.refreshToken.deleteMany({
      where: {
        expiresAt: {
          lt: new Date(),
        },
      },
    });
  }

  async assignDefaultRole(userId: string, roleName: string): Promise<void> {
    // Tìm role theo name
    const role = await this.prisma.role.findUnique({
      where: { name: roleName },
    });

    if (!role) {
      // Nếu role không tồn tại, bỏ qua (có thể log warning)
      console.warn(`Role "${roleName}" không tồn tại, bỏ qua việc gán role cho user ${userId}`);
      return;
    }

    // Kiểm tra xem user đã có role này chưa
    const existingUserRole = await this.prisma.userRole_Model.findUnique({
      where: {
        userId_roleId: {
          userId,
          roleId: role.id,
        },
      },
    });

    // Nếu chưa có, gán role
    if (!existingUserRole) {
      await this.prisma.userRole_Model.create({
        data: {
          userId,
          roleId: role.id,
        },
      });
    }
  }
}
