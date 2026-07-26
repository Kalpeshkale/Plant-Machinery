using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.AssetCompliance;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PNM.Service.Services.Implementations
{
    public class AssetComplianceService : IAssetComplianceService
    {
        private readonly PnmDbContext _context;

        public AssetComplianceService(PnmDbContext context)
        {
            _context = context;
        }

        public async Task<List<AssetComplianceResponse>> GetAllAsync()
        {
            return await _context.TblAssetCompliances
                .Where(x => x.IsActive)
                .Join(_context.TblAssets,
                    c => c.AssetId,
                    a => a.AssetId,
                    (c, a) => new AssetComplianceResponse
                    {
                        ComplianceId = c.ComplianceId,
                        UniqueId = c.UniqueId,
                        AssetId = c.AssetId,
                        AssetName = a.AssetName,
                        AssetCode = a.AssetCode,
                        InsuranceExpDate = c.InsuranceExpDate,
                        PucexpDate = c.PucexpDate,
                        FitnessExpDate = c.FitnessExpDate,
                        PermitExpDate = c.PermitExpDate,
                        RoadTaxExpDate = c.RoadTaxExpDate,
                        RtoexpDate = c.RtoexpDate,
                        Remarks = c.Remarks
                    })
                .ToListAsync();
        }

        public async Task<AssetComplianceResponse?> GetByIdAsync(int id)
        {
            var c = await _context.TblAssetCompliances
                .FirstOrDefaultAsync(x => x.ComplianceId == id && x.IsActive);

            if (c == null)
                return null;

            var a = await _context.TblAssets.FindAsync(c.AssetId);

            return new AssetComplianceResponse
            {
                ComplianceId = c.ComplianceId,
                UniqueId = c.UniqueId,
                AssetId = c.AssetId,
                AssetName = a?.AssetName ?? "",
                AssetCode = a?.AssetCode ?? "",
                InsuranceExpDate = c.InsuranceExpDate,
                PucexpDate = c.PucexpDate,
                FitnessExpDate = c.FitnessExpDate,
                PermitExpDate = c.PermitExpDate,
                RoadTaxExpDate = c.RoadTaxExpDate,
                RtoexpDate = c.RtoexpDate,
                Remarks = c.Remarks
            };
        }

        public async Task<AssetComplianceResponse> SaveAsync(AssetComplianceRequest request)
        {
            var entity = new TblAssetCompliance
            {
                UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
                AssetId = request.AssetId,
                InsuranceExpDate = request.InsuranceExpDate,
                PucexpDate = request.PucexpDate,
                FitnessExpDate = request.FitnessExpDate,
                PermitExpDate = request.PermitExpDate,
                RoadTaxExpDate = request.RoadTaxExpDate,
                RtoexpDate = request.RtoexpDate,
                Remarks = request.Remarks,
                IsActive = true,
                CreatedBy = 0,
                CreatedOn = DateTime.Now
            };

            _context.TblAssetCompliances.Add(entity);
            await _context.SaveChangesAsync();

            return await GetByIdAsync(entity.ComplianceId) ?? throw new Exception("Failed to retrieve saved compliance record.");
        }

        public async Task<AssetComplianceResponse?> UpdateAsync(int id, AssetComplianceRequest request)
        {
            var entity = await _context.TblAssetCompliances
                .FirstOrDefaultAsync(x => x.ComplianceId == id && x.IsActive);

            if (entity == null)
                return null;

            entity.InsuranceExpDate = request.InsuranceExpDate;
            entity.PucexpDate = request.PucexpDate;
            entity.FitnessExpDate = request.FitnessExpDate;
            entity.PermitExpDate = request.PermitExpDate;
            entity.RoadTaxExpDate = request.RoadTaxExpDate;
            entity.RtoexpDate = request.RtoexpDate;
            entity.Remarks = request.Remarks;
            entity.ModifiedOn = DateTime.Now;

            await _context.SaveChangesAsync();

            return await GetByIdAsync(id);
        }

        public async Task<AssetComplianceResponse?> DeleteAsync(int id)
        {
            var entity = await _context.TblAssetCompliances
                .FirstOrDefaultAsync(x => x.ComplianceId == id && x.IsActive);

            if (entity == null)
                return null;

            entity.IsActive = false;
            entity.ModifiedOn = DateTime.Now;

            await _context.SaveChangesAsync();

            return await GetByIdAsync(id) ?? new AssetComplianceResponse { ComplianceId = id };
        }
    }
}
