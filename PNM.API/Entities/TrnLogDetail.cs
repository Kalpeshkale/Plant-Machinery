using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("trn_LogDetails")]
public partial class TrnLogDetail
{
    [Key]
    [Column("ID")]
    public long Id { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string ActionType { get; set; } = null!;

    [Column(TypeName = "datetime")]
    public DateTime ActionDateTime { get; set; }

    public int? ActionBy { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? ActionEvent { get; set; }

    public string? OldData { get; set; }

    public string? NewData { get; set; }

    [Column("LogID")]
    public int? LogId { get; set; }

    public DateOnly? LogDate { get; set; }

    [Column("ProjectID")]
    public int? ProjectId { get; set; }

    [Column("ShiftID")]
    public int? ShiftId { get; set; }

    [Column("AssetID")]
    public int? AssetId { get; set; }

    [Column("AllocationID")]
    public int? AllocationId { get; set; }

    [Column("OperatorID")]
    public int? OperatorId { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? StartDateTime { get; set; }

    [Column("StartHMR", TypeName = "decimal(18, 2)")]
    public decimal? StartHmr { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? EndDateTime { get; set; }

    [Column("EndHMR", TypeName = "decimal(18, 2)")]
    public decimal? EndHmr { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? TotalHours { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? MachineStatus { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? ProductionQty { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? ProductionUnit { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? IdleHours { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? BreakdownReason { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? SubmissionStatus { get; set; }

    public int? SubmittedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? SubmittedOn { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? RejectionReason { get; set; }

    [StringLength(1000)]
    [Unicode(false)]
    public string? Remarks { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }

    [Column("ParentLogID")]
    public int? ParentLogId { get; set; }

    [Column("SessionID")]
    [StringLength(100)]
    [Unicode(false)]
    public string? SessionId { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? LogType { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? BreakdownHours { get; set; }

    public bool? IsPhotoMandatory { get; set; }

    public bool? IsPhotoUploaded { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? EndReadingPhoto { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? RemarkPhoto { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? LunchDinnerHours { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string? LogVerificationStatus { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? LogVerificationDate { get; set; }

    [Column("StartKMR", TypeName = "decimal(18, 2)")]
    public decimal? StartKmr { get; set; }

    [Column("EndKMR", TypeName = "decimal(18, 2)")]
    public decimal? EndKmr { get; set; }
}
