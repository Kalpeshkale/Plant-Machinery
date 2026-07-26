using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_Department")]
public partial class MstDepartment
{
    [Key]
    public int DeptId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int? OwnerId { get; set; }

    [StringLength(200)]
    public string DeptName { get; set; } = null!;

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }

    [InverseProperty("Dept")]
    public virtual ICollection<TblAsset> TblAssets { get; set; } = new List<TblAsset>();

    [InverseProperty("Dept")]
    public virtual ICollection<TblProject> TblProjects { get; set; } = new List<TblProject>();

    [InverseProperty("Dept")]
    public virtual ICollection<TblUser> TblUsers { get; set; } = new List<TblUser>();
}
