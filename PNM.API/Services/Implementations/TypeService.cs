using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Type;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class TypeService : ITypeService
{
    private readonly PnmDbContext _context;

    public TypeService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<TypeResponse>> GetAllAsync()
    {
        return await _context.MstTypes
            .Where(x => x.IsActive)
            .OrderBy(x => x.TypeName)
            .Select(x => new TypeResponse
            {
                TypeId = x.TypeId,
                TypeName = x.TypeName
            })
            .ToListAsync();
    }

    public async Task<TypeResponse?> GetByIdAsync(int typeId)
    {
        return await _context.MstTypes
            .Where(x => x.TypeId == typeId && x.IsActive)
            .Select(x => new TypeResponse
            {
                TypeId = x.TypeId,
                TypeName = x.TypeName
            })
            .FirstOrDefaultAsync();
    }

    public async Task<TypeResponse> SaveAsync(TypeRequest request)
    {
        request.TypeName = request.TypeName.Trim();

        bool exists = await _context.MstTypes
            .AnyAsync(x => x.IsActive &&
                           x.TypeName.ToLower() == request.TypeName.ToLower());

        if (exists)
            throw new Exception("Type already exists.");

        var entity = new MstType
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            TypeName = request.TypeName,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
        };

        _context.MstTypes.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.TypeId) ?? new TypeResponse
        {
            TypeId = entity.TypeId,
            TypeName = entity.TypeName
        };
    }

    public async Task<TypeResponse?> UpdateAsync(int typeId, TypeRequest request)
    {
        var entity = await _context.MstTypes
            .FirstOrDefaultAsync(x => x.TypeId == typeId && x.IsActive);

        if (entity == null)
            return null;

        request.TypeName = request.TypeName.Trim();

        bool exists = await _context.MstTypes
            .AnyAsync(x => x.TypeId != typeId &&
                           x.IsActive &&
                           x.TypeName.ToLower() == request.TypeName.ToLower());

        if (exists)
            throw new Exception("Type already exists.");

        entity.TypeName = request.TypeName;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.TypeId);
    }

    public async Task<TypeResponse?> DeleteAsync(int typeId)
    {
        var entity = await _context.MstTypes
            .FirstOrDefaultAsync(x => x.TypeId == typeId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return new TypeResponse
        {
            TypeId = entity.TypeId,
            TypeName = entity.TypeName
        };
    }
}
