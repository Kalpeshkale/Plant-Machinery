using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetDocTypeField")]
public partial class TblAssetDocTypeField
{
    [Key]
    [Column("DocumentFieldID")]
    public int DocumentFieldId { get; set; }

    [Column("DocumentTypeID")]
    public int DocumentTypeId { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string FieldName { get; set; } = null!;

    [StringLength(200)]
    [Unicode(false)]
    public string FieldLabel { get; set; } = null!;

    [StringLength(30)]
    [Unicode(false)]
    public string FieldDataType { get; set; } = null!;

    [Unicode(false)]
    public string? FieldOptions { get; set; }

    public bool IsMandatory { get; set; }

    public int SortOrder { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime CreatedDate { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedDate { get; set; }

    [ForeignKey("DocumentTypeId")]
    [InverseProperty("TblAssetDocTypeFields")]
    public virtual TblAssetDocType DocumentType { get; set; } = null!;

    [InverseProperty("DocumentField")]
    public virtual ICollection<TblAssetDocDetail> TblAssetDocDetails { get; set; } = new List<TblAssetDocDetail>();
}
