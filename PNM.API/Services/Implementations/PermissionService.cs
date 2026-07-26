using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Permission;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PNM.Service.Services.Implementations
{
    public class PermissionService : IPermissionService
    {
        private readonly PnmDbContext _context;

        public PermissionService(PnmDbContext context)
        {
            _context = context;
        }

        public async Task<List<MenuPermissionResponse>> GetUserMenuPermissionsAsync(int userId)
        {
            var user = await _context.TblUsers
                .FirstOrDefaultAsync(x => x.UserId == userId && x.IsActive);

            int roleId = user != null ? user.RoleId : userId;

            var rolePermissionIds = await _context.TblLeftMenus
                .Where(x => x.MenuName == roleId && x.IsActive)
                .Select(x => x.MenuDesc)
                .ToListAsync();

            var userOverrides = await _context.TblMenuAccesses
                .Where(x => x.EmployeeId == userId)
                .ToListAsync();

            var overrideDict = userOverrides
                .Where(x => x.IsActive.HasValue)
                .ToDictionary(x => x.PermissionKey, x => x.IsActive!.Value);

            var allPermissions = await _context.TblMenuPermissions
                .Where(x => x.IsActive)
                .ToListAsync();

            var allowedPermissions = new List<TblMenuPermission>();

            foreach (var p in allPermissions)
            {
                if (overrideDict.TryGetValue(p.PerKey, out bool hasOverrideAccess))
                {
                    if (hasOverrideAccess)
                    {
                        allowedPermissions.Add(p);
                    }
                }
                else
                {
                    if (rolePermissionIds.Contains(p.Id))
                    {
                        allowedPermissions.Add(p);
                    }
                }
            }

            return allowedPermissions
                .OrderBy(x => x.SortOrder)
                .ThenBy(x => x.MenuName)
                .Select(x => new MenuPermissionResponse
                {
                    Id = x.Id,
                    UniqueId = x.UniqueId,
                    PerKey = x.PerKey,
                    MenuName = x.MenuName,
                    SortOrder = x.SortOrder,
                    ParentKey = x.ParentKey,
                    MenuType = x.MenuType,
                    ViewName = x.ViewName,
                    IconClass = x.IconClass,
                    IsVisible = x.IsVisible
                })
                .ToList();
        }

        public async Task<List<MenuPermissionResponse>> GetAllMenuPermissionsAsync()
        {
            return await _context.TblMenuPermissions
                .Where(x => x.IsActive)
                .OrderBy(x => x.SortOrder)
                .ThenBy(x => x.MenuName)
                .Select(x => new MenuPermissionResponse
                {
                    Id = x.Id,
                    UniqueId = x.UniqueId,
                    PerKey = x.PerKey,
                    MenuName = x.MenuName,
                    SortOrder = x.SortOrder,
                    ParentKey = x.ParentKey,
                    MenuType = x.MenuType,
                    ViewName = x.ViewName,
                    IconClass = x.IconClass,
                    IsVisible = x.IsVisible
                })
                .ToListAsync();
        }

        public async Task<bool> SaveRoleMenuAccessAsync(RoleMenuAccessRequest request)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var existing = await _context.TblLeftMenus
                    .Where(x => x.MenuName == request.RoleId)
                    .ToListAsync();

                var toRemove = existing
                    .Where(x => !request.PermissionIds.Contains(x.MenuDesc));

                _context.TblLeftMenus.RemoveRange(toRemove);

                var existingPermissionIds = existing.Select(x => x.MenuDesc).ToHashSet();

                foreach (var perId in request.PermissionIds)
                {
                    if (!existingPermissionIds.Contains(perId))
                    {
                        var entry = new TblLeftMenu
                        {
                            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
                            MenuName = request.RoleId,
                            MenuDesc = perId,
                            IsActive = true,
                            CreatedOn = DateTime.Now
                        };
                        _context.TblLeftMenus.Add(entry);
                    }
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                return true;
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<bool> SaveEmployeeMenuAccessAsync(EmployeeMenuAccessRequest request)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var existing = await _context.TblMenuAccesses
                    .Where(x => x.EmployeeId == request.EmployeeId)
                    .ToListAsync();

                _context.TblMenuAccesses.RemoveRange(existing);

                foreach (var ovr in request.Overrides)
                {
                    var entry = new TblMenuAccess
                    {
                        EmployeeId = request.EmployeeId,
                        PermissionKey = ovr.PermissionKey,
                        IsActive = ovr.IsActive,
                        CreatedDate = DateTime.Now
                    };
                    _context.TblMenuAccesses.Add(entry);
                }

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();
                return true;
            }
            catch (Exception)
            {
                await transaction.RollbackAsync();
                throw;
            }
        }

        public async Task<MenuPermissionResponse> SaveMenuPermissionAsync(MenuPermissionRequest request)
        {
            var exists = await _context.TblMenuPermissions
                .AnyAsync(x => x.PerKey.ToLower() == request.PerKey.ToLower() && x.IsActive);

            if (exists)
                throw new Exception("Permission key already exists.");

            var entity = new TblMenuPermission
            {
                UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
                PerKey = request.PerKey,
                MenuName = request.MenuName,
                SortOrder = request.SortOrder,
                ParentKey = request.ParentKey,
                MenuType = request.MenuType,
                ViewName = request.ViewName,
                IconClass = request.IconClass,
                IsVisible = request.IsVisible,
                IsActive = true
            };

            _context.TblMenuPermissions.Add(entity);
            await _context.SaveChangesAsync();

            return new MenuPermissionResponse
            {
                Id = entity.Id,
                UniqueId = entity.UniqueId,
                PerKey = entity.PerKey,
                MenuName = entity.MenuName,
                SortOrder = entity.SortOrder,
                ParentKey = entity.ParentKey,
                MenuType = entity.MenuType,
                ViewName = entity.ViewName,
                IconClass = entity.IconClass,
                IsVisible = entity.IsVisible
            };
        }

        public async Task<MenuPermissionResponse?> UpdateMenuPermissionAsync(int id, MenuPermissionRequest request)
        {
            var entity = await _context.TblMenuPermissions
                .FirstOrDefaultAsync(x => x.Id == id && x.IsActive);

            if (entity == null)
                return null;

            entity.PerKey = request.PerKey;
            entity.MenuName = request.MenuName;
            entity.SortOrder = request.SortOrder;
            entity.ParentKey = request.ParentKey;
            entity.MenuType = request.MenuType;
            entity.ViewName = request.ViewName;
            entity.IconClass = request.IconClass;
            entity.IsVisible = request.IsVisible;

            await _context.SaveChangesAsync();

            return new MenuPermissionResponse
            {
                Id = entity.Id,
                UniqueId = entity.UniqueId,
                PerKey = entity.PerKey,
                MenuName = entity.MenuName,
                SortOrder = entity.SortOrder,
                ParentKey = entity.ParentKey,
                MenuType = entity.MenuType,
                ViewName = entity.ViewName,
                IconClass = entity.IconClass,
                IsVisible = entity.IsVisible
            };
        }

        public async Task<MenuPermissionResponse?> DeleteMenuPermissionAsync(int id)
        {
            var entity = await _context.TblMenuPermissions
                .FirstOrDefaultAsync(x => x.Id == id && x.IsActive);

            if (entity == null)
                return null;

            entity.IsActive = false;

            await _context.SaveChangesAsync();

            return new MenuPermissionResponse
            {
                Id = entity.Id,
                UniqueId = entity.UniqueId,
                PerKey = entity.PerKey,
                MenuName = entity.MenuName,
                SortOrder = entity.SortOrder,
                ParentKey = entity.ParentKey,
                MenuType = entity.MenuType,
                ViewName = entity.ViewName,
                IconClass = entity.IconClass,
                IsVisible = entity.IsVisible
            };
        }
    }
}
