# 📦 Data Transfer Objects (DTOs) - Gogogo API

## 📚 Tổng quan

Đây là danh sách đầy đủ các DTOs được tạo cho ứng dụng xe công nghệ Gogogo.

## 🗂️ Cấu trúc Thư mục

```
src/modules/
├── users/dto/
│   └── user.dto.ts (UserDto, CreateUserDto, UpdateUserDto)
├── drivers/dto/
│   └── driver.dto.ts (DriverDto)
├── vehicles/dto/
│   └── vehicle.dto.ts (VehicleDto)
├── rides/dto/
│   └── ride.dto.ts (RideDto)
├── ratings/dto/
│   └── rating.dto.ts (RatingDto)
├── wallets/dto/
│   └── wallet.dto.ts (WalletDto, TransactionDto)
├── payments/dto/
│   └── payment.dto.ts (PaymentDto)
├── promotions/dto/
│   └── promotion.dto.ts (PromotionDto, PromotionUsageDto)
├── notifications/dto/
│   └── notification.dto.ts (NotificationDto)
└── earnings/dto/
    └── earning.dto.ts (EarningDto)

common/dto/
└── rbac.dto.ts (RoleDto, PermissionDto, RolePermissionDto, UserRoleDto)
```

## 📋 Danh sách DTOs

### 🔐 RBAC System (common/dto/rbac.dto.ts)

#### 1. **RoleDto**
```typescript
- id: string
- name: string (super_admin, admin, driver, customer, etc.)
- displayName: string
- description?: string
- isSystem: boolean
- permissions?: RolePermissionDto[]
- users?: UserRoleDto[]
```

#### 2. **PermissionDto**
```typescript
- id: string
- module: string (users, drivers, rides, etc.)
- action: string (create, read, update, delete)
- resource: string (*, own)
- code: string (module_action_resource)
- description?: string
- roles?: RolePermissionDto[]
```

#### 3. **RolePermissionDto**
```typescript
- id: string
- roleId: string
- permissionId: string
- role?: RoleDto
- permission?: PermissionDto
```

#### 4. **UserRoleDto**
```typescript
- id: string
- userId: string
- roleId: string
- assignedAt: Date
- assignedBy?: string
- expiresAt?: Date
- role?: RoleDto
```

---

### 👥 Users Module (src/modules/users/dto/)

#### **UserDto**
```typescript
- id: string
- email: string
- name: string
- phone: string
- avatar?: string
- role: UserRole (CUSTOMER, DRIVER, ADMIN)
- status: UserStatus (ACTIVE, INACTIVE, BANNED, PENDING_VERIFICATION)
- createdAt: Date
- updatedAt: Date
- driver?: DriverDto
- wallet?: WalletDto
- ridesAsCustomer?: RideDto[]
- ratingsGiven?: RatingDto[]
- ratingsReceived?: RatingDto[]
- notifications?: NotificationDto[]
- promotionUsages?: PromotionUsageDto[]
- userRoles?: UserRoleDto[]
```

#### **CreateUserDto**
```typescript
- email: string
- password: string
- name: string
- phone: string
- avatar?: string
- role?: UserRole
```

#### **UpdateUserDto**
```typescript
- email?: string
- name?: string
- phone?: string
- avatar?: string
- status?: UserStatus
```

---

### 🚗 Drivers Module (src/modules/drivers/dto/)

#### **DriverDto**
```typescript
- id: string
- userId: string
- licenseNumber: string
- licenseExpiry: Date
- status: DriverStatus (ONLINE, OFFLINE, BUSY, ON_TRIP)
- rating: number
- totalTrips: number
- currentLat?: number
- currentLng?: number
- licensePhoto?: string
- identityCardPhoto?: string
- isVerified: boolean
- createdAt: Date
- updatedAt: Date
- user?: UserDto
- vehicles?: VehicleDto[]
- rides?: RideDto[]
- earnings?: EarningDto[]
```

---

### 🚙 Vehicles Module (src/modules/vehicles/dto/)

#### **VehicleDto**
```typescript
- id: string
- driverId: string
- type: VehicleType (BIKE, CAR_4_SEAT, CAR_7_SEAT, LUXURY_CAR)
- brand: string
- model: string
- year: number
- licensePlate: string
- color: string
- seats: number
- registrationPhoto?: string
- insurancePhoto?: string
- photos: string[]
- isActive: boolean
- createdAt: Date
- updatedAt: Date
- driver?: DriverDto
- rides?: RideDto[]
```

---

### 🚖 Rides Module (src/modules/rides/dto/)

#### **RideDto**
```typescript
- id: string
- customerId: string
- driverId?: string
- vehicleId?: string
- pickupAddress: string
- pickupLat: number
- pickupLng: number
- dropoffAddress: string
- dropoffLat: number
- dropoffLng: number
- status: RideStatus (SEARCHING, ACCEPTED, ARRIVED, STARTED, COMPLETED, CANCELLED)
- vehicleType: VehicleType
- distance: number
- duration?: number
- baseFare: number
- distanceFare: number
- timeFare: number
- surgeFare: number
- discount: number
- totalFare: number
- paymentMethod: PaymentMethod (CASH, WALLET, CREDIT_CARD, BANK_TRANSFER)
- paymentStatus: PaymentStatus (PENDING, COMPLETED, FAILED, REFUNDED)
- requestedAt: Date
- acceptedAt?: Date
- arrivedAt?: Date
- startedAt?: Date
- completedAt?: Date
- cancelledAt?: Date
- cancelReason?: string
- notes?: string
- createdAt: Date
- updatedAt: Date
- customer?: UserDto
- driver?: DriverDto
- vehicle?: VehicleDto
- rating?: RatingDto
- payment?: PaymentDto
- promotionUsage?: PromotionUsageDto
```

