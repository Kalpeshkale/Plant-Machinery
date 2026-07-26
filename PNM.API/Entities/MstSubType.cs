using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_SubType")]
public partial class MstSubType
{
    [Key]
    public int SubTypeId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int? TypeId { get; set; }

    [StringLength(200)]
    public string SubTypeName { get; set; } = null!;

    [StringLength(50)]
    public string? AssetUnit { get; set; }

    [StringLength(50)]
    public string? OutputUnit { get; set; }

    [StringLength(50)]
    public string? FuelType { get; set; }

    [StringLength(50)]
    public string? FuelUnit { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [InverseProperty("SubType")]
    public virtual ICollection<TblAsset> TblAssets { get; set; } = new List<TblAsset>();
}
