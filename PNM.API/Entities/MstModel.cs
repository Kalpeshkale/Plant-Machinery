using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_Model")]
public partial class MstModel
{
    [Key]
    public int ModelId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int MakeId { get; set; }

    [StringLength(200)]
    public string ModelNo { get; set; } = null!;

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [ForeignKey("MakeId")]
    [InverseProperty("MstModels")]
    public virtual MstMake Make { get; set; } = null!;

    [InverseProperty("Model")]
    public virtual ICollection<TblAsset> TblAssets { get; set; } = new List<TblAsset>();
}
