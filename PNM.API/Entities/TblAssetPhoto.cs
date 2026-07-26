using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetPhoto")]
public partial class TblAssetPhoto
{
    [Key]
    public int PhotoId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int AssetId { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string PhotoType { get; set; } = null!;

    [StringLength(500)]
    public string PhotoPath { get; set; } = null!;

    public int? DisplayOrder { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }
}
