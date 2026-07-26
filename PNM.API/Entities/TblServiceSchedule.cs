using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace PNM.Infrastructure.Entities;

[Table("tbl_ServiceSchedule")]
public partial class TblServiceSchedule
{
    [Key]
    [Column("ScheduleID")]
    public int ScheduleId { get; set; }

    [Column("CategoryID")]
    public int? CategoryId { get; set; }

    [Column("AssetTypeID")]
    public int? AssetTypeId { get; set; }

    [Column("MakeID")]
    public int? MakeId { get; set; }

    [Column("ModelID")]
    public int? ModelId { get; set; }

    [Column("ServiceTypeID")]
    [StringLength(100)]
    public string? ServiceTypeId { get; set; }

    [Column("ServiceAreaID")]
    [StringLength(200)]
    public string? ServiceAreaId { get; set; }

    [Column("UOM")]
    [StringLength(50)]
    public string Uom { get; set; } = null!;

    public int ThresholdFirst { get; set; }

    public int ThresholdSecond { get; set; }

    public int ThresholdEvery { get; set; }

    public int AlertFirst { get; set; }

    public string? AlertFirstTemplate { get; set; }

    public int AlertSecond { get; set; }

    public string? AlertSecondTemplate { get; set; }

    public int AlertThird { get; set; }

    public string? AlertThirdTemplate { get; set; }

    public int AlertLast { get; set; }

    public string? AlertLastTemplate { get; set; }

    [StringLength(500)]
    public string? Remarks { get; set; }

    public bool IsActive { get; set; }

    public int? CreatedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? CreatedOn { get; set; }

    public int? ModifiedBy { get; set; }

    [Column(TypeName = "datetime")]
    public DateTime? ModifiedOn { get; set; }
}
