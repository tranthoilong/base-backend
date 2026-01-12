import { UserDto } from './user.dto';

// DTO for user response (without password)
export class UserResponseDto extends UserDto {
  // Password không được expose
}
