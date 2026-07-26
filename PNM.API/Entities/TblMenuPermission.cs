using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_MenuPermission")]
public partial class TblMenuPermission
{
    [Key]
    public int Id { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [StringLength(50)]
    public string PerKey { get; set; } = null!;

    [StringLength(100)]
    public string MenuName { get; set; } = null!;

    public int SortOrder { get; set; }

    public bool IsActive { get; set; }

    [StringLength(100)]
    public string? ParentKey { get; set; }

    [StringLength(20)]
    public string? MenuType { get; set; }

    [StringLength(100)]
    public string? ViewName { get; set; }

    [StringLength(100)]
    public string? IconClass { get; set; }

    public bool IsVisible { get; set; }

    [InverseProperty("MenuDescNavigation")]
    public virtual ICollection<TblLeftMenu> TblLeftMenus { get; set; } = new List<TblLeftMenu>();
}
