using System;

namespace PNM.Core.DTO.FuelLog
{
    public class FuelLogRequest
    {
        public int AssetId { get; set; }
        public DateTime FuelDateTime { get; set; }
        public decimal FuelQty { get; set; }
        public decimal? ReadingAtFueling { get; set; }
        public string? FuelType { get; set; }
        public string? Remarks { get; set; }
        public string? PhotoPath { get; set; }
    }
}
