using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.ProjOpAllocation;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class ProjOpAllocationService : IProjOpAllocationService
{
    private readonly PnmDbContext _context;

    public ProjOpAllocationService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<ProjOpAllocationResponse>> GetAllAsync()
    {
        return await _context.TblProjOpAllocations
            .Include(x => x.Proj)
            .Include(x => x.Op)
            .Where(x => x.IsActive)
            .OrderByDescending(x => x.AllocationDate)
            .Select(x => new ProjOpAllocationResponse
            {
                ProjOpAllocId = x.ProjOpAllocId,
                ProjId = x.ProjId,
                ProjName = x.Proj.ProjName,
                OpId = x.OpId,
                OpFullName = x.Op.FullName,
                AllocationDate = x.AllocationDate,
                ReleaseDate = x.ReleaseDate,
                Remarks = x.Remarks
            })
            .ToListAsync();
    }

    public async Task<ProjOpAllocationResponse?> GetByIdAsync(int projOpAllocId)
    {
        return await _context.TblProjOpAllocations
            .Include(x => x.Proj)
            .Include(x => x.Op)
            .Where(x => x.ProjOpAllocId == projOpAllocId && x.IsActive)
            .Select(x => new ProjOpAllocationResponse
            {
                ProjOpAllocId = x.ProjOpAllocId,
                ProjId = x.ProjId,
                ProjName = x.Proj.ProjName,
                OpId = x.OpId,
                OpFullName = x.Op.FullName,
                AllocationDate = x.AllocationDate,
                ReleaseDate = x.ReleaseDate,
                Remarks = x.Remarks
            })
            .FirstOrDefaultAsync();
    }

    public async Task<ProjOpAllocationResponse> SaveAsync(ProjOpAllocationRequest request)
    {
        bool exists = await _context.TblProjOpAllocations
            .AnyAsync(x => x.IsActive &&
                           x.OpId == request.OpId &&
                           x.ReleaseDate == null);

        if (exists)
            throw new Exception("Operator is already allocated to a project and not yet released.");

        var entity = new TblProjOpAllocation
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            ProjId = request.ProjId,
            OpId = request.OpId,
            AllocationDate = request.AllocationDate,
            ReleaseDate = request.ReleaseDate,
            Remarks = request.Remarks,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.TblProjOpAllocations.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ProjOpAllocId) ?? new ProjOpAllocationResponse
        {
            ProjOpAllocId = entity.ProjOpAllocId,
            ProjId = entity.ProjId,
            OpId = entity.OpId,
            AllocationDate = entity.AllocationDate,
            ReleaseDate = entity.ReleaseDate,
            Remarks = entity.Remarks
        };
    }

    public async Task<ProjOpAllocationResponse?> UpdateAsync(int projOpAllocId, ProjOpAllocationRequest request)
    {
        var entity = await _context.TblProjOpAllocations
            .FirstOrDefaultAsync(x => x.ProjOpAllocId == projOpAllocId && x.IsActive);

        if (entity == null)
            return null;

        bool exists = await _context.TblProjOpAllocations
            .AnyAsync(x => x.ProjOpAllocId != projOpAllocId &&
                           x.IsActive &&
                           x.OpId == request.OpId &&
                           x.ReleaseDate == null);

        if (exists)
            throw new Exception("Operator is already allocated to a project and not yet released.");

        entity.ProjId = request.ProjId;
        entity.OpId = request.OpId;
        entity.AllocationDate = request.AllocationDate;
        entity.ReleaseDate = request.ReleaseDate;
        entity.Remarks = request.Remarks;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.ProjOpAllocId);
    }

    public async Task<ProjOpAllocationResponse?> DeleteAsync(int projOpAllocId)
    {
        var entity = await _context.TblProjOpAllocations
            .FirstOrDefaultAsync(x => x.ProjOpAllocId == projOpAllocId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return new ProjOpAllocationResponse
        {
            ProjOpAllocId = entity.ProjOpAllocId,
            ProjId = entity.ProjId,
            OpId = entity.OpId,
            AllocationDate = entity.AllocationDate,
            ReleaseDate = entity.ReleaseDate,
            Remarks = entity.Remarks
        };
    }
}
