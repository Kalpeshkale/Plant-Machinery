using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_ProjOpAllocation")]
[Index("UniqueId", Name = "UQ_tbl_ProjOpAllocation_UniqueId", IsUnique = true)]
public partial class TblProjOpAllocation
{
    [Key]
    public int ProjOpAllocId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public int ProjId { get; set; }

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

    [ForeignKey("CreatedBy")]
    [InverseProperty("TblProjOpAllocationCreatedByNavigations")]
    public virtual TblUser CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("TblProjOpAllocationModifiedByNavigations")]
    public virtual TblUser? ModifiedByNavigation { get; set; }

    [ForeignKey("OpId")]
    [InverseProperty("TblProjOpAllocations")]
    public virtual TblOperator Op { get; set; } = null!;

    [ForeignKey("ProjId")]
    [InverseProperty("TblProjOpAllocations")]
    public virtual TblProject Proj { get; set; } = null!;
}
