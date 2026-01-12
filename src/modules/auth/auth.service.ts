import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { AuthRepository } from './auth.repository';
import { RegisterDto, LoginDto, RefreshTokenDto, AuthResponseDto } from './dto';
import { randomBytes } from 'crypto';

@Injectable()
export class AuthService {
  constructor(
    private readonly authRepository: AuthRepository,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async register(registerDto: RegisterDto): Promise<AuthResponseDto> {
    // Kiểm tra email đã tồn tại
    const existingUserByEmail = await this.authRepository.findUserByEmail(registerDto.email);
    if (existingUserByEmail) {
      throw new ConflictException('Email đã được sử dụng');
    }

    // Kiểm tra số điện thoại đã tồn tại
    const existingUserByPhone = await this.authRepository.findUserByPhone(registerDto.phone);
    if (existingUserByPhone) {
      throw new ConflictException('Số điện thoại đã được sử dụng');
    }

    // Tạo user mới
    const user = await this.authRepository.createUser(registerDto);

    // Tự động gán role 'customer' cho user mới đăng ký
    await this.authRepository.assignDefaultRole(user.id, 'customer');

    // Lấy lại user với userRoles
    const userWithRoles = await this.authRepository.findUserByEmail(user.email);
    if (!userWithRoles) {
      throw new UnauthorizedException('Không thể tải thông tin người dùng');
    }

    // Lấy role đầu tiên từ userRoles
    const primaryRole = userWithRoles.userRoles?.[0]?.role?.name || 'customer';

    // Tạo tokens
    const tokens = await this.generateTokens(userWithRoles.id, userWithRoles.email, primaryRole);

    return {
      ...tokens,
      user: {
        id: userWithRoles.id,
        email: userWithRoles.email,
        name: userWithRoles.name,
        phone: userWithRoles.phone,
        avatar: userWithRoles.avatar || undefined,
        role: primaryRole,
        status: userWithRoles.status,
      },
    };
  }

  async login(loginDto: LoginDto): Promise<AuthResponseDto> {
    // Tìm user theo email
    const user = await this.authRepository.findUserByEmail(loginDto.email);
    if (!user) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }

    // Kiểm tra mật khẩu
    const isPasswordValid = await this.authRepository.validatePassword(
      loginDto.password,
      user.password,
    );
    if (!isPasswordValid) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }

    // Kiểm tra trạng thái tài khoản
    if (user.status === 'BANNED' || user.status === 'INACTIVE') {
      throw new UnauthorizedException('Tài khoản đã bị khóa hoặc vô hiệu hóa');
    }

    // Lấy role đầu tiên từ userRoles (nếu có)
    const primaryRole = user.userRoles?.[0]?.role?.name || 'customer';

    // Tạo tokens
    const tokens = await this.generateTokens(user.id, user.email, primaryRole);

    return {
      ...tokens,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        avatar: user.avatar || undefined,
        role: primaryRole,
        status: user.status,
      },
    };
  }

  async refreshToken(refreshTokenDto: RefreshTokenDto): Promise<AuthResponseDto> {
    const { refreshToken } = refreshTokenDto;

    // Tìm refresh token trong database
    const tokenRecord = await this.authRepository.findRefreshToken(refreshToken);
    if (!tokenRecord) {
      throw new UnauthorizedException('Refresh token không hợp lệ');
    }

    // Kiểm tra token đã bị revoke chưa
    if (tokenRecord.isRevoked) {
      throw new UnauthorizedException('Refresh token đã bị thu hồi');
    }

    // Kiểm tra token đã hết hạn chưa
    if (tokenRecord.expiresAt < new Date()) {
      throw new UnauthorizedException('Refresh token đã hết hạn');
    }

    const user = tokenRecord.user;

    // Kiểm tra trạng thái tài khoản
    if (user.status === 'BANNED' || user.status === 'INACTIVE') {
      throw new UnauthorizedException('Tài khoản đã bị khóa hoặc vô hiệu hóa');
    }

    // Revoke token cũ
    await this.authRepository.revokeRefreshToken(refreshToken);

    // Lấy role đầu tiên từ userRoles (nếu có)
    const primaryRole = user.userRoles?.[0]?.role?.name || 'customer';

    // Tạo tokens mới
    const tokens = await this.generateTokens(user.id, user.email, primaryRole);

    return {
      ...tokens,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        phone: user.phone,
        avatar: user.avatar || undefined,
        role: primaryRole,
        status: user.status,
      },
    };
  }

  async logout(userId: string, refreshToken?: string): Promise<void> {
    if (refreshToken) {
      // Revoke token cụ thể
      await this.authRepository.revokeRefreshToken(refreshToken);
    } else {
      // Revoke tất cả tokens của user
      await this.authRepository.revokeAllUserTokens(userId);
    }
  }

  private async generateTokens(
    userId: string,
    email: string,
    role: string,
  ): Promise<{ accessToken: string; accessTokenExpiresIn: string; refreshToken: string; refreshTokenExpiresIn: string }> {
    const payload = {
      sub: userId,
      email,
      role,
    };

    // Lấy thời gian hết hạn của access token từ config
    const accessTokenExpiresInConfig = this.configService.get<string>('app.jwt.accessTokenExpiresIn') || '15m';

    // Tạo access token
    // Note: expiresIn đã được cấu hình trong JwtModule, không cần truyền lại
    const accessToken = await this.jwtService.signAsync(payload);

    // Tính toán thời gian hết hạn thực tế cho access token
    const accessTokenExpiresAt = this.parseExpiresIn(accessTokenExpiresInConfig);
    const accessTokenExpiresIn = accessTokenExpiresAt.toISOString();

    // Tạo refresh token (random string, lưu vào database)
    const refreshTokenValue = randomBytes(64).toString('hex');
    const refreshTokenExpiresInConfig = this.configService.get<string>('app.jwt.refreshTokenExpiresIn') || '7d';
    
    // Parse expiresIn (7d, 30d, etc.) thành Date
    const expiresAt = this.parseExpiresIn(refreshTokenExpiresInConfig);
    const refreshTokenExpiresIn = expiresAt.toISOString();

    await this.authRepository.createRefreshToken({
      userId,
      token: refreshTokenValue,
      expiresAt,
    });

    return {
      accessToken,
      accessTokenExpiresIn,
      refreshToken: refreshTokenValue,
      refreshTokenExpiresIn,
    };
  }

  private parseExpiresIn(expiresIn: string): Date {
    const now = new Date();
    const match = expiresIn.match(/^(\d+)([dhm])$/);
    
    if (!match) {
      // Default to 7 days if format is invalid
      now.setDate(now.getDate() + 7);
      return now;
    }

    const value = parseInt(match[1], 10);
    const unit = match[2];

    switch (unit) {
      case 'd':
        now.setDate(now.getDate() + value);
        break;
      case 'h':
        now.setHours(now.getHours() + value);
        break;
      case 'm':
        now.setMinutes(now.getMinutes() + value);
        break;
      default:
        now.setDate(now.getDate() + 7);
    }

    return now;
  }
}
