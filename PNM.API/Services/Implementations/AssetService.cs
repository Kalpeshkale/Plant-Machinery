using Microsoft.EntityFrameworkCore;
using PNM.Core.DTO.Asset;
using PNM.Infrastructure.Context;
using PNM.Infrastructure.Entities;
using PNM.Service.Services.Interfaces;

namespace PNM.Service.Services.Implementations;

public class AssetService : IAssetService
{
    private readonly PnmDbContext _context;
    private readonly ICurrentUserService _currentUserService;

    public AssetService(PnmDbContext context, ICurrentUserService currentUserService)
    {
        _context = context;
        _currentUserService = currentUserService;
    }

    public async Task<List<AssetResponse>> GetAllAsync()
    {
        return await _context.TblAssets
            .Include(x => x.Dept)
            .Include(x => x.Cat)
            .Include(x => x.Type)
            .Include(x => x.SubType)
            .Include(x => x.Make)
            .Include(x => x.Model)
            .Include(x => x.Owner)
            .Where(x => x.IsActive)
            .OrderBy(x => x.AssetName)
            .Select(x => new AssetResponse
            {
                AssetId = x.AssetId,
                DeptId = x.DeptId,
                DeptName = x.Dept.DeptName,
                AssetCode = x.AssetCode,
                AssetName = x.AssetName,
                CatId = x.CatId,
                CatName = x.Cat.CatName,
                TypeId = x.TypeId,
                TypeName = x.Type.TypeName,
                SubTypeId = x.SubTypeId,
                SubTypeName = x.SubType.SubTypeName,
                MakeId = x.MakeId,
                MakeName = x.Make.MakeName,
                ModelId = x.ModelId,
                ModelNo = x.Model.ModelNo,
                OwnerId = x.OwnerId,
                OwnerType = x.Owner.OwnerType,
                RegistrationNo = x.RegistrationNo,
                ChassisNo = x.ChassisNo,
                EngineNo = x.EngineNo,
                SerialNo = x.SerialNo,
                MeterType = x.MeterType,
                CurrentMeterReading = x.CurrentMeterReading,
                FuelType = x.FuelType,
                FuelTankCapacity = x.FuelTankCapacity,
                PurchaseDate = x.PurchaseDate,
                PurchaseCost = x.PurchaseCost,
                SupplierName = x.SupplierName,
                InvoiceNo = x.InvoiceNo,
                AssetStatus = x.AssetStatus,
                Remarks = x.Remarks
            })
            .ToListAsync();
    }

    public async Task<AssetResponse?> GetByIdAsync(int assetId)
    {
        return await _context.TblAssets
            .Include(x => x.Dept)
            .Include(x => x.Cat)
            .Include(x => x.Type)
            .Include(x => x.SubType)
            .Include(x => x.Make)
            .Include(x => x.Model)
            .Include(x => x.Owner)
            .Where(x => x.AssetId == assetId && x.IsActive)
            .Select(x => new AssetResponse
            {
                AssetId = x.AssetId,
                DeptId = x.DeptId,
                DeptName = x.Dept.DeptName,
                AssetCode = x.AssetCode,
                AssetName = x.AssetName,
                CatId = x.CatId,
                CatName = x.Cat.CatName,
                TypeId = x.TypeId,
                TypeName = x.Type.TypeName,
                SubTypeId = x.SubTypeId,
                SubTypeName = x.SubType.SubTypeName,
                MakeId = x.MakeId,
                MakeName = x.Make.MakeName,
                ModelId = x.ModelId,
                ModelNo = x.Model.ModelNo,
                OwnerId = x.OwnerId,
                OwnerType = x.Owner.OwnerType,
                RegistrationNo = x.RegistrationNo,
                ChassisNo = x.ChassisNo,
                EngineNo = x.EngineNo,
                SerialNo = x.SerialNo,
                MeterType = x.MeterType,
                CurrentMeterReading = x.CurrentMeterReading,
                FuelType = x.FuelType,
                FuelTankCapacity = x.FuelTankCapacity,
                PurchaseDate = x.PurchaseDate,
                PurchaseCost = x.PurchaseCost,
                SupplierName = x.SupplierName,
                InvoiceNo = x.InvoiceNo,
                AssetStatus = x.AssetStatus,
                Remarks = x.Remarks
            })
            .FirstOrDefaultAsync();
    }

