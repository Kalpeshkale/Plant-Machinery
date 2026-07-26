using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_Project")]
[Index("ProjCode", Name = "UQ_tbl_Project_ProjCode", IsUnique = true)]
[Index("UniqueId", Name = "UQ_tbl_Project_UniqueId", IsUnique = true)]
public partial class TblProject
{
    [Key]
    public int ProjId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string UniqueId { get; set; } = null!;

    public int DeptId { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string ProjCode { get; set; } = null!;

    [StringLength(150)]
    public string ProjName { get; set; } = null!;

    [StringLength(150)]
    public string? ClientName { get; set; }

    [StringLength(250)]
    public string Location { get; set; } = null!;

    public int? SiteInChargeId { get; set; }

    public int? ProjectManagerId { get; set; }

    public DateOnly? StartDate { get; set; }

    public DateOnly? EndDate { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string ProjStatus { get; set; } = null!;

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Precision(0)]
    public DateTime? ModifiedOn { get; set; }

    [ForeignKey("CreatedBy")]
    [InverseProperty("TblProjectCreatedByNavigations")]
    public virtual TblUser CreatedByNavigation { get; set; } = null!;

    [ForeignKey("DeptId")]
    [InverseProperty("TblProjects")]
    public virtual MstDepartment Dept { get; set; } = null!;

    [ForeignKey("ModifiedBy")]
    [InverseProperty("TblProjectModifiedByNavigations")]
    public virtual TblUser? ModifiedByNavigation { get; set; }

    [ForeignKey("ProjectManagerId")]
    [InverseProperty("TblProjectProjectManagers")]
    public virtual TblUser? ProjectManager { get; set; }

    [ForeignKey("SiteInChargeId")]
    [InverseProperty("TblProjectSiteInCharges")]
    public virtual TblUser? SiteInCharge { get; set; }

    [InverseProperty("Proj")]
    public virtual ICollection<TblProjAssetAllocation> TblProjAssetAllocations { get; set; } = new List<TblProjAssetAllocation>();

    [InverseProperty("Proj")]
    public virtual ICollection<TblProjOpAllocation> TblProjOpAllocations { get; set; } = new List<TblProjOpAllocation>();

    [InverseProperty("Proj")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogs { get; set; } = new List<TrnDailyLog>();
}
