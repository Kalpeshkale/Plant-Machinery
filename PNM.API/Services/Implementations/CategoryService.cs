using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Category;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class CategoryService : ICategoryService
{
    private readonly PnmDbContext _context;

    public CategoryService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<CategoryResponse>> GetAllAsync()
    {
        return await (
            from x in _context.MstCategories
            join d in _context.MstDepartments on x.DeptId equals d.DeptId into deptJoin
            from d in deptJoin.DefaultIfEmpty()
            where x.IsActive
            orderby x.CatName
            select new CategoryResponse
            {
                CatId = x.CatId,
                DeptId = x.DeptId,
                DeptName = d != null ? d.DeptName : null,
                CatName = x.CatName ?? string.Empty
            })
            .ToListAsync();
    }

    public async Task<CategoryResponse?> GetByIdAsync(int catId)
    {
        return await (
            from x in _context.MstCategories
            join d in _context.MstDepartments on x.DeptId equals d.DeptId into deptJoin
            from d in deptJoin.DefaultIfEmpty()
            where x.CatId == catId && x.IsActive
            select new CategoryResponse
            {
                CatId = x.CatId,
                DeptId = x.DeptId,
                DeptName = d != null ? d.DeptName : null,
                CatName = x.CatName ?? string.Empty
            })
            .FirstOrDefaultAsync();
    }

    public async Task<CategoryResponse> SaveAsync(CategoryRequest request)
    {
        request.CatName = request.CatName.Trim();

        bool exists = await _context.MstCategories
            .AnyAsync(x => x.IsActive &&
                           x.CatName != null &&
                           x.CatName.ToLower() == request.CatName.ToLower());

        if (exists)
            throw new Exception("Category already exists.");

        var entity = new MstCategory
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            DeptId = request.DeptId,
            CatName = request.CatName,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstCategories.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.CatId) ?? new CategoryResponse
        {
            CatId = entity.CatId,
            DeptId = entity.DeptId,
            CatName = entity.CatName ?? string.Empty
        };
    }

    public async Task<CategoryResponse?> UpdateAsync(int catId, CategoryRequest request)
    {
        var entity = await _context.MstCategories
            .FirstOrDefaultAsync(x => x.CatId == catId && x.IsActive);

        if (entity == null)
            return null;

        request.CatName = request.CatName.Trim();

        bool exists = await _context.MstCategories
            .AnyAsync(x => x.CatId != catId &&
                           x.IsActive &&
                           x.CatName != null &&
                           x.CatName.ToLower() == request.CatName.ToLower());

        if (exists)
            throw new Exception("Category already exists.");

        entity.DeptId = request.DeptId;
        entity.CatName = request.CatName;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.CatId);
    }

    public async Task<CategoryResponse?> DeleteAsync(int catId)
    {
        var entity = await _context.MstCategories
            .FirstOrDefaultAsync(x => x.CatId == catId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new CategoryResponse
        {
            CatId = entity.CatId,
            DeptId = entity.DeptId,
            CatName = entity.CatName ?? string.Empty
        };
    }
}
