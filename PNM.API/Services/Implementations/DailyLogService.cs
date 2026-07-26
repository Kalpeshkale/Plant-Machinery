using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.DailyLog;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class DailyLogService : IDailyLogService
{
    private readonly PnmDbContext _context;

    public DailyLogService(PnmDbContext context)
    {
        _context = context;
    }

    public async Task<List<DailyLogResponse>> GetAllAsync()
    {
        return await _context.TrnDailyLogs
            .Include(x => x.Proj)
            .Include(x => x.Asset)
            .Include(x => x.Op)
            .Include(x => x.Shift)
            .Where(x => x.IsActive)
            .OrderByDescending(x => x.LogDate)
            .Select(x => new DailyLogResponse
            {
                DailyLogId = x.DailyLogId,
                LogDate = x.LogDate,
                ProjId = x.ProjId,
                ProjName = x.Proj.ProjName,
                AssetId = x.AssetId,
                AssetName = x.Asset.AssetName,
                OpId = x.OpId,
                OpFullName = x.Op.FullName,
                ShiftId = x.ShiftId,
                ShiftName = x.Shift.ShiftName,
                StartReading = x.StartReading,
                EndReading = x.EndReading,
                TotalReading = x.TotalReading,
                FuelIssued = x.FuelIssued,
                FuelBalance = x.FuelBalance,
                WorkingHours = x.WorkingHours,
                Breakdown = x.Breakdown,
                BreakdownRemarks = x.BreakdownRemarks,
                WorkDescription = x.WorkDescription,
                StartReadingPhoto = x.StartReadingPhoto,
                EndReadingPhoto = x.EndReadingPhoto,
                OperatorRemarks = x.OperatorRemarks,
                Sicstatus = x.Sicstatus,
                Sicby = x.Sicby,
                Sicon = x.Sicon,
                Sicremarks = x.Sicremarks,
                AdminStatus = x.AdminStatus,
                AdminBy = x.AdminBy,
                AdminOn = x.AdminOn,
                AdminRemarks = x.AdminRemarks
            })
            .ToListAsync();
    }

    public async Task<DailyLogResponse?> GetByIdAsync(int dailyLogId)
    {
        return await _context.TrnDailyLogs
            .Include(x => x.Proj)
            .Include(x => x.Asset)
            .Include(x => x.Op)
            .Include(x => x.Shift)
            .Where(x => x.DailyLogId == dailyLogId && x.IsActive)
            .Select(x => new DailyLogResponse
            {
                DailyLogId = x.DailyLogId,
                LogDate = x.LogDate,
                ProjId = x.ProjId,
                ProjName = x.Proj.ProjName,
                AssetId = x.AssetId,
                AssetName = x.Asset.AssetName,
                OpId = x.OpId,
                OpFullName = x.Op.FullName,
                ShiftId = x.ShiftId,
                ShiftName = x.Shift.ShiftName,
                StartReading = x.StartReading,
                EndReading = x.EndReading,
                TotalReading = x.TotalReading,
                FuelIssued = x.FuelIssued,
                FuelBalance = x.FuelBalance,
                WorkingHours = x.WorkingHours,
                Breakdown = x.Breakdown,
                BreakdownRemarks = x.BreakdownRemarks,
                WorkDescription = x.WorkDescription,
                StartReadingPhoto = x.StartReadingPhoto,
                EndReadingPhoto = x.EndReadingPhoto,
                OperatorRemarks = x.OperatorRemarks,
                Sicstatus = x.Sicstatus,
                Sicby = x.Sicby,
                Sicon = x.Sicon,
                Sicremarks = x.Sicremarks,
                AdminStatus = x.AdminStatus,
                AdminBy = x.AdminBy,
                AdminOn = x.AdminOn,
                AdminRemarks = x.AdminRemarks
            })
            .FirstOrDefaultAsync();
    }

    public async Task<DailyLogResponse> SaveAsync(DailyLogRequest request)
    {
        if (request.StartReading < 0 || request.EndReading < 0)
            throw new Exception("Meter readings cannot be negative.");

        if (request.EndReading < request.StartReading)
            throw new Exception("End reading cannot be less than start reading.");

        var entity = new TrnDailyLog
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            LogDate = request.LogDate,
            ProjId = request.ProjId,
            AssetId = request.AssetId,
            OpId = request.OpId,
            ShiftId = request.ShiftId,
            StartReading = request.StartReading,
            EndReading = request.EndReading,
            TotalReading = request.EndReading - request.StartReading,
            FuelIssued = request.FuelIssued,
            FuelBalance = request.FuelBalance,
            WorkingHours = request.WorkingHours,
            Breakdown = request.Breakdown,
            BreakdownRemarks = request.BreakdownRemarks,
            WorkDescription = request.WorkDescription,
            StartReadingPhoto = request.StartReadingPhoto,
            EndReadingPhoto = request.EndReadingPhoto,
            OperatorRemarks = request.OperatorRemarks,
            Sicstatus = "Pending",
            AdminStatus = "Pending",
            IsActive = true,
            CreatedBy = 0,
            CreatedOn = DateTime.Now
            // CreatedBy will be added after CurrentUserService
        };

        _context.TrnDailyLogs.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.DailyLogId) ?? throw new Exception("Failed to retrieve saved daily log.");
    }

    public async Task<DailyLogResponse?> UpdateAsync(int dailyLogId, DailyLogRequest request)
    {
        var entity = await _context.TrnDailyLogs
            .FirstOrDefaultAsync(x => x.DailyLogId == dailyLogId && x.IsActive);

        if (entity == null)
            return null;

        if (request.StartReading < 0 || request.EndReading < 0)
            throw new Exception("Meter readings cannot be negative.");

        if (request.EndReading < request.StartReading)
            throw new Exception("End reading cannot be less than start reading.");

        entity.LogDate = request.LogDate;
        entity.ProjId = request.ProjId;
        entity.AssetId = request.AssetId;
        entity.OpId = request.OpId;
        entity.ShiftId = request.ShiftId;
        entity.StartReading = request.StartReading;
        entity.EndReading = request.EndReading;
        entity.TotalReading = request.EndReading - request.StartReading;
        entity.FuelIssued = request.FuelIssued;
        entity.FuelBalance = request.FuelBalance;
        entity.WorkingHours = request.WorkingHours;
        entity.Breakdown = request.Breakdown;
        entity.BreakdownRemarks = request.BreakdownRemarks;
        entity.WorkDescription = request.WorkDescription;
        entity.StartReadingPhoto = request.StartReadingPhoto;
        entity.EndReadingPhoto = request.EndReadingPhoto;
        entity.OperatorRemarks = request.OperatorRemarks;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.DailyLogId);
    }

    public async Task<DailyLogResponse?> DeleteAsync(int dailyLogId)
    {
        var entity = await _context.TrnDailyLogs
            .FirstOrDefaultAsync(x => x.DailyLogId == dailyLogId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        // ModifiedBy will be added after CurrentUserService

        await _context.SaveChangesAsync();

        return await GetByIdAsync(dailyLogId) ?? new DailyLogResponse
        {
            DailyLogId = entity.DailyLogId,
            LogDate = entity.LogDate,
            ProjId = entity.ProjId,
            AssetId = entity.AssetId,
            OpId = entity.OpId,
            ShiftId = entity.ShiftId,
            StartReading = entity.StartReading,
            EndReading = entity.EndReading,
            TotalReading = entity.TotalReading,
            Sicstatus = entity.Sicstatus,
            AdminStatus = entity.AdminStatus
        };
    }

    public async Task<DailyLogResponse?> SicApprovalAsync(int dailyLogId, int sicBy, DailyLogApprovalRequest request)
    {
        var entity = await _context.TrnDailyLogs
            .FirstOrDefaultAsync(x => x.DailyLogId == dailyLogId && x.IsActive);

        if (entity == null)
            return null;

        entity.Sicstatus = request.Status;
        entity.Sicby = sicBy;
        entity.Sicon = DateTime.Now;
        entity.Sicremarks = request.Remarks;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.DailyLogId);
    }

    public async Task<DailyLogResponse?> AdminApprovalAsync(int dailyLogId, int adminBy, DailyLogApprovalRequest request)
    {
        var entity = await _context.TrnDailyLogs
            .FirstOrDefaultAsync(x => x.DailyLogId == dailyLogId && x.IsActive);

        if (entity == null)
            return null;

        entity.AdminStatus = request.Status;
        entity.AdminBy = adminBy;
        entity.AdminOn = DateTime.Now;
        entity.AdminRemarks = request.Remarks;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.DailyLogId);
    }

    public async Task<AssetLoggingDetailsResponse?> GetAssetLoggingDetailsAsync(int assetId)
    {
        var asset = await _context.TblAssets
            .FirstOrDefaultAsync(x => x.AssetId == assetId && x.IsActive);

        if (asset == null)
            return null;

        var projAlloc = await _context.TblProjAssetAllocations
            .Include(x => x.Proj)
            .Where(x => x.AssetId == assetId && x.IsActive && x.ReleaseDate == null)
            .OrderByDescending(x => x.ProjAssetAllocId)
            .FirstOrDefaultAsync();

        var opAlloc = await _context.TblAssetOpAllocations
            .Include(x => x.Op)
            .Where(x => x.AssetId == assetId && x.IsActive && x.ReleaseDate == null)
            .OrderByDescending(x => x.AssetOpAllocId)
            .FirstOrDefaultAsync();

        var lastLog = await _context.TrnDailyLogs
            .Where(x => x.AssetId == assetId && x.IsActive)
            .OrderByDescending(x => x.LogDate)
            .ThenByDescending(x => x.DailyLogId)
            .FirstOrDefaultAsync();

        decimal lastReading = lastLog != null ? lastLog.EndReading : asset.CurrentMeterReading;
        decimal? fuelBalance = lastLog != null ? lastLog.FuelBalance : 0;

        return new AssetLoggingDetailsResponse
        {
            AssetId = asset.AssetId,
            AssetName = asset.AssetName,
            AssetCode = asset.AssetCode,
            MeterType = asset.MeterType,
            LastMeterReading = lastReading,
            CurrentProjectId = projAlloc?.ProjId,
            CurrentProjectName = projAlloc?.Proj?.ProjName,
            DefaultOperatorId = opAlloc?.OpId,
            DefaultOperatorName = opAlloc?.Op?.FullName,
            FuelBalance = fuelBalance
        };
    }

    public async Task<List<DailyLogResponse>> SaveBulkAsync(List<DailyLogRequest> requests)
    {
        var responses = new List<DailyLogResponse>();
        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            foreach (var req in requests)
            {
                var response = await SaveAsync(req);
                responses.Add(response);
            }
            await transaction.CommitAsync();
        }
        catch (Exception)
        {
            await transaction.RollbackAsync();
            throw;
        }
        return responses;
    }
}
