import { PrismaClient, UserRole, UserStatus, DriverStatus, VehicleType, RideStatus, PaymentMethod, PaymentStatus, PromotionType } from '@prisma/client';
import * as bcrypt from 'bcryptjs';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

// Load environment variables
import * as dotenv from 'dotenv';
dotenv.config();

const pool = new Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('🌱 Bắt đầu seeding database...\n');

  // Xóa dữ liệu cũ (theo thứ tự quan hệ)
  console.log('🗑️  Xóa dữ liệu cũ...');
  await prisma.promotionUsage.deleteMany();
  await prisma.notification.deleteMany();
  await prisma.rating.deleteMany();
  await prisma.payment.deleteMany();
  await prisma.earning.deleteMany();
  await prisma.ride.deleteMany();
  await prisma.vehicle.deleteMany();
  await prisma.driver.deleteMany();
  await prisma.transaction.deleteMany();
  await prisma.wallet.deleteMany();
  await prisma.promotion.deleteMany();
  await prisma.userRole_Model.deleteMany();
  await prisma.user.deleteMany();
  await prisma.rolePermission.deleteMany();
  await prisma.permission.deleteMany();
  await prisma.role.deleteMany();

  console.log('✅ Đã xóa dữ liệu cũ\n');

  // ============= TẠO RBAC SYSTEM =============
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('🔐 BẮT ĐẦU TẠO RBAC SYSTEM');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  
  console.log('🔑 Tạo permissions...');

  const permissionsData = [
    // ===== USERS MODULE =====
    { module: 'users', action: 'create', resource: '*', description: 'Tạo user mới', code: 'users_create_all' },
    { module: 'users', action: 'read', resource: '*', description: 'Xem tất cả users', code: 'users_read_all' },
    { module: 'users', action: 'read', resource: 'own', description: 'Xem thông tin cá nhân', code: 'users_read_own' },
    { module: 'users', action: 'update', resource: '*', description: 'Cập nhật bất kỳ user', code: 'users_update_all' },
    { module: 'users', action: 'update', resource: 'own', description: 'Cập nhật thông tin cá nhân', code: 'users_update_own' },
    { module: 'users', action: 'delete', resource: '*', description: 'Xóa user', code: 'users_delete_all' },
    { module: 'users', action: 'ban', resource: '*', description: 'Ban/Unban user', code: 'users_ban_all' },

    // ===== DRIVERS MODULE =====
    { module: 'drivers', action: 'create', resource: '*', description: 'Tạo tài xế mới', code: 'drivers_create_all' },
    { module: 'drivers', action: 'read', resource: '*', description: 'Xem tất cả tài xế', code: 'drivers_read_all' },
    { module: 'drivers', action: 'read', resource: 'own', description: 'Xem thông tin tài xế của mình', code: 'drivers_read_own' },
    { module: 'drivers', action: 'update', resource: '*', description: 'Cập nhật bất kỳ tài xế', code: 'drivers_update_all' },
    { module: 'drivers', action: 'update', resource: 'own', description: 'Cập nhật thông tin tài xế của mình', code: 'drivers_update_own' },
    { module: 'drivers', action: 'delete', resource: '*', description: 'Xóa tài xế', code: 'drivers_delete_all' },
    { module: 'drivers', action: 'approve', resource: '*', description: 'Duyệt tài xế', code: 'drivers_approve_all' },
    { module: 'drivers', action: 'manage', resource: 'status', description: 'Quản lý trạng thái tài xế', code: 'drivers_manage_status' },

    // ===== VEHICLES MODULE =====
    { module: 'vehicles', action: 'create', resource: '*', description: 'Tạo phương tiện', code: 'vehicles_create_all' },
    { module: 'vehicles', action: 'create', resource: 'own', description: 'Tạo phương tiện cho mình', code: 'vehicles_create_own' },
    { module: 'vehicles', action: 'read', resource: '*', description: 'Xem tất cả phương tiện', code: 'vehicles_read_all' },
    { module: 'vehicles', action: 'read', resource: 'own', description: 'Xem phương tiện của mình', code: 'vehicles_read_own' },
    { module: 'vehicles', action: 'update', resource: '*', description: 'Cập nhật bất kỳ phương tiện', code: 'vehicles_update_all' },
    { module: 'vehicles', action: 'update', resource: 'own', description: 'Cập nhật phương tiện của mình', code: 'vehicles_update_own' },
    { module: 'vehicles', action: 'delete', resource: '*', description: 'Xóa phương tiện', code: 'vehicles_delete_all' },
    { module: 'vehicles', action: 'approve', resource: '*', description: 'Duyệt phương tiện', code: 'vehicles_approve_all' },

    // ===== RIDES MODULE =====
    { module: 'rides', action: 'create', resource: '*', description: 'Tạo chuyến đi', code: 'rides_create_all' },
    { module: 'rides', action: 'read', resource: '*', description: 'Xem tất cả chuyến đi', code: 'rides_read_all' },
    { module: 'rides', action: 'read', resource: 'own', description: 'Xem chuyến đi của mình', code: 'rides_read_own' },
    { module: 'rides', action: 'update', resource: '*', description: 'Cập nhật bất kỳ chuyến đi', code: 'rides_update_all' },
    { module: 'rides', action: 'update', resource: 'own', description: 'Cập nhật chuyến đi của mình', code: 'rides_update_own' },
    { module: 'rides', action: 'cancel', resource: '*', description: 'Hủy bất kỳ chuyến đi', code: 'rides_cancel_all' },
    { module: 'rides', action: 'cancel', resource: 'own', description: 'Hủy chuyến đi của mình', code: 'rides_cancel_own' },
    { module: 'rides', action: 'accept', resource: '*', description: 'Nhận chuyến đi', code: 'rides_accept_all' },
    { module: 'rides', action: 'complete', resource: '*', description: 'Hoàn thành chuyến đi', code: 'rides_complete_all' },

    // ===== PAYMENTS MODULE =====
    { module: 'payments', action: 'create', resource: '*', description: 'Tạo thanh toán', code: 'payments_create_all' },
    { module: 'payments', action: 'read', resource: '*', description: 'Xem tất cả thanh toán', code: 'payments_read_all' },
    { module: 'payments', action: 'read', resource: 'own', description: 'Xem thanh toán của mình', code: 'payments_read_own' },
    { module: 'payments', action: 'update', resource: '*', description: 'Cập nhật thanh toán', code: 'payments_update_all' },
    { module: 'payments', action: 'refund', resource: '*', description: 'Hoàn tiền', code: 'payments_refund_all' },
    { module: 'payments', action: 'approve', resource: '*', description: 'Duyệt thanh toán', code: 'payments_approve_all' },

    // ===== WALLETS MODULE =====
    { module: 'wallets', action: 'read', resource: '*', description: 'Xem tất cả ví', code: 'wallets_read_all' },
    { module: 'wallets', action: 'read', resource: 'own', description: 'Xem ví của mình', code: 'wallets_read_own' },
    { module: 'wallets', action: 'topup', resource: '*', description: 'Nạp tiền cho bất kỳ ví', code: 'wallets_topup_all' },
    { module: 'wallets', action: 'topup', resource: 'own', description: 'Nạp tiền cho ví của mình', code: 'wallets_topup_own' },
    { module: 'wallets', action: 'withdraw', resource: '*', description: 'Rút tiền từ bất kỳ ví', code: 'wallets_withdraw_all' },
    { module: 'wallets', action: 'withdraw', resource: 'own', description: 'Rút tiền từ ví của mình', code: 'wallets_withdraw_own' },

    // ===== PROMOTIONS MODULE =====
    { module: 'promotions', action: 'create', resource: '*', description: 'Tạo khuyến mãi', code: 'promotions_create_all' },
    { module: 'promotions', action: 'read', resource: '*', description: 'Xem tất cả khuyến mãi', code: 'promotions_read_all' },
    { module: 'promotions', action: 'update', resource: '*', description: 'Cập nhật khuyến mãi', code: 'promotions_update_all' },
    { module: 'promotions', action: 'delete', resource: '*', description: 'Xóa khuyến mãi', code: 'promotions_delete_all' },
    { module: 'promotions', action: 'use', resource: '*', description: 'Sử dụng khuyến mãi', code: 'promotions_use_all' },

    // ===== RATINGS MODULE =====
    { module: 'ratings', action: 'create', resource: '*', description: 'Tạo đánh giá', code: 'ratings_create_all' },
    { module: 'ratings', action: 'read', resource: '*', description: 'Xem tất cả đánh giá', code: 'ratings_read_all' },
    { module: 'ratings', action: 'read', resource: 'own', description: 'Xem đánh giá của mình', code: 'ratings_read_own' },
    { module: 'ratings', action: 'update', resource: '*', description: 'Cập nhật bất kỳ đánh giá', code: 'ratings_update_all' },
    { module: 'ratings', action: 'delete', resource: '*', description: 'Xóa đánh giá', code: 'ratings_delete_all' },

    // ===== NOTIFICATIONS MODULE =====
    { module: 'notifications', action: 'send', resource: '*', description: 'Gửi thông báo cho tất cả', code: 'notifications_send_all' },
    { module: 'notifications', action: 'read', resource: '*', description: 'Xem tất cả thông báo', code: 'notifications_read_all' },
    { module: 'notifications', action: 'read', resource: 'own', description: 'Xem thông báo của mình', code: 'notifications_read_own' },

    // ===== REPORTS MODULE =====
    { module: 'reports', action: 'view', resource: 'financial', description: 'Xem báo cáo tài chính', code: 'reports_view_financial' },
    { module: 'reports', action: 'view', resource: 'operational', description: 'Xem báo cáo vận hành', code: 'reports_view_operational' },
    { module: 'reports', action: 'view', resource: 'driver', description: 'Xem báo cáo tài xế', code: 'reports_view_driver' },
    { module: 'reports', action: 'export', resource: '*', description: 'Xuất báo cáo', code: 'reports_export_all' },

    // ===== EARNINGS MODULE =====
    { module: 'earnings', action: 'read', resource: '*', description: 'Xem tất cả thu nhập', code: 'earnings_read_all' },
    { module: 'earnings', action: 'read', resource: 'own', description: 'Xem thu nhập của mình', code: 'earnings_read_own' },
    { module: 'earnings', action: 'manage', resource: '*', description: 'Quản lý thu nhập', code: 'earnings_manage_all' },

    // ===== SYSTEM/ADMIN MODULE =====
    { module: 'system', action: 'manage', resource: 'settings', description: 'Quản lý cài đặt hệ thống', code: 'system_manage_settings' },
    { module: 'system', action: 'manage', resource: 'roles', description: 'Quản lý roles', code: 'system_manage_roles' },
    { module: 'system', action: 'manage', resource: 'permissions', description: 'Quản lý permissions', code: 'system_manage_permissions' },
    { module: 'system', action: 'view', resource: 'logs', description: 'Xem system logs', code: 'system_view_logs' },
  ];

  const permissions = await Promise.all(
    permissionsData.map((perm) => prisma.permission.create({ data: perm }))
  );

  console.log(`✅ Đã tạo ${permissions.length} permissions\n`);

  // ============= TẠO ROLES =============
  console.log('👥 Tạo roles và gán permissions...');

  // Helper function to assign permissions to role
  const assignPermissions = async (roleId: string, permissionCodes: string[]) => {
    const rolePermissions = permissions.filter((p) => permissionCodes.includes(p.code));
    await Promise.all(
      rolePermissions.map((perm) =>
        prisma.rolePermission.create({
          data: { roleId, permissionId: perm.id },
        })
      )
    );
  };

  // 1. SUPER ADMIN
  const superAdminRole = await prisma.role.create({
    data: {
      name: 'super_admin',
      displayName: 'Super Admin',
      description: 'Quản trị viên cấp cao nhất - có toàn quyền',
      isSystem: true,
    },
  });
  await Promise.all(
    permissions.map((perm) =>
      prisma.rolePermission.create({
        data: { roleId: superAdminRole.id, permissionId: perm.id },
      })
    )
  );

  // 2. ADMIN
  const adminRole = await prisma.role.create({
    data: {
      name: 'admin',
      displayName: 'Quản trị viên',
      description: 'Quản trị viên hệ thống',
      isSystem: true,
    },
  });
  await assignPermissions(adminRole.id, [
    'users_read_all', 'users_update_all', 'users_ban_all',
    'drivers_read_all', 'drivers_update_all', 'drivers_approve_all', 'drivers_manage_status',
    'vehicles_read_all', 'vehicles_approve_all',
    'rides_read_all', 'rides_cancel_all',
    'payments_read_all', 'payments_refund_all',
    'wallets_read_all',
    'promotions_create_all', 'promotions_read_all', 'promotions_update_all', 'promotions_delete_all',
    'ratings_read_all', 'ratings_delete_all',
    'reports_view_financial', 'reports_view_operational', 'reports_export_all',
    'earnings_read_all',
  ]);

  // 3. DRIVER MANAGER
  const driverManagerRole = await prisma.role.create({
    data: {
      name: 'driver_manager',
      displayName: 'Quản lý Tài xế',
      description: 'Quản lý và duyệt tài xế, phương tiện',
      isSystem: true,
    },
  });
  await assignPermissions(driverManagerRole.id, [
    'drivers_read_all', 'drivers_update_all', 'drivers_approve_all', 'drivers_manage_status',
    'vehicles_read_all', 'vehicles_update_all', 'vehicles_approve_all',
    'users_read_all',
    'reports_view_driver',
    'earnings_read_all',
  ]);

  // 4. CUSTOMER SUPPORT
  const customerSupportRole = await prisma.role.create({
    data: {
      name: 'customer_support',
      displayName: 'Hỗ trợ Khách hàng',
      description: 'Hỗ trợ khách hàng, xử lý khiếu nại',
      isSystem: true,
    },
  });
  await assignPermissions(customerSupportRole.id, [
    'users_read_all',
    'drivers_read_all',
    'rides_read_all', 'rides_cancel_all',
    'payments_read_all', 'payments_refund_all',
    'ratings_read_all',
    'notifications_send_all',
    'wallets_read_all',
  ]);

  // 5. ACCOUNTANT
  const accountantRole = await prisma.role.create({
    data: {
      name: 'accountant',
      displayName: 'Kế toán',
      description: 'Quản lý tài chính, thanh toán',
      isSystem: true,
    },
  });
  await assignPermissions(accountantRole.id, [
    'payments_read_all', 'payments_approve_all',
    'wallets_read_all', 'wallets_topup_all', 'wallets_withdraw_all',
    'earnings_read_all', 'earnings_manage_all',
    'reports_view_financial', 'reports_export_all',
  ]);

  // 6. MARKETING
  const marketingRole = await prisma.role.create({
    data: {
      name: 'marketing',
      displayName: 'Marketing',
      description: 'Quản lý khuyến mãi, thông báo',
      isSystem: true,
    },
  });
  await assignPermissions(marketingRole.id, [
    'promotions_create_all', 'promotions_read_all', 'promotions_update_all', 'promotions_delete_all',
    'notifications_send_all',
    'users_read_all',
    'reports_view_operational',
  ]);

  // 7. DRIVER
  const driverRole = await prisma.role.create({
    data: {
      name: 'driver',
      displayName: 'Tài xế',
      description: 'Quyền mặc định cho tài xế',
      isSystem: true,
    },
  });
  await assignPermissions(driverRole.id, [
    'users_read_own', 'users_update_own',
    'drivers_read_own', 'drivers_update_own',
    'vehicles_create_own', 'vehicles_read_own', 'vehicles_update_own',
    'rides_read_own', 'rides_update_own', 'rides_accept_all', 'rides_complete_all',
    'payments_read_own',
    'wallets_read_own', 'wallets_withdraw_own',
    'ratings_create_all', 'ratings_read_own',
    'notifications_read_own',
    'earnings_read_own',
  ]);

  // 8. CUSTOMER
  const customerRole = await prisma.role.create({
    data: {
      name: 'customer',
      displayName: 'Khách hàng',
      description: 'Quyền mặc định cho khách hàng',
      isSystem: true,
    },
  });
  await assignPermissions(customerRole.id, [
    'users_read_own', 'users_update_own',
    'rides_create_all', 'rides_read_own', 'rides_cancel_own',
    'payments_read_own',
    'wallets_read_own', 'wallets_topup_own',
    'promotions_read_all', 'promotions_use_all',
    'ratings_create_all', 'ratings_read_own',
    'notifications_read_own',
  ]);

  console.log('✅ Đã tạo 8 roles với permissions tương ứng\n');

  // ============= TẠO BUSINESS DATA =============
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('📊 BẮT ĐẦU TẠO DỮ LIỆU NGHIỆP VỤ');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  const hashedPassword = await bcrypt.hash('123456', 10);

  // ============= TẠO USERS =============
  console.log('👥 Tạo users...');

  // Admin
  const admin = await prisma.user.create({
    data: {
      email: 'admin@gogogo.vn',
      password: hashedPassword,
      name: 'Admin Gogogo',
      phone: '0900000000',
      role: UserRole.ADMIN,
      status: UserStatus.ACTIVE,
      avatar: 'https://i.pravatar.cc/150?img=1',
    },
  });

  // Customers
  const customers = await Promise.all([
    prisma.user.create({
      data: {
        email: 'khach1@gmail.com',
        password: hashedPassword,
        name: 'Nguyễn Văn A',
        phone: '0901234567',
        role: UserRole.CUSTOMER,
        status: UserStatus.ACTIVE,
        avatar: 'https://i.pravatar.cc/150?img=11',
      },
    }),
    prisma.user.create({
      data: {
        email: 'khach2@gmail.com',
        password: hashedPassword,
        name: 'Trần Thị B',
        phone: '0902234567',
        role: UserRole.CUSTOMER,
        status: UserStatus.ACTIVE,
        avatar: 'https://i.pravatar.cc/150?img=21',
      },
    }),
    prisma.user.create({
      data: {
        email: 'khach3@gmail.com',
        password: hashedPassword,
        name: 'Lê Văn C',
        phone: '0903234567',
        role: UserRole.CUSTOMER,
        status: UserStatus.ACTIVE,
        avatar: 'https://i.pravatar.cc/150?img=31',
      },
    }),
  ]);

  // Driver Users
  const driverUsers = await Promise.all([
    prisma.user.create({
      data: {
        email: 'taixe1@gmail.com',
        password: hashedPassword,
        name: 'Phạm Văn Tài',
        phone: '0911234567',
        role: UserRole.DRIVER,
        status: UserStatus.ACTIVE,
        avatar: 'https://i.pravatar.cc/150?img=51',
      },
    }),
    prisma.user.create({
      data: {
        email: 'taixe2@gmail.com',
        password: hashedPassword,
        name: 'Hoàng Văn Lái',
        phone: '0912234567',
        role: UserRole.DRIVER,
        status: UserStatus.ACTIVE,
        avatar: 'https://i.pravatar.cc/150?img=52',
      },
    }),
    prisma.user.create({
      data: {
        email: 'taixe3@gmail.com',
        password: hashedPassword,
        name: 'Võ Thị Thu',
        phone: '0913234567',
        role: UserRole.DRIVER,
        status: UserStatus.ACTIVE,
        avatar: 'https://i.pravatar.cc/150?img=53',
      },
    }),
    prisma.user.create({
      data: {
        email: 'taixe4@gmail.com',
        password: hashedPassword,
        name: 'Đặng Văn Mạnh',
        phone: '0914234567',
        role: UserRole.DRIVER,
        status: UserStatus.ACTIVE,
        avatar: 'https://i.pravatar.cc/150?img=54',
      },
    }),
  ]);

  console.log(`✅ Đã tạo ${1 + customers.length + driverUsers.length} users`);

  // ============= GÁN ROLES CHO USERS =============
  console.log('🔐 Gán roles cho users...');

  // Gán role Super Admin cho admin user
  await prisma.userRole_Model.create({
    data: {
      userId: admin.id,
      roleId: superAdminRole.id,
    },
  });

  // Gán role Customer cho khách hàng
  await Promise.all(
    customers.map((customer) =>
      prisma.userRole_Model.create({
        data: {
          userId: customer.id,
          roleId: customerRole.id,
        },
      })
    )
  );

  // Gán role Driver cho tài xế
  await Promise.all(
    driverUsers.map((driverUser) =>
      prisma.userRole_Model.create({
        data: {
          userId: driverUser.id,
          roleId: driverRole.id,
        },
      })
    )
  );

  console.log('✅ Đã gán roles cho users');

  // ============= TẠO WALLETS =============
  console.log('💰 Tạo wallets...');

  await Promise.all([
    ...customers.map((customer) =>
      prisma.wallet.create({
        data: {
          userId: customer.id,
          balance: 500000 + Math.random() * 1000000, // 500k - 1.5M
        },
      })
    ),
    ...driverUsers.map((driver) =>
      prisma.wallet.create({
        data: {
          userId: driver.id,
          balance: Math.random() * 5000000, // 0 - 5M
        },
      })
    ),
  ]);

  console.log('✅ Đã tạo wallets');

  // ============= TẠO DRIVERS =============
  console.log('🚗 Tạo drivers...');

  const drivers = await Promise.all([
    prisma.driver.create({
      data: {
        userId: driverUsers[0].id,
        licenseNumber: 'B2-001234567',
        licenseExpiry: new Date('2028-12-31'),
        status: DriverStatus.ONLINE,
        rating: 4.8,
        totalTrips: 523,
        currentLat: 10.8231,
        currentLng: 106.6297,
        licensePhoto: 'https://example.com/license1.jpg',
        identityCardPhoto: 'https://example.com/id1.jpg',
        isVerified: true,
      },
    }),
    prisma.driver.create({
      data: {
        userId: driverUsers[1].id,
        licenseNumber: 'B2-002345678',
        licenseExpiry: new Date('2027-06-30'),
        status: DriverStatus.ONLINE,
        rating: 4.9,
        totalTrips: 712,
        currentLat: 10.7769,
        currentLng: 106.7009,
        licensePhoto: 'https://example.com/license2.jpg',
        identityCardPhoto: 'https://example.com/id2.jpg',
        isVerified: true,
      },
    }),
    prisma.driver.create({
      data: {
        userId: driverUsers[2].id,
        licenseNumber: 'A1-003456789',
        licenseExpiry: new Date('2029-03-15'),
        status: DriverStatus.ONLINE,
        rating: 4.7,
        totalTrips: 234,
        currentLat: 10.8542,
        currentLng: 106.6291,
        licensePhoto: 'https://example.com/license3.jpg',
        identityCardPhoto: 'https://example.com/id3.jpg',
        isVerified: true,
      },
    }),
    prisma.driver.create({
      data: {
        userId: driverUsers[3].id,
        licenseNumber: 'B2-004567890',
        licenseExpiry: new Date('2026-09-20'),
        status: DriverStatus.OFFLINE,
        rating: 4.6,
        totalTrips: 145,
        currentLat: 10.7626,
        currentLng: 106.6820,
        licensePhoto: 'https://example.com/license4.jpg',
        identityCardPhoto: 'https://example.com/id4.jpg',
        isVerified: true,
      },
    }),
  ]);

  console.log('✅ Đã tạo drivers');

  // ============= TẠO VEHICLES =============
  console.log('🚙 Tạo vehicles...');

  const vehicles = await Promise.all([
    prisma.vehicle.create({
      data: {
        driverId: drivers[2].id,
        type: VehicleType.BIKE,
        brand: 'Honda',
        model: 'SH Mode',
        year: 2022,
        licensePlate: '59X1-12345',
        color: 'Đỏ',
        seats: 1,
        registrationPhoto: 'https://example.com/reg1.jpg',
        insurancePhoto: 'https://example.com/ins1.jpg',
        photos: ['https://example.com/bike1.jpg'],
        isActive: true,
      },
    }),
    prisma.vehicle.create({
      data: {
        driverId: drivers[0].id,
        type: VehicleType.CAR_4_SEAT,
        brand: 'Toyota',
        model: 'Vios',
        year: 2021,
        licensePlate: '51F-23456',
        color: 'Trắng',
        seats: 4,
        registrationPhoto: 'https://example.com/reg2.jpg',
        insurancePhoto: 'https://example.com/ins2.jpg',
        photos: ['https://example.com/car1.jpg', 'https://example.com/car1b.jpg'],
        isActive: true,
      },
    }),
    prisma.vehicle.create({
      data: {
        driverId: drivers[1].id,
        type: VehicleType.CAR_7_SEAT,
        brand: 'Toyota',
        model: 'Innova',
        year: 2023,
        licensePlate: '51G-34567',
        color: 'Xám',
        seats: 7,
        registrationPhoto: 'https://example.com/reg3.jpg',
        insurancePhoto: 'https://example.com/ins3.jpg',
        photos: ['https://example.com/car2.jpg'],
        isActive: true,
      },
    }),
    prisma.vehicle.create({
      data: {
        driverId: drivers[3].id,
        type: VehicleType.LUXURY_CAR,
        brand: 'Mercedes',
        model: 'E-Class',
        year: 2023,
        licensePlate: '51H-45678',
        color: 'Đen',
        seats: 4,
        registrationPhoto: 'https://example.com/reg4.jpg',
        insurancePhoto: 'https://example.com/ins4.jpg',
        photos: ['https://example.com/luxury1.jpg'],
        isActive: true,
      },
    }),
  ]);

  console.log('✅ Đã tạo vehicles');

  // ============= TẠO PROMOTIONS =============
  console.log('🎁 Tạo promotions...');

  const promotions = await Promise.all([
    prisma.promotion.create({
      data: {
        code: 'WELCOME50',
        title: 'Chào mừng người dùng mới',
        description: 'Giảm 50% cho chuyến đầu tiên',
        type: PromotionType.PERCENTAGE,
        value: 50,
        maxDiscount: 30000,
        minRideAmount: 0,
        maxUsage: 1000,
        maxUsagePerUser: 1,
        currentUsage: 234,
        startDate: new Date('2026-01-01'),
        endDate: new Date('2026-12-31'),
        isActive: true,
      },
    }),
    prisma.promotion.create({
      data: {
        code: 'GIAMGIA20K',
        title: 'Giảm 20k mọi chuyến',
        description: 'Áp dụng cho đơn từ 50k',
        type: PromotionType.FIXED,
        value: 20000,
        minRideAmount: 50000,
        maxUsage: 5000,
        maxUsagePerUser: 3,
        currentUsage: 1523,
        startDate: new Date('2026-01-01'),
        endDate: new Date('2026-03-31'),
        isActive: true,
      },
    }),
    prisma.promotion.create({
      data: {
        code: 'TET2026',
        title: 'Khuyến mãi Tết 2026',
        description: 'Giảm 30% tối đa 100k',
        type: PromotionType.PERCENTAGE,
        value: 30,
        maxDiscount: 100000,
        minRideAmount: 100000,
        maxUsage: 10000,
        maxUsagePerUser: 5,
        currentUsage: 3421,
        startDate: new Date('2026-01-15'),
        endDate: new Date('2026-02-15'),
        isActive: true,
      },
    }),
  ]);

  console.log('✅ Đã tạo promotions');

  // ============= TẠO RIDES =============
  console.log('🚖 Tạo rides...');

  const now = new Date();

  const completedRide = await prisma.ride.create({
    data: {
      customerId: customers[0].id,
      driverId: drivers[0].id,
      vehicleId: vehicles[1].id,
      pickupAddress: '123 Nguyễn Huệ, Quận 1, TP.HCM',
      pickupLat: 10.8231,
      pickupLng: 106.6297,
      dropoffAddress: '456 Lê Lợi, Quận 3, TP.HCM',
      dropoffLat: 10.7769,
      dropoffLng: 106.7009,
      status: RideStatus.COMPLETED,
      vehicleType: VehicleType.CAR_4_SEAT,
      distance: 5.2,
      duration: 18,
      baseFare: 15000,
      distanceFare: 26000,
      timeFare: 9000,
      surgeFare: 0,
      discount: 0,
      totalFare: 50000,
      paymentMethod: PaymentMethod.CASH,
      paymentStatus: PaymentStatus.COMPLETED,
      requestedAt: new Date(now.getTime() - 2 * 60 * 60 * 1000),
      acceptedAt: new Date(now.getTime() - 115 * 60 * 1000),
      arrivedAt: new Date(now.getTime() - 110 * 60 * 1000),
      startedAt: new Date(now.getTime() - 105 * 60 * 1000),
      completedAt: new Date(now.getTime() - 87 * 60 * 1000),
    },
  });

  await prisma.rating.create({
    data: {
      rideId: completedRide.id,
      fromUserId: customers[0].id,
      toUserId: driverUsers[0].id,
      rating: 5,
      comment: 'Tài xế lái xe an toàn, nhiệt tình!',
      tags: ['Lịch sự', 'Xe sạch', 'Đúng giờ'],
    },
  });

  await prisma.payment.create({
    data: {
      rideId: completedRide.id,
      amount: 50000,
      method: PaymentMethod.CASH,
      status: PaymentStatus.COMPLETED,
      paidAt: new Date(now.getTime() - 87 * 60 * 1000),
    },
  });

  await prisma.ride.create({
    data: {
      customerId: customers[1].id,
      driverId: drivers[1].id,
      vehicleId: vehicles[2].id,
      pickupAddress: 'Sân bay Tân Sơn Nhất',
      pickupLat: 10.8188,
      pickupLng: 106.6520,
      dropoffAddress: '789 Võ Văn Kiệt, Quận 5, TP.HCM',
      dropoffLat: 10.7542,
      dropoffLng: 106.6820,
      status: RideStatus.STARTED,
      vehicleType: VehicleType.CAR_7_SEAT,
      distance: 8.5,
      duration: 25,
      baseFare: 20000,
      distanceFare: 42500,
      timeFare: 12500,
      surgeFare: 10000,
      discount: 0,
      totalFare: 85000,
      paymentMethod: PaymentMethod.WALLET,
      paymentStatus: PaymentStatus.PENDING,
      requestedAt: new Date(now.getTime() - 30 * 60 * 1000),
      acceptedAt: new Date(now.getTime() - 28 * 60 * 1000),
      arrivedAt: new Date(now.getTime() - 25 * 60 * 1000),
      startedAt: new Date(now.getTime() - 20 * 60 * 1000),
    },
  });

  await prisma.ride.create({
    data: {
      customerId: customers[2].id,
      pickupAddress: '100 Trần Hưng Đạo, Quận 1, TP.HCM',
      pickupLat: 10.7700,
      pickupLng: 106.6952,
      dropoffAddress: '200 Nguyễn Văn Linh, Quận 7, TP.HCM',
      dropoffLat: 10.7320,
      dropoffLng: 106.7218,
      status: RideStatus.SEARCHING,
      vehicleType: VehicleType.BIKE,
      distance: 7.8,
      duration: 20,
      baseFare: 10000,
      distanceFare: 23400,
      timeFare: 0,
      surgeFare: 0,
      discount: 0,
      totalFare: 33400,
      paymentMethod: PaymentMethod.CASH,
      paymentStatus: PaymentStatus.PENDING,
      requestedAt: new Date(now.getTime() - 2 * 60 * 1000),
    },
  });

  console.log('✅ Đã tạo rides');

  // ============= TẠO NOTIFICATIONS =============
  console.log('🔔 Tạo notifications...');

  await Promise.all([
    prisma.notification.create({
      data: {
        userId: customers[0].id,
        title: 'Chuyến đi hoàn thành',
        message: 'Chuyến đi của bạn đã hoàn thành. Cảm ơn bạn đã sử dụng Gogogo!',
        type: 'RIDE_UPDATE',
        data: { rideId: completedRide.id },
        isRead: false,
      },
    }),
    prisma.notification.create({
      data: {
        userId: customers[1].id,
        title: 'Tài xế đang trên đường đến',
        message: 'Tài xế Hoàng Văn Lái đang trên đường đến điểm đón',
        type: 'RIDE_UPDATE',
        isRead: false,
      },
    }),
    prisma.notification.create({
      data: {
        userId: customers[2].id,
        title: 'Khuyến mãi mới!',
        message: 'Sử dụng mã TET2026 để được giảm 30%',
        type: 'PROMOTION',
        data: { promoCode: 'TET2026' },
        isRead: false,
      },
    }),
  ]);

  console.log('✅ Đã tạo notifications');

  // ============= TẠO EARNINGS =============
  console.log('💵 Tạo earnings...');

  const today = new Date();
  await Promise.all(
    drivers.slice(0, 3).map((driver, idx) =>
      prisma.earning.create({
        data: {
          driverId: driver.id,
          totalEarnings: 500000 + idx * 200000,
          commission: 20,
          netEarnings: (500000 + idx * 200000) * 0.8,
          date: today,
          weekNumber: Math.ceil(today.getDate() / 7),
          month: today.getMonth() + 1,
          year: today.getFullYear(),
          totalTrips: 15 + idx * 5,
          totalDistance: 120 + idx * 30,
          totalHours: 8 + idx * 2,
        },
      })
    )
  );

  console.log('✅ Đã tạo earnings\n');

  // ============= SUMMARY =============
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('🎉 SEEDING HOÀN TẤT!');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  
  console.log('📊 TÓM TẮT DỮ LIỆU:\n');
  
  console.log('🔐 RBAC System:');
  console.log(`   • Permissions: ${permissions.length} quyền`);
  console.log(`   • Roles: 8 vai trò`);
  console.log(`     ├─ Super Admin (toàn quyền)`);
  console.log(`     ├─ Admin (quản trị hệ thống)`);
  console.log(`     ├─ Driver Manager (quản lý tài xế)`);
  console.log(`     ├─ Customer Support (hỗ trợ khách hàng)`);
  console.log(`     ├─ Accountant (kế toán)`);
  console.log(`     ├─ Marketing (marketing)`);
  console.log(`     ├─ Driver (tài xế)`);
  console.log(`     └─ Customer (khách hàng)\n`);

  console.log('👥 Business Data:');
  console.log(`   • Users: ${1 + customers.length + driverUsers.length}`);
  console.log(`   • Customers: ${customers.length}`);
  console.log(`   • Drivers: ${drivers.length}`);
  console.log(`   • Vehicles: ${vehicles.length}`);
  console.log(`   • Promotions: ${promotions.length}`);
  console.log(`   • Rides: 3`);
  console.log(`   • Notifications: 3`);
  console.log(`   • Earnings: ${drivers.slice(0, 3).length}\n`);

  console.log('🔑 LOGIN CREDENTIALS:');
  console.log('   Admin:    admin@gogogo.vn / 123456');
  console.log('   Customer: khach1@gmail.com / 123456');
  console.log('   Driver:   taixe1@gmail.com / 123456');
  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
}

main()
  .catch((e) => {
    console.error('❌ Lỗi khi seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
