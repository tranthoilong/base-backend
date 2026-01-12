-- RemoveUserRoleEnum
-- Migration để xóa enum UserRole và column role từ bảng users
-- Chuyển sang sử dụng RBAC system qua bảng roles và user_roles

-- Bước 1: Xóa column role từ bảng users (nếu tồn tại)
DO $$ 
BEGIN
    -- Kiểm tra xem bảng users có tồn tại không
    IF EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name = 'users'
    ) THEN
        -- Kiểm tra xem column role có tồn tại không
        IF EXISTS (
            SELECT 1 
            FROM information_schema.columns 
            WHERE table_schema = 'public' 
            AND table_name = 'users' 
            AND column_name = 'role'
        ) THEN
            ALTER TABLE "users" DROP COLUMN "role";
        END IF;
    END IF;
END $$;

-- Bước 2: Xóa enum UserRole (nếu tồn tại)
DO $$ 
BEGIN
    -- Kiểm tra xem enum có tồn tại không
    IF EXISTS (
        SELECT 1 
        FROM pg_type 
        WHERE typname = 'UserRole'
    ) THEN
        -- Xóa enum (chỉ khi không còn sử dụng)
        DROP TYPE "UserRole";
    END IF;
END $$;
