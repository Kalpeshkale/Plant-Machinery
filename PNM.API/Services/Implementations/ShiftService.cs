using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Shift;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class ShiftService : IShiftService
{
    private readonly PnmDbContext _context;

    public ShiftService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<ShiftResponse>> GetAllAsync()
    {
        return await _context.MstShifts
            .Where(x => x.IsActive)
            .OrderBy(x => x.StartTime)
            .Select(x => new ShiftResponse
            {
                ShiftId = x.ShiftId,
                ShiftCode = x.ShiftCode,
                ShiftName = x.ShiftName,
                StartTime = x.StartTime,
                EndTime = x.EndTime
            })
            .ToListAsync();
    }

    public async Task<ShiftResponse?> GetByIdAsync(int shiftId)
    {
        return await _context.MstShifts
            .Where(x => x.ShiftId == shiftId && x.IsActive)
            .Select(x => new ShiftResponse
            {
                ShiftId = x.ShiftId,
                ShiftCode = x.ShiftCode,
                ShiftName = x.ShiftName,
                StartTime = x.StartTime,
                EndTime = x.EndTime
            })
            .FirstOrDefaultAsync();
    }

    public async Task<ShiftResponse> SaveAsync(ShiftRequest request)
    {
        request.ShiftCode = request.ShiftCode.Trim();
        request.ShiftName = request.ShiftName.Trim();

        bool exists = await _context.MstShifts
            .AnyAsync(x => x.IsActive &&
                           x.ShiftCode.ToLower() == request.ShiftCode.ToLower());

        if (exists)
            throw new Exception("Shift already exists.");

        var entity = new MstShift
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            ShiftCode = request.ShiftCode,
            ShiftName = request.ShiftName,
            StartTime = request.StartTime,
            EndTime = request.EndTime,
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.MstShifts.Add(entity);
        await _context.SaveChangesAsync();

        return new ShiftResponse
        {
            ShiftId = entity.ShiftId,
            ShiftCode = entity.ShiftCode,
            ShiftName = entity.ShiftName,
            StartTime = entity.StartTime,
            EndTime = entity.EndTime
        };
    }

    public async Task<ShiftResponse?> UpdateAsync(int shiftId, ShiftRequest request)
    {
        var entity = await _context.MstShifts
            .FirstOrDefaultAsync(x => x.ShiftId == shiftId && x.IsActive);

        if (entity == null)
            return null;

        request.ShiftCode = request.ShiftCode.Trim();
        request.ShiftName = request.ShiftName.Trim();

        bool exists = await _context.MstShifts
            .AnyAsync(x => x.ShiftId != shiftId &&
                           x.IsActive &&
                           x.ShiftCode.ToLower() == request.ShiftCode.ToLower());

        if (exists)
            throw new Exception("Shift already exists.");

        entity.ShiftCode = request.ShiftCode;
        entity.ShiftName = request.ShiftName;
        entity.StartTime = request.StartTime;
        entity.EndTime = request.EndTime;
        // ModifiedBy/ModifiedOn are not available on MstShift

        await _context.SaveChangesAsync();

        return new ShiftResponse
        {
            ShiftId = entity.ShiftId,
            ShiftCode = entity.ShiftCode,
            ShiftName = entity.ShiftName,
            StartTime = entity.StartTime,
            EndTime = entity.EndTime
        };
    }

    public async Task<ShiftResponse?> DeleteAsync(int shiftId)
    {
        var entity = await _context.MstShifts
            .FirstOrDefaultAsync(x => x.ShiftId == shiftId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        // ModifiedBy/ModifiedOn are not available on MstShift

        await _context.SaveChangesAsync();

        return new ShiftResponse
        {
            ShiftId = entity.ShiftId,
            ShiftCode = entity.ShiftCode,
            ShiftName = entity.ShiftName,
            StartTime = entity.StartTime,
            EndTime = entity.EndTime
        };
    }
}
