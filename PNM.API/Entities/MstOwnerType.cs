using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_OwnerType")]
public partial class MstOwnerType
{
    [Key]
    public int OwnerId { get; set; }

    [StringLength(100)]
    public string OwnerType { get; set; } = null!;

    public bool IsActive { get; set; }

    public int SortOrder { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [InverseProperty("Owner")]
    public virtual ICollection<TblAsset> TblAssets { get; set; } = new List<TblAsset>();
}
