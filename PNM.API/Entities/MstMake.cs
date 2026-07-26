using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_Make")]
public partial class MstMake
{
    [Key]
    public int MakeId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int? SubTypeId { get; set; }

    [StringLength(200)]
    public string MakeName { get; set; } = null!;

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [InverseProperty("Make")]
    public virtual ICollection<MstModel> MstModels { get; set; } = new List<MstModel>();

    [InverseProperty("Make")]
    public virtual ICollection<TblAsset> TblAssets { get; set; } = new List<TblAsset>();
}
