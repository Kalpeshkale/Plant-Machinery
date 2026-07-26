using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("trn_DailyLog")]
[Index("UniqueId", Name = "UQ_trn_DailyLog_UniqueId", IsUnique = true)]
public partial class TrnDailyLog
{
    [Key]
    public int DailyLogId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public DateOnly LogDate { get; set; }

    public int ProjId { get; set; }

    public int AssetId { get; set; }

    public int OpId { get; set; }

    public int ShiftId { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal StartReading { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal EndReading { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal TotalReading { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? FuelIssued { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? FuelBalance { get; set; }

    [Column(TypeName = "decimal(10, 2)")]
    public decimal? WorkingHours { get; set; }

    public bool Breakdown { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? BreakdownRemarks { get; set; }

    [StringLength(1000)]
    [Unicode(false)]
    public string? WorkDescription { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? StartReadingPhoto { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? EndReadingPhoto { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? OperatorRemarks { get; set; }

    [Column("SICStatus")]
    [StringLength(20)]
    [Unicode(false)]
    public string Sicstatus { get; set; } = null!;

    [Column("SICBy")]
    public int? Sicby { get; set; }

    [Column("SICOn")]
    [Precision(0)]
    public DateTime? Sicon { get; set; }

    [Column("SICRemarks")]
    [StringLength(500)]
    [Unicode(false)]
    public string? Sicremarks { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string AdminStatus { get; set; } = null!;

    public int? AdminBy { get; set; }

    [Precision(0)]
    public DateTime? AdminOn { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? AdminRemarks { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [ForeignKey("AdminBy")]
    [InverseProperty("TrnDailyLogAdminByNavigations")]
    public virtual TblUser? AdminByNavigation { get; set; }

    [ForeignKey("AssetId")]
    [InverseProperty("TrnDailyLogs")]
    public virtual TblAsset Asset { get; set; } = null!;

    [ForeignKey("CreatedBy")]
    [InverseProperty("TrnDailyLogCreatedByNavigations")]
    public virtual TblUser CreatedByNavigation { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("TrnDailyLogModifiedByNavigations")]
    public virtual TblUser? ModifiedByNavigation { get; set; }

    [ForeignKey("OpId")]
    [InverseProperty("TrnDailyLogs")]
    public virtual TblOperator Op { get; set; } = null!;

    [ForeignKey("ProjId")]
    [InverseProperty("TrnDailyLogs")]
    public virtual TblProject Proj { get; set; } = null!;

    [ForeignKey("ShiftId")]
    [InverseProperty("TrnDailyLogs")]
    public virtual MstShift Shift { get; set; } = null!;

    [ForeignKey("Sicby")]
    [InverseProperty("TrnDailyLogSicbyNavigations")]
    public virtual TblUser? SicbyNavigation { get; set; }
}
