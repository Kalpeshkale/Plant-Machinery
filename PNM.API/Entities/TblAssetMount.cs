using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetMount")]
public partial class TblAssetMount
{
    [Key]
    public int MountId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [StringLength(100)]
    [Unicode(false)]
    public string MountCode { get; set; } = null!;

    public int VirtualAssetId { get; set; }

    public int ChassisAssetId { get; set; }

    public int UpperAssetId { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime MountedOn { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? UnmountedOn { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }
}
