using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_Type")]
[Index("TypeName", Name = "UQ_mst_AssetType_Name", IsUnique = true)]
public partial class MstType
{
    [Key]
    public int TypeId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int? CatId { get; set; }

    [StringLength(200)]
    public string TypeName { get; set; } = null!;

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [InverseProperty("Type")]
    public virtual ICollection<TblAsset> TblAssets { get; set; } = new List<TblAsset>();
}
