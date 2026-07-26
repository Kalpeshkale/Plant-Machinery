using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_ProjAssetAllocation")]
[Index("UniqueId", Name = "UQ_tbl_ProjAssetAllocation_UniqueId", IsUnique = true)]
public partial class TblProjAssetAllocation
{
    [Key]
    public int ProjAssetAllocId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public int ProjId { get; set; }

    public int AssetId { get; set; }

    public DateOnly AllocationDate { get; set; }

    public DateOnly? ReleaseDate { get; set; }

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
    [InverseProperty("TblProjAssetAllocations")]
    public virtual TblAsset Asset { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("TblProjAssetAllocationCreatedByNavigations")]
    public virtual TblUser CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("TblProjAssetAllocationModifiedByNavigations")]
    public virtual TblUser? ModifiedByNavigation { get; set; }

    [ForeignKey("ProjId")]
    [InverseProperty("TblProjAssetAllocations")]
    public virtual TblProject Proj { get; set; } = null!;
}
