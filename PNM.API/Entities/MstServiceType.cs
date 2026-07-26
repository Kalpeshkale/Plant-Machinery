using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_ServiceType")]
public partial class MstServiceType
{
    [Key]
    public int ServTypeId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int ServiAreaId { get; set; }

    [StringLength(200)]
    public string ServTypeName { get; set; } = null!;

    [Column(TypeName = "decimal(18, 2)")]
    public decimal? ApproximateCost { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }
}
