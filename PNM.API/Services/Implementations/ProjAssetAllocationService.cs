using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.ProjAssetAllocation;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class ProjAssetAllocationService : IProjAssetAllocationService
{
    private readonly PnmDbContext _context;

    public ProjAssetAllocationService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<ProjAssetAllocationResponse>> GetAllAsync()
    {
        return await _context.TblProjAssetAllocations
            .Include(x => x.Proj)
            .Include(x => x.Asset)
            .Where(x => x.IsActive)
            .OrderByDescending(x => x.AllocationDate)
            .Select(x => new ProjAssetAllocationResponse
            {
                ProjAssetAllocId = x.ProjAssetAllocId,
                ProjId = x.ProjId,
                ProjName = x.Proj.ProjName,
                AssetId = x.AssetId,
                AssetName = x.Asset.AssetName,
                AllocationDate = x.AllocationDate,
                ReleaseDate = x.ReleaseDate,
                Remarks = x.Remarks
            })
            .ToListAsync();
    }

    public async Task<ProjAssetAllocationResponse?> GetByIdAsync(int projAssetAllocId)
    {
        return await _context.TblProjAssetAllocations
            .Include(x => x.Proj)
            .Include(x => x.Asset)
            .Where(x => x.ProjAssetAllocId == projAssetAllocId && x.IsActive)
            .Select(x => new ProjAssetAllocationResponse
            {
                ProjAssetAllocId = x.ProjAssetAllocId,
                ProjId = x.ProjId,
                ProjName = x.Proj.ProjName,
                AssetId = x.AssetId,
                AssetName = x.Asset.AssetName,
                AllocationDate = x.AllocationDate,
                ReleaseDate = x.ReleaseDate,
                Remarks = x.Remarks
            })
            .FirstOrDefaultAsync();
    }

    public async Task<ProjAssetAllocationResponse> SaveAsync(ProjAssetAllocationRequest request)
    {
        bool exists = await _context.TblProjAssetAllocations
            .AnyAsync(x => x.IsActive &&
                           x.AssetId == request.AssetId &&
                           x.ReleaseDate == null);

        if (exists)
            throw new Exception("Asset is already allocated to a project and not yet released.");

        var entity = new TblProjAssetAllocation
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            ProjId = request.ProjId,
            AssetId = request.AssetId,
            AllocationDate = request.AllocationDate,
            ReleaseDate = request.ReleaseDate,
            Remarks = request.Remarks,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.TblProjAssetAllocations.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ProjAssetAllocId) ?? new ProjAssetAllocationResponse
        {
            ProjAssetAllocId = entity.ProjAssetAllocId,
            ProjId = entity.ProjId,
            AssetId = entity.AssetId,
            AllocationDate = entity.AllocationDate,
            ReleaseDate = entity.ReleaseDate,
            Remarks = entity.Remarks
        };
    }

    public async Task<ProjAssetAllocationResponse?> UpdateAsync(int projAssetAllocId, ProjAssetAllocationRequest request)
    {
        var entity = await _context.TblProjAssetAllocations
            .FirstOrDefaultAsync(x => x.ProjAssetAllocId == projAssetAllocId && x.IsActive);

        if (entity == null)
            return null;

        bool exists = await _context.TblProjAssetAllocations
            .AnyAsync(x => x.ProjAssetAllocId != projAssetAllocId &&
                           x.IsActive &&
                           x.AssetId == request.AssetId &&
                           x.ReleaseDate == null);

        if (exists)
            throw new Exception("Asset is already allocated to a project and not yet released.");

        entity.ProjId = request.ProjId;
        entity.AssetId = request.AssetId;
        entity.AllocationDate = request.AllocationDate;
        entity.ReleaseDate = request.ReleaseDate;
        entity.Remarks = request.Remarks;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ProjAssetAllocId);
    }

    public async Task<ProjAssetAllocationResponse?> DeleteAsync(int projAssetAllocId)
    {
        var entity = await _context.TblProjAssetAllocations
            .FirstOrDefaultAsync(x => x.ProjAssetAllocId == projAssetAllocId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new ProjAssetAllocationResponse
        {
            ProjAssetAllocId = entity.ProjAssetAllocId,
            ProjId = entity.ProjId,
            AssetId = entity.AssetId,
            AllocationDate = entity.AllocationDate,
            ReleaseDate = entity.ReleaseDate,
            Remarks = entity.Remarks
        };
    }
}
