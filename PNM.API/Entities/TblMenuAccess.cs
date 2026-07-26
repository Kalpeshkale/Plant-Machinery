using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_MenuAccess")]
[Index("EmployeeId", "PermissionKey", Name = "UQ_EmpMenuAccess", IsUnique = true)]
public partial class TblMenuAccess
{
    [Key]
    [Column("AccessID")]
    public int AccessId { get; set; }

    [Column("EmployeeID")]
    public int EmployeeId { get; set; }

    [StringLength(50)]
    public string PermissionKey { get; set; } = null!;

    public bool? IsActive { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? CreatedDate { get; set; }
}
