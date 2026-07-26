using BCrypt.Net;
using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.User;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class UserService : IUserService
{
    private readonly PnmDbContext _context;

    public UserService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<UserResponse>> GetAllAsync()
    {
        return await _context.TblUsers
            .Include(x => x.Dept)
            .Include(x => x.Role)
            .Where(x => x.IsActive)
            .OrderBy(x => x.UserName)
            .Select(x => new UserResponse
            {
                UserId = x.UserId,
                DeptId = x.DeptId,
                DeptName = x.Dept.DeptName,
                RoleId = x.RoleId,
                RoleName = x.Role.Role,
                EmpId = x.EmpId,
                UserName = x.UserName
            })
            .ToListAsync();
    }

    public async Task<UserResponse?> GetByIdAsync(int userId)
    {
        return await _context.TblUsers
            .Include(x => x.Dept)
            .Include(x => x.Role)
            .Where(x => x.UserId == userId && x.IsActive)
            .Select(x => new UserResponse
            {
                UserId = x.UserId,
                DeptId = x.DeptId,
                DeptName = x.Dept.DeptName,
                RoleId = x.RoleId,
                RoleName = x.Role.Role,
                EmpId = x.EmpId,
                UserName = x.UserName
            })
            .FirstOrDefaultAsync();
    }

    public async Task<UserResponse> SaveAsync(UserRequest request)
    {
        request.EmpId = request.EmpId.Trim();
        request.UserName = request.UserName.Trim();

        bool exists = await _context.TblUsers
            .AnyAsync(x => x.IsActive &&
                           (x.EmpId.ToLower() == request.EmpId.ToLower() ||
                            x.UserName.ToLower() == request.UserName.ToLower()));

        if (exists)
            throw new Exception("User already exists.");

        if (string.IsNullOrWhiteSpace(request.Password))
            throw new Exception("Password is required.");

        var entity = new TblUser
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            DeptId = request.DeptId,
            RoleId = request.RoleId,
            EmpId = request.EmpId,
            UserName = request.UserName,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
            IsActive = true,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.TblUsers.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.UserId) ?? new UserResponse
        {
            UserId = entity.UserId,
            DeptId = entity.DeptId,
            RoleId = entity.RoleId,
            EmpId = entity.EmpId,
            UserName = entity.UserName
        };
    }

    public async Task<UserResponse?> UpdateAsync(int userId, UserRequest request)
    {
        var entity = await _context.TblUsers
            .FirstOrDefaultAsync(x => x.UserId == userId && x.IsActive);

        if (entity == null)
            return null;

        request.EmpId = request.EmpId.Trim();
        request.UserName = request.UserName.Trim();

        bool exists = await _context.TblUsers
            .AnyAsync(x => x.UserId != userId &&
                           x.IsActive &&
                           (x.EmpId.ToLower() == request.EmpId.ToLower() ||
                            x.UserName.ToLower() == request.UserName.ToLower()));

        if (exists)
            throw new Exception("User already exists.");

        entity.DeptId = request.DeptId;
        entity.RoleId = request.RoleId;
        entity.EmpId = request.EmpId;
        entity.UserName = request.UserName;

        if (!string.IsNullOrWhiteSpace(request.Password))
            entity.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.UserId);
    }

    public async Task<UserResponse?> DeleteAsync(int userId)
    {
        var entity = await _context.TblUsers
            .FirstOrDefaultAsync(x => x.UserId == userId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new UserResponse
        {
            UserId = entity.UserId,
            DeptId = entity.DeptId,
            RoleId = entity.RoleId,
            EmpId = entity.EmpId,
            UserName = entity.UserName
        };
    }
}
