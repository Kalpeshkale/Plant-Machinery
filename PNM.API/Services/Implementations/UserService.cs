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

    // ── Project the full user entity to UserResponse ─────────────────────────
    private static UserResponse Map(TblUser x, string? deptName, string? roleName) => new()
    {
        UserId      = x.UserId,
        EmpId       = x.EmpId,
        UserName    = x.UserName,
        DeptId      = x.DeptId,
        DeptName    = deptName,
        RoleId      = x.RoleId,
        RoleName    = roleName,
        FullName    = x.FullName,
        DateOfBirth = x.DateOfBirth,
        Gender      = x.Gender,
        Mobile      = x.Mobile,
        Address     = x.Address,
        AadhaarNo   = x.AadhaarNo,
        LicenseNo   = x.LicenseNo,
        Doj         = x.Doj,
        Status      = x.Status,
        PhotoPath   = x.PhotoPath
    };

    public async Task<List<UserResponse>> GetAllAsync()
    {
        return await _context.TblUsers
            .Include(x => x.Dept)
            .Include(x => x.Role)
            .Where(x => x.IsActive)
            .OrderBy(x => x.FullName ?? x.UserName)
            .Select(x => new UserResponse
            {
                UserId      = x.UserId,
                EmpId       = x.EmpId,
                UserName    = x.UserName,
                DeptId      = x.DeptId,
                DeptName    = x.Dept.DeptName,
                RoleId      = x.RoleId,
                RoleName    = x.Role.Role,
                FullName    = x.FullName,
                DateOfBirth = x.DateOfBirth,
                Gender      = x.Gender,
                Mobile      = x.Mobile,
                Address     = x.Address,
                AadhaarNo   = x.AadhaarNo,
                LicenseNo   = x.LicenseNo,
                Doj         = x.Doj,
                Status      = x.Status,
                PhotoPath   = x.PhotoPath
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
                UserId      = x.UserId,
                EmpId       = x.EmpId,
                UserName    = x.UserName,
                DeptId      = x.DeptId,
                DeptName    = x.Dept.DeptName,
                RoleId      = x.RoleId,
                RoleName    = x.Role.Role,
                FullName    = x.FullName,
                DateOfBirth = x.DateOfBirth,
                Gender      = x.Gender,
                Mobile      = x.Mobile,
                Address     = x.Address,
                AadhaarNo   = x.AadhaarNo,
                LicenseNo   = x.LicenseNo,
                Doj         = x.Doj,
                Status      = x.Status,
                PhotoPath   = x.PhotoPath
            })
            .FirstOrDefaultAsync();
    }

    public async Task<UserResponse> SaveAsync(UserRequest request)
    {
        request.EmpId    = request.EmpId.Trim();
        request.UserName = (request.FullName?.Trim() ?? request.EmpId); // UserName = FullName if provided

        bool exists = await _context.TblUsers
            .AnyAsync(x => x.IsActive && x.EmpId.ToLower() == request.EmpId.ToLower());

        if (exists)
            throw new Exception($"Employee ID '{request.EmpId}' already exists.");

        // Default password = BCrypt hash of EmpId (temporary until login flow is built)
        var passwordHash = !string.IsNullOrWhiteSpace(request.Password)
            ? BCrypt.Net.BCrypt.HashPassword(request.Password)
            : BCrypt.Net.BCrypt.HashPassword(request.EmpId);

        var entity = new TblUser
        {
            UniqueId    = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            DeptId      = request.DeptId,
            RoleId      = request.RoleId,
            EmpId       = request.EmpId,
            UserName    = request.UserName,
            PasswordHash = passwordHash,
            FullName    = request.FullName?.Trim(),
            DateOfBirth = request.DateOfBirth,
            Gender      = request.Gender,
            Mobile      = request.Mobile,
            Address     = request.Address,
            AadhaarNo   = request.AadhaarNo,
            LicenseNo   = request.LicenseNo,
            Doj         = request.Doj,
            Status      = request.Status ?? "Active",
            PhotoPath   = request.PhotoPath,
            IsActive    = true,
            CreatedOn   = DateTime.Now
        };

        _context.TblUsers.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.UserId) ?? new UserResponse
        {
            UserId   = entity.UserId,
            EmpId    = entity.EmpId,
            UserName = entity.UserName,
            RoleId   = entity.RoleId,
            DeptId   = entity.DeptId
        };
    }

    public async Task<UserResponse?> UpdateAsync(int userId, UserRequest request)
    {
        var entity = await _context.TblUsers
            .FirstOrDefaultAsync(x => x.UserId == userId && x.IsActive);

        if (entity == null)
            return null;

        request.EmpId = request.EmpId.Trim();

        bool exists = await _context.TblUsers
            .AnyAsync(x => x.UserId != userId &&
                           x.IsActive &&
                           x.EmpId.ToLower() == request.EmpId.ToLower());

        if (exists)
            throw new Exception($"Employee ID '{request.EmpId}' is already used by another user.");

        entity.DeptId      = request.DeptId;
        entity.RoleId      = request.RoleId;
        entity.EmpId       = request.EmpId;
        entity.UserName    = request.FullName?.Trim() ?? entity.UserName;
        entity.FullName    = request.FullName?.Trim();
        entity.DateOfBirth = request.DateOfBirth;
        entity.Gender      = request.Gender;
        entity.Mobile      = request.Mobile;
        entity.Address     = request.Address;
        entity.AadhaarNo   = request.AadhaarNo;
        entity.LicenseNo   = request.LicenseNo;
        entity.Doj         = request.Doj;
        entity.Status      = request.Status ?? entity.Status;
        entity.PhotoPath   = request.PhotoPath ?? entity.PhotoPath;
        entity.ModifiedOn  = DateTime.Now;

        if (!string.IsNullOrWhiteSpace(request.Password))
            entity.PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password);

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.UserId);
    }

    public async Task<UserResponse?> DeleteAsync(int userId)
    {
        var entity = await _context.TblUsers
            .FirstOrDefaultAsync(x => x.UserId == userId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive   = false;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return new UserResponse
        {
            UserId   = entity.UserId,
            EmpId    = entity.EmpId,
            UserName = entity.UserName,
            RoleId   = entity.RoleId,
            DeptId   = entity.DeptId
        };
    }
}
