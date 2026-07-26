using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("mst_Shift")]
[Index("ShiftCode", Name = "UQ_mst_Shift_Code", IsUnique = true)]
public partial class MstShift
{
    [Key]
    public int ShiftId { get; set; }

    [StringLength(8)]
    [Unicode(false)]
    public string? UniqueId { get; set; }

    [StringLength(5)]
    public string ShiftCode { get; set; } = null!;

    [StringLength(50)]
    public string ShiftName { get; set; } = null!;

    [Precision(0)]
    public TimeOnly StartTime { get; set; }

    [Precision(0)]
    public TimeOnly EndTime { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    [Precision(0)]
    public DateTime CreatedOn { get; set; }

    [InverseProperty("Shift")]
    public virtual ICollection<TrnDailyLog> TrnDailyLogs { get; set; } = new List<TrnDailyLog>();
}
