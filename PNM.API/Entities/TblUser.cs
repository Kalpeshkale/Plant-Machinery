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

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("InverseCreatedByNavigation")]
    public virtual TblUser? CreatedByNavigation { get; set; }

    [ForeignKey("DeptId")]
    [InverseProperty("TblUsers")]
    public virtual MstDepartment Dept { get; set; } = null!;

    [InverseProperty("CreatedByNavigation")]
    public virtual ICollection<TblUser> InverseCreatedByNavigation { get; set; } = new List<TblUser>();

    [InverseProperty("ModifiedByNavigation")]
    public virtual ICollection<TblUser> InverseModifiedByNavigation { get; set; } = new List<TblUser>();

    [ForeignKey("ModifiedBy")]
    [InverseProperty("InverseModifiedByNavigation")]
    public virtual TblUser? ModifiedByNavigation { get; set; }

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
