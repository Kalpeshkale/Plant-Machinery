using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Department;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class DepartmentService : IDepartmentService
{
    private readonly PnmDbContext _context;

    public DepartmentService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<DepartmentResponse>> GetAllAsync()
    {
        return await _context.MstDepartments
            .Where(x => x.IsActive)
            .OrderBy(x => x.DeptName)
            .Select(x => new DepartmentResponse
            {
                DeptId = x.DeptId,
                DeptName = x.DeptName
            })
            .ToListAsync();
    }

    public async Task<DepartmentResponse?> GetByIdAsync(int deptId)
    {
        return await _context.MstDepartments
            .Where(x => x.DeptId == deptId && x.IsActive)
            .Select(x => new DepartmentResponse
            {
                DeptId = x.DeptId,
                DeptName = x.DeptName
            })
            .FirstOrDefaultAsync();
    }

    public async Task<DepartmentResponse> SaveAsync(DepartmentRequest request)
    {
        request.DeptName = request.DeptName.Trim();

        bool exists = await _context.MstDepartments
            .AnyAsync(x => x.IsActive &&
                           x.DeptName.ToLower() == request.DeptName.ToLower());

        if (exists)
            throw new Exception("Department already exists.");

        var entity = new MstDepartment
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            DeptName = request.DeptName,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
        };

        _context.MstDepartments.Add(entity);
        await _context.SaveChangesAsync();

        return new DepartmentResponse
        {
            DeptId = entity.DeptId,
            DeptName = entity.DeptName
        };
    }

    public async Task<DepartmentResponse?> UpdateAsync(int deptId, DepartmentRequest request)
    {
        var entity = await _context.MstDepartments
            .FirstOrDefaultAsync(x => x.DeptId == deptId && x.IsActive);

        if (entity == null)
            return null;

        request.DeptName = request.DeptName.Trim();

        bool exists = await _context.MstDepartments
            .AnyAsync(x => x.DeptId != deptId &&
                           x.IsActive &&
                           x.DeptName.ToLower() == request.DeptName.ToLower());

        if (exists)
            throw new Exception("Department already exists.");

        entity.DeptName = request.DeptName;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return new DepartmentResponse
        {
            DeptId = entity.DeptId,
            DeptName = entity.DeptName
        };
    }

    public async Task<DepartmentResponse?> DeleteAsync(int deptId)
    {
        var entity = await _context.MstDepartments
            .FirstOrDefaultAsync(x => x.DeptId == deptId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return new DepartmentResponse
        {
            DeptId = entity.DeptId,
            DeptName = entity.DeptName
        };
    }
}
