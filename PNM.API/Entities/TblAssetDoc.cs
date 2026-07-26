using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetDoc")]
[Index("AttachmentCode", Name = "UQ__trn_Asse__B98D505B865AA386", IsUnique = true)]
public partial class TblAssetDoc
{
    [Key]
    [Column("AttachmentID")]
    public int AttachmentId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [StringLength(50)]
    [Unicode(false)]
    public string AttachmentCode { get; set; } = null!;

    [Column("AssetID")]
    public int AssetId { get; set; }

    [Column("DocumentTypeID")]
    public int DocumentTypeId { get; set; }

    [Column("SiteID")]
    public int? SiteId { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string FilePath { get; set; } = null!;

    [StringLength(255)]
    [Unicode(false)]
    public string FileName { get; set; } = null!;

    [StringLength(50)]
    [Unicode(false)]
    public string? FileType { get; set; }

    [StringLength(20)]
    [Unicode(false)]
    public string? FileExtension { get; set; }

    [Column("FileSizeKB", TypeName = "decimal(18, 2)")]
    public decimal? FileSizeKb { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime UploadDate { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? Remarks { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedDate { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedDate { get; set; }

    [ForeignKey("DocumentTypeId")]
    [InverseProperty("TblAssetDocs")]
    public virtual TblAssetDocType DocumentType { get; set; } = null!;

    [InverseProperty("Attachment")]
    public virtual ICollection<TblAssetDocDetail> TblAssetDocDetails { get; set; } = new List<TblAssetDocDetail>();
}
