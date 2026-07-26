using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("trn_FuelLog")]
public partial class TrnFuelLog
{
    [Key]
    public int FuelLogId { get; set; }

    public int AssetId { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime FuelDateTime { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal FuelQty { get; set; }

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? ReadingAtFueling { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string? FuelType { get; set; }

    public string? Remarks { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? PhotoPath { get; set; }

    public int CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }

    public bool IsActive { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }
}
