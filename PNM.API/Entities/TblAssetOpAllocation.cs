using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetOpAllocation")]
[Index("UniqueId", Name = "UQ_tbl_AssetOpAllocation_UniqueId", IsUnique = true)]
public partial class TblAssetOpAllocation
{
    [Key]
    public int AssetOpAllocId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public int AssetId { get; set; }

    public int OpId { get; set; }

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
    [InverseProperty("TblAssetOpAllocations")]
    public virtual TblAsset Asset { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("TblAssetOpAllocationCreatedByNavigations")]
    public virtual TblUser CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("TblAssetOpAllocationModifiedByNavigations")]
    public virtual TblUser? ModifiedByNavigation { get; set; }

    [ForeignKey("OpId")]
    [InverseProperty("TblAssetOpAllocations")]
    public virtual TblOperator Op { get; set; } = null!;
}
