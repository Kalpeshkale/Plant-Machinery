using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_Operator")]
[Index("OpCode", Name = "UQ_mst_Operator_Code", IsUnique = true)]
public partial class TblOperator
{
    [Key]
    public int OpId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [StringLength(10)]
    public string OpCode { get; set; } = null!;

    [StringLength(100)]
    public string? OpType { get; set; }

    [StringLength(150)]
    public string FullName { get; set; } = null!;

    public DateOnly? DateOfBirth { get; set; }

    [StringLength(10)]
    public string? Gender { get; set; }

    [StringLength(15)]
    public string? Mobile { get; set; }

    [StringLength(20)]
    public string? AadhaarNo { get; set; }

    [StringLength(30)]
    public string? LicenseNo { get; set; }

    [StringLength(300)]
    public string? Address { get; set; }

    [Column("DOJ")]
    public DateOnly? Doj { get; set; }

    [StringLength(20)]
    public string? Status { get; set; }

    [StringLength(500)]
    public string? PhotoPath { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [InverseProperty("Op")]
    public virtual ICollection<TblAssetOpAllocation> TblAssetOpAllocations { get; set; } = new List<TblAssetOpAllocation>();

    [InverseProperty("Op")]
    public virtual ICollection<TblProjOpAllocation> TblProjOpAllocations { get; set; } = new List<TblProjOpAllocation>();

    [InverseProperty("Op")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogs { get; set; } = new List<TrnDailyLog>();
}
