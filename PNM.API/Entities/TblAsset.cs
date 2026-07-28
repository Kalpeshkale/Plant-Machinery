using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_Asset")]
[Index("AssetCode", Name = "UQ_tbl_Asset_AssetCode", IsUnique = true)]
[Index("UniqueId", Name = "UQ_tbl_Asset_UniqueId", IsUnique = true)]
public partial class TblAsset
{
    [Key]
    public int AssetId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public int DeptId { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string AssetCode { get; set; } = null!;

    [StringLength(150)]
    [Unicode(false)]
    public string AssetName { get; set; } = null!;

    public int? CatId { get; set; }  // nullable — Category not used

    public int TypeId { get; set; }

    public int SubTypeId { get; set; }

    public int MakeId { get; set; }

    public int ModelId { get; set; }

    public int OwnerId { get; set; }

    [StringLength(30)]
    [Unicode(false)]
    public string? RegistrationNo { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string? ChassisNo { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string? EngineNo { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string? SerialNo { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string? MeterType { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal CurrentMeterReading { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string? FuelType { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal? FuelTankCapacity { get; set; }

    public DateOnly? PurchaseDate { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? PurchaseCost { get; set; }

    [StringLength(150)]
    [Unicode(false)]
    public string? SupplierName { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string? InvoiceNo { get; set; }

    [StringLength(30)]
    [Unicode(false)]
    public string AssetStatus { get; set; } = null!;

    [StringLength(500)]
    [Unicode(false)]
    public string? Remarks { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [ForeignKey("CatId")]
    [InverseProperty("TblAssets")]
    public virtual MstCategory? Cat { get; set; }  // optional — CatId is nullable

    [ForeignKey("CreatedBy")]
    [InverseProperty("TblAssetCreatedByNavigations")]
    public virtual TblUser CreatedByNavigation { get; set; } = null!;

    [ForeignKey("DeptId")]
    [InverseProperty("TblAssets")]
    public virtual MstDepartment Dept { get; set; } = null!;

    [ForeignKey("MakeId")]
    [InverseProperty("TblAssets")]
    public virtual MstMake Make { get; set; } = null!;

    [ForeignKey("ModelId")]
    [InverseProperty("TblAssets")]
    public virtual MstModel Model { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("TblAssetModifiedByNavigations")]
    public virtual TblUser? ModifiedByNavigation { get; set; }

    [ForeignKey("OwnerId")]
    [InverseProperty("TblAssets")]
    public virtual MstOwnerType Owner { get; set; } = null!;

    [ForeignKey("SubTypeId")]
    [InverseProperty("TblAssets")]
    public virtual MstSubType SubType { get; set; } = null!;

    [InverseProperty("Asset")]
    public virtual ICollection<TblAssetCompliance> TblAssetCompliances { get; set; } = new List<TblAssetCompliance>();

    [InverseProperty("Asset")]
    public virtual ICollection<TblAssetOpAllocation> TblAssetOpAllocations { get; set; } = new List<TblAssetOpAllocation>();

    [InverseProperty("Asset")]
    public virtual ICollection<TblProjAssetAllocation> TblProjAssetAllocations { get; set; } = new List<TblProjAssetAllocation>();

    [InverseProperty("Asset")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogs { get; set; } = new List<TrnDailyLog>();

    [ForeignKey("TypeId")]
    [InverseProperty("TblAssets")]
    public virtual MstType Type { get; set; } = null!;
}
