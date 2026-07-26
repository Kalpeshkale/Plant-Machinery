using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Make;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class MakeService : IMakeService
{
    private readonly PnmDbContext _context;

    public MakeService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<MakeResponse>> GetAllAsync()
    {
        return await (
            from x in _context.MstMakes
            join s in _context.MstSubTypes on x.SubTypeId equals s.SubTypeId into subTypeJoin
            from s in subTypeJoin.DefaultIfEmpty()
            where x.IsActive
            orderby x.MakeName
            select new MakeResponse
            {
                MakeId = x.MakeId,
                SubTypeId = x.SubTypeId,
                SubTypeName = s != null ? s.SubTypeName : null,
                MakeName = x.MakeName
            })
            .ToListAsync();
    }

    public async Task<MakeResponse?> GetByIdAsync(int makeId)
    {
        return await (
            from x in _context.MstMakes
            join s in _context.MstSubTypes on x.SubTypeId equals s.SubTypeId into subTypeJoin
            from s in subTypeJoin.DefaultIfEmpty()
            where x.MakeId == makeId && x.IsActive
            select new MakeResponse
            {
                MakeId = x.MakeId,
                SubTypeId = x.SubTypeId,
                SubTypeName = s != null ? s.SubTypeName : null,
                MakeName = x.MakeName
            })
            .FirstOrDefaultAsync();
    }

    public async Task<MakeResponse> SaveAsync(MakeRequest request)
    {
        request.MakeName = request.MakeName.Trim();

        bool exists = await _context.MstMakes
            .AnyAsync(x => x.IsActive &&
                           x.MakeName.ToLower() == request.MakeName.ToLower());

        if (exists)
            throw new Exception("Make already exists.");

        var entity = new MstMake
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            SubTypeId = request.SubTypeId,
            MakeName = request.MakeName,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstMakes.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.MakeId) ?? new MakeResponse
        {
            MakeId = entity.MakeId,
            SubTypeId = entity.SubTypeId,
            MakeName = entity.MakeName
        };
    }

    public async Task<MakeResponse?> UpdateAsync(int makeId, MakeRequest request)
    {
        var entity = await _context.MstMakes
            .FirstOrDefaultAsync(x => x.MakeId == makeId && x.IsActive);

        if (entity == null)
            return null;

        request.MakeName = request.MakeName.Trim();

        bool exists = await _context.MstMakes
            .AnyAsync(x => x.MakeId != makeId &&
                           x.IsActive &&
                           x.MakeName.ToLower() == request.MakeName.ToLower());

        if (exists)
            throw new Exception("Make already exists.");

        entity.SubTypeId = request.SubTypeId;
        entity.MakeName = request.MakeName;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.MakeId);
    }

    public async Task<MakeResponse?> DeleteAsync(int makeId)
    {
        var entity = await _context.MstMakes
            .FirstOrDefaultAsync(x => x.MakeId == makeId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new MakeResponse
        {
            MakeId = entity.MakeId,
            SubTypeId = entity.SubTypeId,
            MakeName = entity.MakeName
        };
    }
}
