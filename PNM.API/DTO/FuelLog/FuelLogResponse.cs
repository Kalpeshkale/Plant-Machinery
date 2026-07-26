using System;

namespace PNM.Core.DTO.FuelLog
{
    public class FuelLogResponse
    {
        public int FuelLogId { get; set; }
        public int AssetId { get; set; }
        public string AssetName { get; set; } = null!;
        public string AssetCode { get; set; } = null!;
        public DateTime FuelDateTime { get; set; }
        public decimal FuelQty { get; set; }
        public decimal? ReadingAtFueling { get; set; }
        public string? FuelType { get; set; }
        public string? Remarks { get; set; }
        public string? PhotoPath { get; set; }
        public string? UniqueId { get; set; }
    }
}