    public async Task<AssetResponse> SaveAsync(AssetRequest request)
    {
        request.AssetCode = request.AssetCode.Trim();
        request.AssetName = request.AssetName.Trim();

        bool exists = await _context.TblAssets
            .AnyAsync(x => x.IsActive &&
                           x.AssetCode.ToLower() == request.AssetCode.ToLower());

        if (exists)
            throw new Exception("Asset already exists.");

        var entity = new TblAsset
        {
            UniqueId = Guid.NewGuid().ToString("N")[..8].ToUpper(),
            DeptId = request.DeptId,
            AssetCode = request.AssetCode,
            AssetName = request.AssetName,
            CatId = request.CatId,
            TypeId = request.TypeId,
            SubTypeId = request.SubTypeId,
            MakeId = request.MakeId,
            ModelId = request.ModelId,
            OwnerId = request.OwnerId,
            RegistrationNo = request.RegistrationNo,
            ChassisNo = request.ChassisNo,
            EngineNo = request.EngineNo,
            SerialNo = request.SerialNo,
            MeterType = request.MeterType,
            CurrentMeterReading = request.CurrentMeterReading,
            FuelType = request.FuelType,
            FuelTankCapacity = request.FuelTankCapacity,
            PurchaseDate = request.PurchaseDate,
            PurchaseCost = request.PurchaseCost,
            SupplierName = request.SupplierName,
            InvoiceNo = request.InvoiceNo,
            AssetStatus = request.AssetStatus,
            Remarks = request.Remarks,
            IsActive = true,
            CreatedBy = _currentUserService.UserId ?? 4,
            CreatedOn = DateTime.Now
        };

        _context.TblAssets.Add(entity);
        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.AssetId) ?? new AssetResponse
        {
            AssetId = entity.AssetId,
            DeptId = entity.DeptId,
            AssetCode = entity.AssetCode,
            AssetName = entity.AssetName,
            CatId = entity.CatId,
            TypeId = entity.TypeId,
            SubTypeId = entity.SubTypeId,
            MakeId = entity.MakeId,
            ModelId = entity.ModelId,
            OwnerId = entity.OwnerId,
            RegistrationNo = entity.RegistrationNo,
            ChassisNo = entity.ChassisNo,
            EngineNo = entity.EngineNo,
            SerialNo = entity.SerialNo,
            MeterType = entity.MeterType,
            CurrentMeterReading = entity.CurrentMeterReading,
            FuelType = entity.FuelType,
            FuelTankCapacity = entity.FuelTankCapacity,
            PurchaseDate = entity.PurchaseDate,
            PurchaseCost = entity.PurchaseCost,
            SupplierName = entity.SupplierName,
            InvoiceNo = entity.InvoiceNo,
            AssetStatus = entity.AssetStatus,
            Remarks = entity.Remarks
        };
    }

    public async Task<AssetResponse?> UpdateAsync(int assetId, AssetRequest request)
    {
        var entity = await _context.TblAssets
            .FirstOrDefaultAsync(x => x.AssetId == assetId && x.IsActive);

        if (entity == null)
            return null;

        request.AssetCode = request.AssetCode.Trim();
        request.AssetName = request.AssetName.Trim();

        bool exists = await _context.TblAssets
            .AnyAsync(x => x.AssetId != assetId &&
                           x.IsActive &&
                           x.AssetCode.ToLower() == request.AssetCode.ToLower());

        if (exists)
            throw new Exception("Asset already exists.");

        entity.DeptId = request.DeptId;
        entity.AssetCode = request.AssetCode;
        entity.AssetName = request.AssetName;
        entity.CatId = request.CatId;
        entity.TypeId = request.TypeId;
        entity.SubTypeId = request.SubTypeId;
        entity.MakeId = request.MakeId;
        entity.ModelId = request.ModelId;
        entity.OwnerId = request.OwnerId;
        entity.RegistrationNo = request.RegistrationNo;
        entity.ChassisNo = request.ChassisNo;
        entity.EngineNo = request.EngineNo;
        entity.SerialNo = request.SerialNo;
        entity.MeterType = request.MeterType;
        entity.CurrentMeterReading = request.CurrentMeterReading;
        entity.FuelType = request.FuelType;
        entity.FuelTankCapacity = request.FuelTankCapacity;
        entity.PurchaseDate = request.PurchaseDate;
        entity.PurchaseCost = request.PurchaseCost;
        entity.SupplierName = request.SupplierName;
        entity.InvoiceNo = request.InvoiceNo;
        entity.AssetStatus = request.AssetStatus;
        entity.Remarks = request.Remarks;
        entity.ModifiedOn = DateTime.Now;
        entity.ModifiedBy = null; // set properly once auth is wired up

        await _context.SaveChangesAsync();

        return await GetByIdAsync(entity.AssetId);
    }

    public async Task<AssetResponse?> DeleteAsync(int assetId)
    {
        var entity = await _context.TblAssets
            .FirstOrDefaultAsync(x => x.AssetId == assetId && x.IsActive);

        if (entity == null)
            return null;

        entity.IsActive = false;
        entity.ModifiedOn = DateTime.Now;
        entity.ModifiedBy = null; // set properly once auth is wired up

        await _context.SaveChangesAsync();

        return new AssetResponse
        {
            AssetId = entity.AssetId,
            DeptId = entity.DeptId,
            AssetCode = entity.AssetCode,
            AssetName = entity.AssetName,
            CatId = entity.CatId,
            TypeId = entity.TypeId,
            SubTypeId = entity.SubTypeId,
            MakeId = entity.MakeId,
            ModelId = entity.ModelId,
            OwnerId = entity.OwnerId,
            RegistrationNo = entity.RegistrationNo,
            ChassisNo = entity.ChassisNo,
            EngineNo = entity.EngineNo,
            SerialNo = entity.SerialNo,
            MeterType = entity.MeterType,
            CurrentMeterReading = entity.CurrentMeterReading,
            FuelType = entity.FuelType,
            FuelTankCapacity = entity.FuelTankCapacity,
            PurchaseDate = entity.PurchaseDate,
            PurchaseCost = entity.PurchaseCost,
            SupplierName = entity.SupplierName,
            InvoiceNo = entity.InvoiceNo,
            AssetStatus = entity.AssetStatus,
            Remarks = entity.Remarks
        };
    }

    public async Task<AssetResponse?> UpdateStatusAsync(int assetId, string status)
    {
        var entity = await _context.TblAssets
            .FirstOrDefaultAsync(x => x.AssetId == assetId && x.IsActive);

        if (entity == null)
            return null;

        entity.AssetStatus = status;
        entity.ModifiedOn = DateTime.Now;

        await _context.SaveChangesAsync();

        return await GetByIdAsync(assetId);
    }
}
