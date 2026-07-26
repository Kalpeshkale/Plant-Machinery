using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("trn_ConcreteEntry")]
public partial class TrnConcreteEntry
{
    [Key]
    public int Id { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [StringLength(50)]
    public string InfoProviderEmployeeId { get; set; } = null!;

    [StringLength(50)]
    public string CustomerId { get; set; } = null!;

    [StringLength(50)]
    public string SiteId { get; set; } = null!;

    [StringLength(50)]
    public string PlantId { get; set; } = null!;

    [Column(TypeName = "datetime")]
    public DateTime StartDateTime { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime StopDateTime { get; set; }

    public int? BreakdownHours { get; set; }

    public int? BreakdownMinutes { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? Volume { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? DieselReceived { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? DieselRate { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? CementReceivedKg { get; set; }

    [Column("HMR", TypeName = "decimal(18, 2)")]
    public decimal? Hmr { get; set; }

    [Column("MixerHMR", TypeName = "decimal(18, 2)")]
    public decimal? MixerHmr { get; set; }

    [StringLength(100)]
    public string? ConcreteType { get; set; }

    [StringLength(100)]
    public string? PourLocation { get; set; }

    [StringLength(150)]
    public string? InChargeCustomer { get; set; }

    [StringLength(150)]
    public string? InChargeRohan { get; set; }

    public string? NoteText { get; set; }

    [StringLength(50)]
    public string CreatedBy { get; set; } = null!;

    [StringLength(150)]
    public string? CreatedUserName { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedDate { get; set; }

    [StringLength(50)]
    public string? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedDate { get; set; }

    public bool IsActive { get; set; }
}
