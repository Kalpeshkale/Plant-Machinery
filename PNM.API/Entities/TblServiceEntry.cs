using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_ServiceEntry")]
public partial class TblServiceEntry
{
    [Key]
    public int ServiceEntryId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int? ScheduleId { get; set; }

    [StringLength(100)]
    public string EntryId { get; set; } = null!;

    [StringLength(200)]
    public string? Employee { get; set; }

    [StringLength(100)]
    public string MachineId { get; set; } = null!;

    [Column("HMR", TypeName = "decimal(18, 2)")]
    public decimal? Hmr { get; set; }

    [Column("KMR", TypeName = "decimal(18, 2)")]
    public decimal? Kmr { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? Cum { get; set; }

    [StringLength(200)]
    public string ServiceArea { get; set; } = null!;

    [StringLength(200)]
    public string ServiceType { get; set; } = null!;

    public string? ServiceDetail { get; set; }

    [StringLength(200)]
    public string? ServiceLocation { get; set; }

    [StringLength(50)]
    public string? ServiceDate { get; set; }

    [StringLength(50)]
    public string? ServiceTime { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? ServiceAmount { get; set; }

    [StringLength(200)]
    public string? DoneBy { get; set; }

    [StringLength(200)]
    public string? Supervisor { get; set; }

    [StringLength(200)]
    public string? InstructedBy { get; set; }

    [StringLength(500)]
    public string? WasteMaterial { get; set; }

    [StringLength(10)]
    public string? HasAttachment { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }

    [Column("CategoryID")]
    public int? CategoryId { get; set; }

    [Column("AssetTypeID")]
    public int? AssetTypeId { get; set; }

    [Column("MakeID")]
    public int? MakeId { get; set; }

    [Column("ModelID")]
    public int? ModelId { get; set; }

    [Column("ServiceTypeID")]
    [StringLength(100)]
    public string? ServiceTypeId { get; set; }
}
