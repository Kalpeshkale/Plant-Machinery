using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Role;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class RoleService : IRoleService
{
    private readonly PnmDbContext _context;

    public RoleService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<RoleResponse>> GetAllAsync()
    {
        return await _context.MstRoles
            .Where(x => x.IsActive)
            .OrderBy(x => x.Role)
            .Select(x => new RoleResponse
            {
                RoleId = x.RoleId,
                Role = x.Role,
                RoleDesc = x.RoleDesc
            })
            .ToListAsync();
    }

    public async Task<RoleResponse?> GetByIdAsync(int roleId)
    {
        return await _context.MstRoles
            .Where(x => x.RoleId == roleId && x.IsActive)
            .Select(x => new RoleResponse
            {
                RoleId = x.RoleId,
                Role = x.Role,
                RoleDesc = x.RoleDesc
            })
            .FirstOrDefaultAsync();
    }

    public async Task<RoleResponse> SaveAsync(RoleRequest request)
    {
        request.Role = request.Role.Trim();

        bool exists = await _context.MstRoles
            .AnyAsync(x => x.IsActive &&
                           x.Role.ToLower() == request.Role.ToLower());

        if (exists)
            throw new Exception("Role already exists.");

        var entity = new MstRole
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            Role = request.Role,
            RoleDesc = request.RoleDesc,
            IsActive = true,
            CreatedDate = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstRoles.Add(entity);
        await _context.SaveChangesAsync();

        return new RoleResponse
        {
            RoleId = entity.RoleId,
            Role = entity.Role,
            RoleDesc = entity.RoleDesc
        };
    }

    public async Task<RoleResponse?> UpdateAsync(int roleId, RoleRequest request)
    {
        var entity = await _context.MstRoles
            .FirstOrDefaultAsync(x => x.RoleId == roleId && x.IsActive);

        if (entity == null)
            return null;

        request.Role = request.Role.Trim();

        bool exists = await _context.MstRoles
            .AnyAsync(x => x.RoleId != roleId &&
                           x.IsActive &&
                           x.Role.ToLower() == request.Role.ToLower());

        if (exists)
            throw new Exception("Role already exists.");

        entity.Role = request.Role;
        entity.RoleDesc = request.RoleDesc;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new RoleResponse
        {
            RoleId = entity.RoleId,
            Role = entity.Role,
            RoleDesc = entity.RoleDesc
        };
    }

    public async Task<RoleResponse?> DeleteAsync(int roleId)
    {
        var entity = await _context.MstRoles
            .FirstOrDefaultAsync(x => x.RoleId == roleId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new RoleResponse
        {
            RoleId = entity.RoleId,
            Role = entity.Role,
            RoleDesc = entity.RoleDesc
        };
    }
}