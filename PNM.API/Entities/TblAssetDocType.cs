using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_AssetDocType")]
[Index("DocTypeCode", Name = "UQ__mst_Asse__8952B4CEBECB2AEB", IsUnique = true)]
public partial class TblAssetDocType
{
    [Key]
    [Column("DocTypeID")]
    public int DocTypeId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    public int? SubTypeId { get; set; }

    public int? ModelId { get; set; }

    [StringLength(30)]
    [Unicode(false)]
    public string DocTypeCode { get; set; } = null!;

    [StringLength(200)]
    [Unicode(false)]
    public string DocTypeName { get; set; } = null!;

    [StringLength(200)]
    [Unicode(false)]
    public string? CatName { get; set; }

    [StringLength(200)]
    [Unicode(false)]
    public string? AuthorityName { get; set; }

    [StringLength(500)]
    [Unicode(false)]
    public string? Notes { get; set; }

    public bool IsRecurring { get; set; }

    public bool IsActive { get; set; }

    public int SortOrder { get; set; }

    public int? CreatedBy { get; set; }

    public DateTime CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    public DateTime? ModifiedOn { get; set; }

    [InverseProperty("DocumentType")]
    public virtual ICollection<TblAssetDocTypeField> TblAssetDocTypeFields { get; set; } = new List<TblAssetDocTypeField>();

    [InverseProperty("DocumentType")]
    public virtual ICollection<TblAssetDoc> TblAssetDocs { get; set; } = new List<TblAssetDoc>();
}