---

### ⭐ Ratings Module (src/modules/ratings/dto/)

#### **RatingDto**
```typescript
- id: string
- rideId: string
- fromUserId: string
- toUserId: string
- rating: number (1-5)
- comment?: string
- tags: string[]
- createdAt: Date
- updatedAt: Date
- ride?: RideDto
- fromUser?: UserDto
- toUser?: UserDto
```

---

### 💰 Wallets Module (src/modules/wallets/dto/)

#### **WalletDto**
```typescript
- id: string
- userId: string
- balance: number
- createdAt: Date
- updatedAt: Date
- user?: UserDto
- transactions?: TransactionDto[]
```

#### **TransactionDto**
```typescript
- id: string
- walletId: string
- type: TransactionType (TOP_UP, WITHDRAW, RIDE_PAYMENT, REFUND, COMMISSION)
- amount: number
- balanceBefore: number
- balanceAfter: number
- description: string
- referenceId?: string
- createdAt: Date
- wallet?: WalletDto
```

---

### 💳 Payments Module (src/modules/payments/dto/)

#### **PaymentDto**
```typescript
- id: string
- rideId: string
- amount: number
- method: PaymentMethod
- status: PaymentStatus
- transactionId?: string
- gatewayResponse?: any
- paidAt?: Date
- createdAt: Date
- updatedAt: Date
- ride?: RideDto
```

---

### 🎁 Promotions Module (src/modules/promotions/dto/)

#### **PromotionDto**
```typescript
- id: string
- code: string
- title: string
- description: string
- type: PromotionType (PERCENTAGE, FIXED, FREE_RIDE)
- value: number
- maxDiscount?: number
- minRideAmount: number
- maxUsage?: number
- maxUsagePerUser: number
- currentUsage: number
- startDate: Date
- endDate: Date
- isActive: boolean
- createdAt: Date
- updatedAt: Date
- usages?: PromotionUsageDto[]
```

#### **PromotionUsageDto**
```typescript
- id: string
- promotionId: string
- userId: string
- rideId: string
- discount: number
- createdAt: Date
- promotion?: PromotionDto
- user?: UserDto
- ride?: RideDto
```

---

### 🔔 Notifications Module (src/modules/notifications/dto/)

#### **NotificationDto**
```typescript
- id: string
- userId: string
- title: string
- message: string
- type: string (RIDE_UPDATE, PROMOTION, PAYMENT, etc.)
- data?: any
- isRead: boolean
- createdAt: Date
- user?: UserDto
```

---

### 💵 Earnings Module (src/modules/earnings/dto/)

#### **EarningDto**
```typescript
- id: string
- driverId: string
- totalEarnings: number
- commission: number
- netEarnings: number
- date: Date
- weekNumber: number
- month: number
- year: number
- totalTrips: number
- totalDistance: number
- totalHours: number
- createdAt: Date
- updatedAt: Date
- driver?: DriverDto
```

---

## 💡 Cách sử dụng

### Import DTO

```typescript
// Import từ module cụ thể
import { UserDto, CreateUserDto } from '@/modules/users/dto';
import { DriverDto } from '@/modules/drivers/dto';
import { RideDto } from '@/modules/rides/dto';

// Import RBAC DTOs
import { RoleDto, PermissionDto, UserRoleDto } from '@/common/dto';
```

### Transform Entity sang DTO

```typescript
import { plainToInstance } from 'class-transformer';
import { UserDto } from '@/modules/users/dto';

// Transform single object
const userDto = plainToInstance(UserDto, userEntity, {
  excludeExtraneousValues: true, // Chỉ lấy các field có @Expose()
});

// Transform array
const usersDto = plainToInstance(UserDto, userEntities, {
  excludeExtraneousValues: true,
});
```

### Load Relations

```typescript
// Load với relations
const user = await prisma.user.findUnique({
  where: { id },
  include: {
    driver: true,
    wallet: true,
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

const userDto = plainToInstance(UserDto, user, {
  excludeExtraneousValues: true,
});
```

### Validation với DTO

```typescript
import { IsEmail, IsNotEmpty, MinLength } from 'class-validator';

export class CreateUserDto {
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @MinLength(6)
  @IsNotEmpty()
  password: string;

  @IsNotEmpty()
  name: string;

  @IsNotEmpty()
  phone: string;
}
```

---

## 🎯 Best Practices

1. **Chỉ expose những field cần thiết**: Sử dụng `@Expose()` decorator
2. **Không expose password**: Không bao giờ expose password trong response DTO
3. **Load relations có điều kiện**: Chỉ load relations khi cần thiết để tránh N+1 query
4. **Sử dụng Type decorator**: Cho nested objects và arrays
5. **Validation**: Thêm validation decorators cho CreateDto và UpdateDto

---

## 📌 Notes

- Tất cả DTOs đều support **optional relations** để tránh circular dependency
- Sử dụng `@Type()` decorator cho nested objects
- Relations được mark `optional` để có thể load theo nhu cầu
- Password field **không được expose** trong bất kỳ DTO response nào
