// /**
//  * Prisma Types & Utilities
//  *
//  * Common types and utilities for working with Prisma models
//  */

// import {
//   User,
//   // Organization, // Removed - organization models removed
//   Role,
//   Permission,
//   UserRole,
//   RolePermission,
// } from '@prisma/client';

// // ============================================
// // Base Types
// // ============================================

// export type UserWithRelations = User & {
//   // organization?: Organization | null; // Removed - organization models removed
//   roles?: (UserRole & {
//     role: Role;
//   })[];
// };

// // Removed - organization models removed
// // export type OrganizationWithUsers = Organization & {
// //   users?: User[];
// //   _count?: {
// //     users: number;
// //   };
// // };

// export type RoleWithPermissions = Role & {
//   permissions?: (RolePermission & {
//     permission: Permission;
//   })[];
//   users?: UserRole[];
//   _count?: {
//     users: number;
//   };
// };

// export type PermissionWithRoles = Permission & {
//   roles?: (RolePermission & {
//     role: Role;
//   })[];
// };

// // ============================================
// // Soft Delete Types
// // ============================================

// export type SoftDeletable = {
//   deletedAt: Date | null;
// };

// export type SoftDeleteFilter<T extends SoftDeletable> = {
//   deletedAt: null;
// } & Partial<T>;

// // ============================================
// // Pagination Types
// // ============================================

// export interface PaginationParams {
//   page?: number;
//   perPage?: number;
//   skip?: number;
//   take?: number;
// }

// export interface PaginationResult<T> {
//   data: T[];
//   total: number;
//   page: number;
//   perPage: number;
//   totalPages: number;
// }

// // ============================================
// // Query Helpers
// // ============================================

// export const createPaginationParams = (
//   page: number = 1,
//   perPage: number = 10,
// ): { skip: number; take: number } => {
//   return {
//     skip: (page - 1) * perPage,
//     take: perPage,
//   };
// };

// export const createSoftDeleteFilter = () => ({
//   deletedAt: null,
// });
