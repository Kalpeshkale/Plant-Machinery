using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_Role")]
public partial class MstRole
{
    [Key]
    public int RoleId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [StringLength(100)]
    public string Role { get; set; } = null!;

    [StringLength(255)]
    public string? RoleDesc { get; set; }

    public bool IsActive { get; set; }

    [Precision(0)]
    public DateTime CreatedDate { get; set; }

    public int? ModifiedBy { get; set; }

    public DateTime? ModifiedOn { get; set; }

    public int? CreatedBy { get; set; }

    [InverseProperty("MenuNameNavigation")]
    public virtual ICollection<TblLeftMenu> TblLeftMenus { get; set; } = new List<TblLeftMenu>();

    [InverseProperty("Role")]
    public virtual ICollection<TblUser> TblUsers { get; set; } = new List<TblUser>();
}
