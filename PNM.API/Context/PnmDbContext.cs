using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using PNM.Infrastructure.Entities;

namespace PNM.Infrastructure.Context;

public partial class PnmDbContext : DbContext
{
    public PnmDbContext()
    {
    }

    public PnmDbContext(DbContextOptions<PnmDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<MstCategory> MstCategories { get; set; }

    public virtual DbSet<MstDepartment> MstDepartments { get; set; }

    public virtual DbSet<MstMake> MstMakes { get; set; }

    public virtual DbSet<MstModel> MstModels { get; set; }

    public virtual DbSet<MstOwnerType> MstOwnerTypes { get; set; }

    public virtual DbSet<MstRole> MstRoles { get; set; }

    public virtual DbSet<MstServiceArea> MstServiceAreas { get; set; }

    public virtual DbSet<MstServiceType> MstServiceTypes { get; set; }

    public virtual DbSet<MstShift> MstShifts { get; set; }

    public virtual DbSet<MstSubType> MstSubTypes { get; set; }

    public virtual DbSet<MstType> MstTypes { get; set; }

    public virtual DbSet<TblAsset> TblAssets { get; set; }

    public virtual DbSet<TblAssetCompliance> TblAssetCompliances { get; set; }

    public virtual DbSet<TblAssetDoc> TblAssetDocs { get; set; }

    public virtual DbSet<TblAssetDocDetail> TblAssetDocDetails { get; set; }

    public virtual DbSet<TblAssetDocType> TblAssetDocTypes { get; set; }

    public virtual DbSet<TblAssetDocTypeField> TblAssetDocTypeFields { get; set; }

    public virtual DbSet<TblAssetMount> TblAssetMounts { get; set; }

    public virtual DbSet<TblAssetOpAllocation> TblAssetOpAllocations { get; set; }

    public virtual DbSet<TblAssetPhoto> TblAssetPhotos { get; set; }

    public virtual DbSet<TblLeftMenu> TblLeftMenus { get; set; }

    public virtual DbSet<TblLog> TblLogs { get; set; }

    public virtual DbSet<TblMenuAccess> TblMenuAccesses { get; set; }

    public virtual DbSet<TblMenuPermission> TblMenuPermissions { get; set; }

    public virtual DbSet<TblOperator> TblOperators { get; set; }

    public virtual DbSet<TblProjAssetAllocation> TblProjAssetAllocations { get; set; }

    public virtual DbSet<TblProjOpAllocation> TblProjOpAllocations { get; set; }

    public virtual DbSet<TblProject> TblProjects { get; set; }

    public virtual DbSet<TblServiceAttachment> TblServiceAttachments { get; set; }

    public virtual DbSet<TblServiceEntry> TblServiceEntries { get; set; }

    public virtual DbSet<TblServiceSchedule> TblServiceSchedules { get; set; }

    public virtual DbSet<TblUser> TblUsers { get; set; }

    public virtual DbSet<TrnConcreteEntry> TrnConcreteEntries { get; set; }

    public virtual DbSet<TrnDailyLog> TrnDailyLogs { get; set; }

    public virtual DbSet<TrnFuelLog> TrnFuelLogs { get; set; }

    public virtual DbSet<TrnLogDetail> TrnLogDetails { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=LABREZ;Database=DB_PNM_Testing;Trusted_Connection=True;TrustServerCertificate=True;");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<MstCategory>(entity =>
        {
            entity.HasKey(e => e.CatId).HasName("PK_mst_AssetCat");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstDepartment>(entity =>
        {
            entity.HasKey(e => e.DeptId).HasName("PK_mst_Division");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstMake>(entity =>
        {
            entity.HasKey(e => e.MakeId).HasName("PK_mst_AssetMake");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstModel>(entity =>
        {
            entity.HasKey(e => e.ModelId).HasName("PK_mst_AssetModel");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");

            entity.HasOne(d => d.Make).WithMany(p => p.MstModels)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_mst_AssetModel_MakeID");
        });

        modelBuilder.Entity<MstOwnerType>(entity =>
        {
            entity.HasKey(e => e.OwnerId).HasName("PK_mst_OwnershipType");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstRole>(entity =>
        {
            entity.HasKey(e => e.RoleId).HasName("PK__mst_Role__8AFACE3A5D52F56A");

            entity.Property(e => e.CreatedDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstServiceArea>(entity =>
        {
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstServiceType>(entity =>
        {
            entity.Property(e => e.ServTypeId).ValueGeneratedNever();
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstShift>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(sysutcdatetime())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstSubType>(entity =>
        {
            entity.HasKey(e => e.SubTypeId).HasName("PK_mst_AssetSubType");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<MstType>(entity =>
        {
            entity.HasKey(e => e.TypeId).HasName("PK_mst_AssetType");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(sysutcdatetime())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<TblAsset>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.Cat).WithMany(p => p.TblAssets)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_Category");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TblAssetCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_CreatedBy");

            entity.HasOne(d => d.Dept).WithMany(p => p.TblAssets)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_Department");

            entity.HasOne(d => d.Make).WithMany(p => p.TblAssets)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_Make");

            entity.HasOne(d => d.Model).WithMany(p => p.TblAssets)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_Model");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.TblAssetModifiedByNavigations).HasConstraintName("FK_tbl_Asset_ModifiedBy");

            entity.HasOne(d => d.Owner).WithMany(p => p.TblAssets)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_OwnerType");

            entity.HasOne(d => d.SubType).WithMany(p => p.TblAssets)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_SubType");

            entity.HasOne(d => d.Type).WithMany(p => p.TblAssets)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Asset_Type");
        });

        modelBuilder.Entity<TblAssetCompliance>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.Asset).WithMany(p => p.TblAssetCompliances)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AssetCompliance_Asset");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TblAssetComplianceCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AssetCompliance_CreatedBy");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.TblAssetComplianceModifiedByNavigations).HasConstraintName("FK_AssetCompliance_ModifiedBy");
        });

        modelBuilder.Entity<TblAssetDoc>(entity =>
        {
            entity.HasKey(e => e.AttachmentId).HasName("PK__trn_Asse__442C64DE18970D8B");

            entity.Property(e => e.CreatedDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
            entity.Property(e => e.UploadDate).HasDefaultValueSql("(getdate())");

            entity.HasOne(d => d.DocumentType).WithMany(p => p.TblAssetDocs)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_trn_AssetDocumentAttachment_DocumentType");
        });

        modelBuilder.Entity<TblAssetDocDetail>(entity =>
        {
            entity.HasKey(e => e.AttachDetailId).HasName("PK__trn_Asse__21B0D81101C65A8C");

            entity.Property(e => e.CreatedDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");

            entity.HasOne(d => d.Attachment).WithMany(p => p.TblAssetDocDetails)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_trn_AssetDocumentAttachmentDetail_Attachment");

            entity.HasOne(d => d.DocumentField).WithMany(p => p.TblAssetDocDetails)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_trn_AssetDocumentAttachmentDetail_Field");
        });

        modelBuilder.Entity<TblAssetDocType>(entity =>
        {
            entity.HasKey(e => e.DocTypeId).HasName("PK__mst_Asse__DBA390C17A7F1302");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<TblAssetDocTypeField>(entity =>
        {
            entity.HasKey(e => e.DocumentFieldId).HasName("PK__tbl_Asse__BA65003E0784B8B3");

            entity.Property(e => e.CreatedDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.IsMandatory).HasDefaultValue(true);

            entity.HasOne(d => d.DocumentType).WithMany(p => p.TblAssetDocTypeFields)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_mst_AssetDocumentTypeField_DocumentType");
        });

        modelBuilder.Entity<TblAssetMount>(entity =>
        {
            entity.HasKey(e => e.MountId).HasName("PK__trn_Asse__652265602E3F8E0E");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.MountedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<TblAssetOpAllocation>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.Asset).WithMany(p => p.TblAssetOpAllocations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AssetOpAllocation_Asset");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TblAssetOpAllocationCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AssetOpAllocation_CreatedBy");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.TblAssetOpAllocationModifiedByNavigations).HasConstraintName("FK_AssetOpAllocation_ModifiedBy");

            entity.HasOne(d => d.Op).WithMany(p => p.TblAssetOpAllocations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_AssetOpAllocation_Operator");
        });

        modelBuilder.Entity<TblAssetPhoto>(entity =>
        {
            entity.HasKey(e => e.PhotoId).HasName("PK__trn_Asse__B387C216A8B12A8F");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<TblLeftMenu>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__mst_Role__F325A47D7D3E5570");

            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");

            entity.HasOne(d => d.MenuDescNavigation).WithMany(p => p.TblLeftMenus)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__mst_RoleM__Permi__76619304");

            entity.HasOne(d => d.MenuNameNavigation).WithMany(p => p.TblLeftMenus)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__mst_RoleM__RoleI__36470DEF");
        });

        modelBuilder.Entity<TblLog>(entity =>
        {
            entity.Property(e => e.CreatedDate).HasDefaultValueSql("(getdate())");
        });

        modelBuilder.Entity<TblMenuAccess>(entity =>
        {
            entity.HasKey(e => e.AccessId).HasName("PK__tbl_Menu__4130D0BF22ED946D");

            entity.Property(e => e.CreatedDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
        });

        modelBuilder.Entity<TblMenuPermission>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__mst_Menu__EFA6FB0F90D215BF");

            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.IsVisible).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<TblOperator>(entity =>
        {
            entity.HasKey(e => e.OpId).HasName("PK_mst_Operator");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(sysutcdatetime())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.Status).HasDefaultValue("Active");
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<TblProjAssetAllocation>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.Asset).WithMany(p => p.TblProjAssetAllocations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProjAssetAllocation_Asset");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TblProjAssetAllocationCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProjAssetAllocation_CreatedBy");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.TblProjAssetAllocationModifiedByNavigations).HasConstraintName("FK_ProjAssetAllocation_ModifiedBy");

            entity.HasOne(d => d.Proj).WithMany(p => p.TblProjAssetAllocations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProjAssetAllocation_Project");
        });

        modelBuilder.Entity<TblProjOpAllocation>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TblProjOpAllocationCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProjOpAllocation_CreatedBy");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.TblProjOpAllocationModifiedByNavigations).HasConstraintName("FK_ProjOpAllocation_ModifiedBy");

            entity.HasOne(d => d.Op).WithMany(p => p.TblProjOpAllocations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProjOpAllocation_Operator");

            entity.HasOne(d => d.Proj).WithMany(p => p.TblProjOpAllocations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_ProjOpAllocation_Project");
        });

        modelBuilder.Entity<TblProject>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TblProjectCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Project_CreatedBy");

            entity.HasOne(d => d.Dept).WithMany(p => p.TblProjects)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_Project_Department");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.TblProjectModifiedByNavigations).HasConstraintName("FK_tbl_Project_ModifiedBy");

            entity.HasOne(d => d.ProjectManager).WithMany(p => p.TblProjectProjectManagers).HasConstraintName("FK_tbl_Project_ProjectManager");

            entity.HasOne(d => d.SiteInCharge).WithMany(p => p.TblProjectSiteInCharges).HasConstraintName("FK_tbl_Project_SiteInCharge");
        });

        modelBuilder.Entity<TblServiceAttachment>(entity =>
        {
            entity.HasKey(e => e.AttachmentId).HasName("PK__tbl_Serv__442C64DED9D251D0");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
        });

        modelBuilder.Entity<TblServiceEntry>(entity =>
        {
            entity.HasKey(e => e.ServiceEntryId).HasName("PK_trn_MachineServiceEntry");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
        });

        modelBuilder.Entity<TblServiceSchedule>(entity =>
        {
            entity.HasKey(e => e.ScheduleId).HasName("PK_trn_MachineServiceSchedule");

            entity.Property(e => e.IsActive).HasDefaultValue(true);
        });

        modelBuilder.Entity<TblUser>(entity =>
        {
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.InverseCreatedByNavigation).HasConstraintName("FK_tbl_User_CreatedBy");

            entity.HasOne(d => d.Dept).WithMany(p => p.TblUsers)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_User_Department");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.InverseModifiedByNavigation).HasConstraintName("FK_tbl_User_ModifiedBy");

            entity.HasOne(d => d.Role).WithMany(p => p.TblUsers)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tbl_User_Role");
        });

        modelBuilder.Entity<TrnConcreteEntry>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__trn_Conc__02A8384D9689BBE5");

            entity.Property(e => e.BreakdownHours).HasDefaultValue(0);
            entity.Property(e => e.BreakdownMinutes).HasDefaultValue(0);
            entity.Property(e => e.CementReceivedKg).HasDefaultValue(0m);
            entity.Property(e => e.CreatedDate).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.DieselRate).HasDefaultValue(0m);
            entity.Property(e => e.DieselReceived).HasDefaultValue(0m);
            entity.Property(e => e.Hmr).HasDefaultValue(0m);
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.MixerHmr).HasDefaultValue(0m);
            entity.Property(e => e.UniqueId).HasDefaultValueSql("(left(replace(CONVERT([varchar](36),newid()),'-',''),(8)))");
            entity.Property(e => e.Volume).HasDefaultValue(0m);
        });

        modelBuilder.Entity<TrnDailyLog>(entity =>
        {
            entity.Property(e => e.AdminStatus).HasDefaultValue("Pending");
            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
            entity.Property(e => e.Sicstatus).HasDefaultValue("Pending");

            entity.HasOne(d => d.AdminByNavigation).WithMany(p => p.TrnDailyLogAdminByNavigations).HasConstraintName("FK_DailyLog_AdminBy");

            entity.HasOne(d => d.Asset).WithMany(p => p.TrnDailyLogs)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DailyLog_Asset");

            entity.HasOne(d => d.CreatedByNavigation).WithMany(p => p.TrnDailyLogCreatedByNavigations)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DailyLog_CreatedBy");

            entity.HasOne(d => d.ModifiedByNavigation).WithMany(p => p.TrnDailyLogModifiedByNavigations).HasConstraintName("FK_DailyLog_ModifiedBy");

            entity.HasOne(d => d.Op).WithMany(p => p.TrnDailyLogs)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DailyLog_Operator");

            entity.HasOne(d => d.Proj).WithMany(p => p.TrnDailyLogs)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DailyLog_Project");

            entity.HasOne(d => d.Shift).WithMany(p => p.TrnDailyLogs)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_DailyLog_Shift");

            entity.HasOne(d => d.SicbyNavigation).WithMany(p => p.TrnDailyLogSicbyNavigations).HasConstraintName("FK_DailyLog_SICBy");
        });

        modelBuilder.Entity<TrnFuelLog>(entity =>
        {
            entity.HasKey(e => e.FuelLogId).HasName("PK__trn_Fuel__FFEFAACBC7323C9F");

            entity.Property(e => e.CreatedOn).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.IsActive).HasDefaultValue(true);
        });

        modelBuilder.Entity<TrnLogDetail>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__trn_LogD__3214EC27B1F3B2B9");

            entity.Property(e => e.ActionDateTime).HasDefaultValueSql("(getdate())");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
