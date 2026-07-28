using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_Admin")]
[Index("EmpId",    Name = "UQ_tbl_Admin_EmpId",    IsUnique = true)]
[Index("UniqueId", Name = "UQ_tbl_Admin_UniqueId",  IsUnique = true)]
public partial class TblAdmin
{
    [Key]
    public int AdminId { get; set; }

    /// <summary>System-generated 8-char unique code (e.g. A1B2C3D4).</summary>
    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    /// <summary>FK → mst_Department</summary>
    public int DeptId { get; set; }

    /// <summary>FK → mst_Role  (Super Admin / Admin / Site Incharge)</summary>
    public int RoleId { get; set; }

    /// <summary>Company-issued employee ID used for login (e.g. 2509, 25091).</summary>
    [StringLength(20)]
    [Unicode(false)]
    public string EmpId { get; set; } = null!;

    /// <summary>Full display name shown in the UI.</summary>
    [StringLength(150)]
    public string FullName { get; set; } = null!;

    /// <summary>BCrypt-hashed password.</summary>
    [StringLength(500)]
    [Unicode(false)]
    public string PasswordHash { get; set; } = null!;

    [StringLength(15)]
    public string? Mobile { get; set; }

    [StringLength(100)]
    public string? Email { get; set; }

    [StringLength(500)]
    public string? PhotoPath { get; set; }

    public bool IsActive { get; set; }

    /// <summary>
    /// AdminId of the admin who created this record.
    /// For the first Super Admin this is null (created by system).
    /// Cross-table reference — no SQL FK constraint intentionally.
    /// </summary>
    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }

    // ── Navigation properties ──────────────────────────────────
    [ForeignKey("DeptId")]
    public virtual MstDepartment Dept { get; set; } = null!;

    [ForeignKey("RoleId")]
    public virtual MstRole Role { get; set; } = null!;
}
