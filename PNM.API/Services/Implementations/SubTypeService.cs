using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.SubType;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class SubTypeService : ISubTypeService
{
    private readonly PnmDbContext _context;

    public SubTypeService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<SubTypeResponse>> GetAllAsync()
    {
        return await (
            from x in _context.MstSubTypes
            join t in _context.MstTypes on x.TypeId equals t.TypeId into typeJoin
            from t in typeJoin.DefaultIfEmpty()
            where x.IsActive
            orderby x.SubTypeName
            select new SubTypeResponse
            {
                SubTypeId = x.SubTypeId,
                TypeId = x.TypeId,
                TypeName = t != null ? t.TypeName : null,
                SubTypeName = x.SubTypeName,
                AssetUnit = x.AssetUnit,
                OutputUnit = x.OutputUnit,
                FuelType = x.FuelType,
                FuelUnit = x.FuelUnit
            })
            .ToListAsync();
    }

    public async Task<SubTypeResponse?> GetByIdAsync(int subTypeId)
    {
        return await (
            from x in _context.MstSubTypes
            join t in _context.MstTypes on x.TypeId equals t.TypeId into typeJoin
            from t in typeJoin.DefaultIfEmpty()
            where x.SubTypeId == subTypeId && x.IsActive
            select new SubTypeResponse
            {
                SubTypeId = x.SubTypeId,
                TypeId = x.TypeId,
                TypeName = t != null ? t.TypeName : null,
                SubTypeName = x.SubTypeName,
                AssetUnit = x.AssetUnit,
                OutputUnit = x.OutputUnit,
                FuelType = x.FuelType,
                FuelUnit = x.FuelUnit
            })
            .FirstOrDefaultAsync();
    }

    public async Task<SubTypeResponse> SaveAsync(SubTypeRequest request)
    {
        request.SubTypeName = request.SubTypeName.Trim();

        bool exists = await _context.MstSubTypes
            .AnyAsync(x => x.IsActive &&
                           x.SubTypeName.ToLower() == request.SubTypeName.ToLower());

        if (exists)
            throw new Exception("SubType already exists.");

        var entity = new MstSubType
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            TypeId = request.TypeId,
            SubTypeName = request.SubTypeName,
            AssetUnit = request.AssetUnit,
            OutputUnit = request.OutputUnit,
            FuelType = request.FuelType,
            FuelUnit = request.FuelUnit,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstSubTypes.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.SubTypeId) ?? new SubTypeResponse
        {
            SubTypeId = entity.SubTypeId,
            TypeId = entity.TypeId,
            SubTypeName = entity.SubTypeName,
            AssetUnit = entity.AssetUnit,
            OutputUnit = entity.OutputUnit,
            FuelType = entity.FuelType,
            FuelUnit = entity.FuelUnit
        };
    }

    public async Task<SubTypeResponse?> UpdateAsync(int subTypeId, SubTypeRequest request)
    {
        var entity = await _context.MstSubTypes
            .FirstOrDefaultAsync(x => x.SubTypeId == subTypeId && x.IsActive);

        if (entity == null)
            return null;

        request.SubTypeName = request.SubTypeName.Trim();

        bool exists = await _context.MstSubTypes
            .AnyAsync(x => x.SubTypeId != subTypeId &&
                           x.IsActive &&
                           x.SubTypeName.ToLower() == request.SubTypeName.ToLower());

        if (exists)
            throw new Exception("SubType already exists.");

        entity.TypeId = request.TypeId;
        entity.SubTypeName = request.SubTypeName;
        entity.AssetUnit = request.AssetUnit;
        entity.OutputUnit = request.OutputUnit;
        entity.FuelType = request.FuelType;
        entity.FuelUnit = request.FuelUnit;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.SubTypeId);
    }

    public async Task<SubTypeResponse?> DeleteAsync(int subTypeId)
    {
        var entity = await _context.MstSubTypes
            .FirstOrDefaultAsync(x => x.SubTypeId == subTypeId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new SubTypeResponse
        {
            SubTypeId = entity.SubTypeId,
            TypeId = entity.TypeId,
            SubTypeName = entity.SubTypeName,
            AssetUnit = entity.AssetUnit,
            OutputUnit = entity.OutputUnit,
            FuelType = entity.FuelType,
            FuelUnit = entity.FuelUnit
        };
    }
}
