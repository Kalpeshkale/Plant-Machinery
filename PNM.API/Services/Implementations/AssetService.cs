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
        var query = from a in _context.TblAssets
                    join dept in _context.MstDepartments on a.DeptId equals dept.DeptId into deptJoin
                    from dept in deptJoin.DefaultIfEmpty()
                    join typ in _context.MstTypes on a.TypeId equals typ.TypeId into typeJoin
                    from typ in typeJoin.DefaultIfEmpty()
                    join sub in _context.MstSubTypes on a.SubTypeId equals sub.SubTypeId into subJoin
                    from sub in subJoin.DefaultIfEmpty()
                    join mak in _context.MstMakes on a.MakeId equals mak.MakeId into makeJoin
                    from mak in makeJoin.DefaultIfEmpty()
                    join mod in _context.MstModels on a.ModelId equals mod.ModelId into modelJoin
                    from mod in modelJoin.DefaultIfEmpty()
                    join own in _context.MstOwnerTypes on a.OwnerId equals own.OwnerId into ownerJoin
                    from own in ownerJoin.DefaultIfEmpty()
                    where a.IsActive
                    orderby a.AssetName
                    select new AssetResponse
                    {
                        AssetId = a.AssetId,
                        DeptId = a.DeptId,
                        DeptName = dept != null ? dept.DeptName : null,
                        AssetCode = a.AssetCode,
                        AssetName = a.AssetName,
                        TypeId = a.TypeId,
                        TypeName = typ != null ? typ.TypeName : null,
                        SubTypeId = a.SubTypeId,
                        SubTypeName = sub != null ? sub.SubTypeName : null,
                        MakeId = a.MakeId,
                        MakeName = mak != null ? mak.MakeName : null,
                        ModelId = a.ModelId,
                        ModelNo = mod != null ? mod.ModelNo : null,
                        OwnerId = a.OwnerId,
                        OwnerType = own != null ? own.OwnerType : null,
                        RegistrationNo = a.RegistrationNo,
                        ChassisNo = a.ChassisNo,
                        EngineNo = a.EngineNo,
                        SerialNo = a.SerialNo,
                        MeterType = a.MeterType,
                        CurrentMeterReading = a.CurrentMeterReading,
                        FuelType = a.FuelType,
                        FuelTankCapacity = a.FuelTankCapacity,
                        PurchaseDate = a.PurchaseDate,
                        PurchaseCost = a.PurchaseCost,
                        SupplierName = a.SupplierName,
                        InvoiceNo = a.InvoiceNo,
                        AssetStatus = a.AssetStatus,
                        Remarks = a.Remarks
                    };
        return await query.ToListAsync();
    }

    public async Task<AssetResponse?> GetByIdAsync(int assetId)
    {
        var query = from a in _context.TblAssets
                    join dept in _context.MstDepartments on a.DeptId equals dept.DeptId into deptJoin
                    from dept in deptJoin.DefaultIfEmpty()
                    join typ in _context.MstTypes on a.TypeId equals typ.TypeId into typeJoin
                    from typ in typeJoin.DefaultIfEmpty()
                    join sub in _context.MstSubTypes on a.SubTypeId equals sub.SubTypeId into subJoin
                    from sub in subJoin.DefaultIfEmpty()
                    join mak in _context.MstMakes on a.MakeId equals mak.MakeId into makeJoin
                    from mak in makeJoin.DefaultIfEmpty()
                    join mod in _context.MstModels on a.ModelId equals mod.ModelId into modelJoin
                    from mod in modelJoin.DefaultIfEmpty()
                    join own in _context.MstOwnerTypes on a.OwnerId equals own.OwnerId into ownerJoin
                    from own in ownerJoin.DefaultIfEmpty()
                    where a.AssetId == assetId && a.IsActive
                    select new AssetResponse
                    {
                        AssetId = a.AssetId,
                        DeptId = a.DeptId,
                        DeptName = dept != null ? dept.DeptName : null,
                        AssetCode = a.AssetCode,
                        AssetName = a.AssetName,
                        TypeId = a.TypeId,
                        TypeName = typ != null ? typ.TypeName : null,
                        SubTypeId = a.SubTypeId,
                        SubTypeName = sub != null ? sub.SubTypeName : null,
                        MakeId = a.MakeId,
                        MakeName = mak != null ? mak.MakeName : null,
                        ModelId = a.ModelId,
                        ModelNo = mod != null ? mod.ModelNo : null,
                        OwnerId = a.OwnerId,
                        OwnerType = own != null ? own.OwnerType : null,
                        RegistrationNo = a.RegistrationNo,
                        ChassisNo = a.ChassisNo,
                        EngineNo = a.EngineNo,
                        SerialNo = a.SerialNo,
                        MeterType = a.MeterType,
                        CurrentMeterReading = a.CurrentMeterReading,
                        FuelType = a.FuelType,
                        FuelTankCapacity = a.FuelTankCapacity,
                        PurchaseDate = a.PurchaseDate,
                        PurchaseCost = a.PurchaseCost,
                        SupplierName = a.SupplierName,
                        InvoiceNo = a.InvoiceNo,
                        AssetStatus = a.AssetStatus,
                        Remarks = a.Remarks
                    };
        return await query.FirstOrDefaultAsync();
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
