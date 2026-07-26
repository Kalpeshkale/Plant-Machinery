using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetDocDetail")]
public partial class TblAssetDocDetail
{
    [Key]
    public int AttachDetailId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int AttachmentId { get; set; }

    public int DocumentFieldId { get; set; }

    [Unicode(false)]
    public string? FieldValue { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedDate { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedDate { get; set; }

    [ForeignKey("AttachmentId")]
    [InverseProperty("TblAssetDocDetails")]
    public virtual TblAssetDoc Attachment { get; set; } = null!;

    [ForeignKey("DocumentFieldId")]
    [InverseProperty("TblAssetDocDetails")]
    public virtual TblAssetDocTypeField DocumentField { get; set; } = null!;
}
