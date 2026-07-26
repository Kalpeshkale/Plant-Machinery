using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_LeftMenu")]
public partial class TblLeftMenu
{
    [Key]
    public int Id { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int MenuName { get; set; }

    public int MenuDesc { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    public DateTime? CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    public DateTime? ModifiedOn { get; set; }

    [ForeignKey("MenuDesc")]
    [InverseProperty("TblLeftMenus")]
    public virtual TblMenuPermission MenuDescNavigation { get; set; } = null!;

    [ForeignKey("MenuName")]
    [InverseProperty("TblLeftMenus")]
    public virtual MstRole MenuNameNavigation { get; set; } = null!;
}
