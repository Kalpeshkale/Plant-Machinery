using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.AssetOpAllocation;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class AssetOpAllocationService : IAssetOpAllocationService
{
    private readonly PnmDbContext _context;
    private readonly ICurrentUserService _currentUserService;

    public AssetOpAllocationService(PnmDbContext context, ICurrentUserService currentUserService)
    {
        _context = context;
        _currentUserService = currentUserService;
    }

    public async Task<List<AssetOpAllocationResponse>> GetAllAsync()
    {
        return await _context.TblAssetOpAllocations
            .Include(x => x.Asset)
            .Include(x => x.Op)
            .Where(x => x.IsActive)
            .OrderByDescending(x => x.AllocationDate)
            .Select(x => new AssetOpAllocationResponse
            {
                AssetOpAllocId = x.AssetOpAllocId,
                AssetId = x.AssetId,
                AssetName = x.Asset.AssetName,
                OpId = x.OpId,
                OpFullName = x.Op.FullName,
                AllocationDate = x.AllocationDate,
                ReleaseDate = x.ReleaseDate,
                Remarks = x.Remarks
            })
            .ToListAsync();
    }

    public async Task<AssetOpAllocationResponse?> GetByIdAsync(int assetOpAllocId)
    {
        return await _context.TblAssetOpAllocations
            .Include(x => x.Asset)
            .Include(x => x.Op)
            .Where(x => x.AssetOpAllocId == assetOpAllocId && x.IsActive)
            .Select(x => new AssetOpAllocationResponse
            {
                AssetOpAllocId = x.AssetOpAllocId,
                AssetId = x.AssetId,
                AssetName = x.Asset.AssetName,
                OpId = x.OpId,
                OpFullName = x.Op.FullName,
                AllocationDate = x.AllocationDate,
                ReleaseDate = x.ReleaseDate,
                Remarks = x.Remarks
            })
            .FirstOrDefaultAsync();
    }

    public async Task<AssetOpAllocationResponse> SaveAsync(AssetOpAllocationRequest request)
    {
        bool exists = await _context.TblAssetOpAllocations
            .AnyAsync(x => x.IsActive &&
                           x.OpId == request.OpId &&
                           x.ReleaseDate == null);

        if (exists)
            throw new Exception("Operator is already allocated to an asset and not yet released.");

        var entity = new TblAssetOpAllocation
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            AssetId = request.AssetId,
            OpId = request.OpId,
            AllocationDate = request.AllocationDate,
            ReleaseDate = request.ReleaseDate,
            Remarks = request.Remarks,
            IsActive = true,
            CreatedBy = _currentUserService.UserId ?? 4,
            CreatedOn = DateTime.Now
        };

        _context.TblAssetOpAllocations.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.AssetOpAllocId) ?? new AssetOpAllocationResponse
        {
            AssetOpAllocId = entity.AssetOpAllocId,
            AssetId = entity.AssetId,
            OpId = entity.OpId,
            AllocationDate = entity.AllocationDate,
            ReleaseDate = entity.ReleaseDate,
            Remarks = entity.Remarks
        };
    }

    public async Task<AssetOpAllocationResponse?> UpdateAsync(int assetOpAllocId, AssetOpAllocationRequest request)
    {
        var entity = await _context.TblAssetOpAllocations
            .FirstOrDefaultAsync(x => x.AssetOpAllocId == assetOpAllocId && x.IsActive);

        if (entity == null)
            return null;

        bool exists = await _context.TblAssetOpAllocations
            .AnyAsync(x => x.AssetOpAllocId != assetOpAllocId &&
                           x.IsActive &&
                           x.OpId == request.OpId &&
                           x.ReleaseDate == null);

        if (exists)
            throw new Exception("Operator is already allocated to an asset and not yet released.");

        entity.AssetId = request.AssetId;
        entity.OpId = request.OpId;
        entity.AllocationDate = request.AllocationDate;
        entity.ReleaseDate = request.ReleaseDate;
        entity.Remarks = request.Remarks;
        entity.ModifiedOn = DateTime.Now;
        entity.ModifiedBy = null;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.AssetOpAllocId);
    }

    public async Task<AssetOpAllocationResponse?> DeleteAsync(int assetOpAllocId)
    {
        var entity = await _context.TblAssetOpAllocations
            .FirstOrDefaultAsync(x => x.AssetOpAllocId == assetOpAllocId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        entity.ModifiedBy = null;

        await _context.SaveChangesAsync();

        return new AssetOpAllocationResponse
        {
            AssetOpAllocId = entity.AssetOpAllocId,
            AssetId = entity.AssetId,
            OpId = entity.OpId,
            AllocationDate = entity.AllocationDate,
            ReleaseDate = entity.ReleaseDate,
            Remarks = entity.Remarks
        };
    }

    public async Task<AssetOpAllocationResponse?> DeallocateAsync(int assetOpAllocId)
    {
        var entity = await _context.TblAssetOpAllocations
            .FirstOrDefaultAsync(x => x.AssetOpAllocId == assetOpAllocId && x.IsActive);

        if (entity == null)
            return null;

        entity.ReleaseDate = DateOnly.FromDateTime(DateTime.Today);
        entity.ModifiedOn  = DateTime.Now;
        entity.ModifiedBy  = null;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.AssetOpAllocId);
    }
}
