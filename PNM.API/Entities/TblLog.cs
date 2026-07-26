using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_Log")]
public partial class TblLog
{
    [Key]
    public long Id { get; set; }

    public string? LogText { get; set; }

    [StringLength(50)]
    public string? Status { get; set; }

    public string? Reasons { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? CreatedDate { get; set; }

    public int? ExecutionTime { get; set; }
}
