import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto, RefreshTokenDto, AuthResponseDto } from './dto';
import { JwtAuthGuard } from 'common/guards';
import { ApiResponseHelper } from 'common/response/api-response.helper';
import { ApiResponse } from 'common/exceptions/exception.filter';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(@Body() registerDto: RegisterDto): Promise<ApiResponse<AuthResponseDto>> {
    try {
      const result = await this.authService.register(registerDto);
      return ApiResponseHelper.success<AuthResponseDto>(
        result,
        'Đăng ký thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Đăng ký thất bại', error);
    }
  }

  @Post('login')
  async login(@Body() loginDto: LoginDto): Promise<ApiResponse<AuthResponseDto>> {
    try {
      const result = await this.authService.login(loginDto);
      return ApiResponseHelper.success<AuthResponseDto>(
        result,
        'Đăng nhập thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Đăng nhập thất bại', error);
    }
  }

  @Post('refresh')
  async refreshToken(
    @Body() refreshTokenDto: RefreshTokenDto,
  ): Promise<ApiResponse<AuthResponseDto>> {
    try {
      const result = await this.authService.refreshToken(refreshTokenDto);
      return ApiResponseHelper.success<AuthResponseDto>(
        result,
        'Làm mới token thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Làm mới token thất bại', error);
    }
  }

  @Post('logout')
  @UseGuards(JwtAuthGuard)
  async logout(@Request() req): Promise<ApiResponse<null>> {
    try {
      const userId = req.user.id;
      const refreshToken = req.body?.refreshToken;
      
      await this.authService.logout(userId, refreshToken);
      return ApiResponseHelper.success<null>(
        null,
        'Đăng xuất thành công',
        null,
      );
    } catch (error) {
      return ApiResponseHelper.error('Đăng xuất thất bại', error);
    }
  }
}
