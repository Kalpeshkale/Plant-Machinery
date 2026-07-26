using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.OwnerType;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class OwnerTypeService : IOwnerTypeService
{
    private readonly PnmDbContext _context;

    public OwnerTypeService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<OwnerTypeResponse>> GetAllAsync()
    {
        return await _context.MstOwnerTypes
            .Where(x => x.IsActive)
            .OrderBy(x => x.SortOrder)
            .Select(x => new OwnerTypeResponse
            {
                OwnerId = x.OwnerId,
                OwnerType = x.OwnerType,
                SortOrder = x.SortOrder
            })
            .ToListAsync();
    }

    public async Task<OwnerTypeResponse?> GetByIdAsync(int ownerId)
    {
        return await _context.MstOwnerTypes
            .Where(x => x.OwnerId == ownerId && x.IsActive)
            .Select(x => new OwnerTypeResponse
            {
                OwnerId = x.OwnerId,
                OwnerType = x.OwnerType,
                SortOrder = x.SortOrder
            })
            .FirstOrDefaultAsync();
    }

    public async Task<OwnerTypeResponse> SaveAsync(OwnerTypeRequest request)
    {
        request.OwnerType = request.OwnerType.Trim();

        bool exists = await _context.MstOwnerTypes
            .AnyAsync(x => x.IsActive &&
                           x.OwnerType.ToLower() == request.OwnerType.ToLower());

        if (exists)
            throw new Exception("Ownership type already exists.");

        var entity = new MstOwnerType
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            OwnerType = request.OwnerType,
            SortOrder = request.SortOrder,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstOwnerTypes.Add(entity);
        await _context.SaveChangesAsync();

        return new OwnerTypeResponse
        {
            OwnerId = entity.OwnerId,
            OwnerType = entity.OwnerType,
            SortOrder = entity.SortOrder
        };
    }

    public async Task<OwnerTypeResponse?> UpdateAsync(int ownerId, OwnerTypeRequest request)
    {
        var entity = await _context.MstOwnerTypes
            .FirstOrDefaultAsync(x => x.OwnerId == ownerId && x.IsActive);

        if (entity == null)
            return null;

        request.OwnerType = request.OwnerType.Trim();

        bool exists = await _context.MstOwnerTypes
            .AnyAsync(x => x.OwnerId != ownerId &&
                           x.IsActive &&
                           x.OwnerType.ToLower() == request.OwnerType.ToLower());

        if (exists)
            throw new Exception("Ownership type already exists.");

        entity.OwnerType = request.OwnerType;
        entity.SortOrder = request.SortOrder;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new OwnerTypeResponse
        {
            OwnerId = entity.OwnerId,
            OwnerType = entity.OwnerType,
            SortOrder = entity.SortOrder
        };
    }

    public async Task<OwnerTypeResponse?> DeleteAsync(int ownerId)
    {
        var entity = await _context.MstOwnerTypes
            .FirstOrDefaultAsync(x => x.OwnerId == ownerId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new OwnerTypeResponse
        {
            OwnerId = entity.OwnerId,
            OwnerType = entity.OwnerType,
            SortOrder = entity.SortOrder
        };
    }
}
