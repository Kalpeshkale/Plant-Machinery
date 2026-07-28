using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_User")]
[Index("EmpId", Name = "UQ_tbl_User_EmpId", IsUnique = true)]
[Index("UniqueId", Name = "UQ_tbl_User_UniqueId", IsUnique = true)]
[Index("UserName", Name = "UQ_tbl_User_UserName", IsUnique = true)]
public partial class TblUser
{
    [Key]
    public int UserId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public int DeptId { get; set; }

    public int RoleId { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string EmpId { get; set; } = null!;

    [StringLength(50)]
    [Unicode(false)]
    public string UserName { get; set; } = null!;

    [StringLength(500)]
    [Unicode(false)]
    public string PasswordHash { get; set; } = null!;

    public bool IsActive { get; set; }

    // ── Operator-specific fields (null for Admin/SIC rows) ────────────────

    /// <summary>Operator code — also used as EmpId for login.</summary>
    [StringLength(10)]
    public string? OpCode { get; set; }

    /// <summary>Type of operator e.g. Driver, Crane Operator.</summary>
    [StringLength(100)]
    public string? OpType { get; set; }

    [StringLength(150)]
    public string? FullName { get; set; }

    public DateOnly? DateOfBirth { get; set; }

    [StringLength(10)]
    public string? Gender { get; set; }

    [StringLength(15)]
    public string? Mobile { get; set; }

    [StringLength(20)]
    public string? AadhaarNo { get; set; }

    [StringLength(30)]
    public string? LicenseNo { get; set; }

    [StringLength(300)]
    public string? Address { get; set; }

    [Column("DOJ")]
    public DateOnly? Doj { get; set; }

    /// <summary>Employment status e.g. Active, On Leave, Resigned.</summary>
    [StringLength(20)]
    public string? Status { get; set; }

    [StringLength(500)]
    public string? PhotoPath { get; set; }

    // ─────────────────────────────────────────────────────────────────────

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }

    // CreatedBy and ModifiedBy store AdminId from tbl_Admin (cross-table, no FK enforced).
    // Self-referential FK constraints FK_tbl_User_CreatedBy / FK_tbl_User_ModifiedBy
    // were intentionally dropped from the database.

    [ForeignKey("DeptId")]
    [InverseProperty("TblUsers")]
    public virtual MstDepartment Dept { get; set; } = null!;

    [ForeignKey("RoleId")]
    [InverseProperty("TblUsers")]
    public virtual MstRole Role { get; set; } = null!;

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TblAssetCompliance> TblAssetComplianceCreatedByNavigations { get; set; } = new List<TblAssetCompliance>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TblAssetCompliance> TblAssetComplianceModifiedByNavigations { get; set; } = new List<TblAssetCompliance>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TblAsset> TblAssetCreatedByNavigations { get; set; } = new List<TblAsset>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TblAsset> TblAssetModifiedByNavigations { get; set; } = new List<TblAsset>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TblAssetOpAllocation> TblAssetOpAllocationCreatedByNavigations { get; set; } = new List<TblAssetOpAllocation>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TblAssetOpAllocation> TblAssetOpAllocationModifiedByNavigations { get; set; } = new List<TblAssetOpAllocation>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TblProjAssetAllocation> TblProjAssetAllocationCreatedByNavigations { get; set; } = new List<TblProjAssetAllocation>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TblProjAssetAllocation> TblProjAssetAllocationModifiedByNavigations { get; set; } = new List<TblProjAssetAllocation>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TblProjOpAllocation> TblProjOpAllocationCreatedByNavigations { get; set; } = new List<TblProjOpAllocation>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TblProjOpAllocation> TblProjOpAllocationModifiedByNavigations { get; set; } = new List<TblProjOpAllocation>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TblProject> TblProjectCreatedByNavigations { get; set; } = new List<TblProject>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TblProject> TblProjectModifiedByNavigations { get; set; } = new List<TblProject>();

    [InverseProperty("ProjectManager")]
    public virtual ICollection<TblProject> TblProjectProjectManagers { get; set; } = new List<TblProject>();

    [InverseProperty("SiteInCharge")]
    public virtual ICollection<TblProject> TblProjectSiteInCharges { get; set; } = new List<TblProject>();

    [InverseProperty("AdminByNavigation")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogAdminByNavigations { get; set; } = new List<TrnDailyLog>();

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogCreatedByNavigations { get; set; } = new List<TrnDailyLog>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogModifiedByNavigations { get; set; } = new List<TrnDailyLog>();

    [InverseProperty("SicbyNavigation")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogSicbyNavigations { get; set; } = new List<TrnDailyLog>();
}
