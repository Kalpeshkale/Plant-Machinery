using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_ServiceAttachment")]
public partial class TblServiceAttachment
{
    [Key]
    [Column("AttachmentID")]
    public int AttachmentId { get; set; }

    [Column("EntryID")]
    [StringLength(50)]
    [Unicode(false)]
    public string EntryId { get; set; } = null!;

    [StringLength(500)]
    [Unicode(false)]
    public string FilePath { get; set; } = null!;

    [StringLength(250)]
    [Unicode(false)]
    public string FileName { get; set; } = null!;

    public bool? IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }
}
