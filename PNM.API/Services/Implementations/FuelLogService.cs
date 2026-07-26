using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.FuelLog;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PNM.Service.Services.Implementations
{
    public class FuelLogService : IFuelLogService
    {
        private readonly PnmDbContext _context;

        public FuelLogService(PnmDbContext context)
        {
            _context = context;
        }

        public async Task<List<FuelLogResponse>> GetAllAsync()
        {
            return await _context.TrnFuelLogs
                .Where(x => x.IsActive)
                .Join(_context.TblAssets,
                    f => f.AssetId,
                    a => a.AssetId,
                    (f, a) => new FuelLogResponse
                    {
                        FuelLogId = f.FuelLogId,
                        AssetId = f.AssetId,
                        AssetName = a.AssetName,
                        AssetCode = a.AssetCode,
                        FuelDateTime = f.FuelDateTime,
                        FuelQty = f.FuelQty,
                        ReadingAtFueling = f.ReadingAtFueling,
                        FuelType = f.FuelType,
                        Remarks = f.Remarks,
                        PhotoPath = f.PhotoPath,
                        UniqueId = f.UniqueId
                    })
                .ToListAsync();
        }

        public async Task<FuelLogResponse?> GetByIdAsync(int fuelLogId)
        {
            var f = await _context.TrnFuelLogs
                .FirstOrDefaultAsync(x => x.FuelLogId == fuelLogId && x.IsActive);

            if (f == null)
                return null;

            var a = await _context.TblAssets.FindAsync(f.AssetId);

            return new FuelLogResponse
            {
                FuelLogId = f.FuelLogId,
                AssetId = f.AssetId,
                AssetName = a?.AssetName ?? "",
                AssetCode = a?.AssetCode ?? "",
                FuelDateTime = f.FuelDateTime,
                FuelQty = f.FuelQty,
                ReadingAtFueling = f.ReadingAtFueling,
                FuelType = f.FuelType,
                Remarks = f.Remarks,
                PhotoPath = f.PhotoPath,
                UniqueId = f.UniqueId
            };
        }

        public async Task<FuelLogResponse> SaveAsync(FuelLogRequest request)
        {
            var entity = new TrnFuelLog
            {
                UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
                AssetId = request.AssetId,
                FuelDateTime = request.FuelDateTime,
                FuelQty = request.FuelQty,
                ReadingAtFueling = request.ReadingAtFueling,
                FuelType = request.FuelType,
                Remarks = request.Remarks,
                PhotoPath = request.PhotoPath,
                IsActive = true,
                CreatedBy = 0,
                CreatedOn = DateTime.Now
            };

            _context.TrnFuelLogs.Add(entity);
            await _context.SaveChangesAsync();

            return await GetByIdAsync(entity.FuelLogId) ?? throw new Exception("Failed to retrieve saved fuel log.");
        }

        public async Task<FuelLogResponse?> UpdateAsync(int fuelLogId, FuelLogRequest request)
        {
            var entity = await _context.TrnFuelLogs
                .FirstOrDefaultAsync(x => x.FuelLogId == fuelLogId && x.IsActive);

            if (entity == null)
                return null;

            entity.FuelDateTime = request.FuelDateTime;
            entity.FuelQty = request.FuelQty;
            entity.ReadingAtFueling = request.ReadingAtFueling;
            entity.FuelType = request.FuelType;
            entity.Remarks = request.Remarks;
            entity.PhotoPath = request.PhotoPath;
            entity.ModifiedOn = DateTime.Now;

            await _context.SaveChangesAsync();

            return await GetByIdAsync(fuelLogId);
        }

        public async Task<FuelLogResponse?> DeleteAsync(int fuelLogId)
        {
            var entity = await _context.TrnFuelLogs
                .FirstOrDefaultAsync(x => x.FuelLogId == fuelLogId && x.IsActive);

            if (entity == null)
                return null;

            entity.IsActive = false;
            entity.ModifiedOn = DateTime.Now;

            await _context.SaveChangesAsync();

            return await GetByIdAsync(fuelLogId) ?? new FuelLogResponse { FuelLogId = fuelLogId };
        }
    }
}
