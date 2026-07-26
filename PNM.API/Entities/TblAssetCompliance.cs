using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetCompliance")]
[Index("UniqueId", Name = "UQ_tbl_AssetCompliance_UniqueId", IsUnique = true)]
public partial class TblAssetCompliance
{
    [Key]
    public int ComplianceId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public int AssetId { get; set; }

    public DateOnly? InsuranceExpDate { get; set; }

    [Column("PUCExpDate")]
    public DateOnly? PucexpDate { get; set; }

    public DateOnly? FitnessExpDate { get; set; }

    public DateOnly? PermitExpDate { get; set; }

    public DateOnly? RoadTaxExpDate { get; set; }

    [Column("RTOExpDate")]
    public DateOnly? RtoexpDate { get; set; }

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

    [ForeignKey("AssetId")]
    [InverseProperty("TblAssetCompliances")]
    public virtual TblAsset Asset { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("TblAssetComplianceCreatedByNavigations")]
    public virtual TblUser CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("TblAssetComplianceModifiedByNavigations")]
    public virtual TblUser? ModifiedByNavigation { get; set; }
}
