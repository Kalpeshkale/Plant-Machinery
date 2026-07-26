namespace PNM.Core.DTO.DailyLog
{
    public class AssetLoggingDetailsResponse
    {
        public int AssetId { get; set; }
        public string AssetName { get; set; } = null!;
        public string AssetCode { get; set; } = null!;
        public string? MeterType { get; set; }
        public decimal LastMeterReading { get; set; }
        public int? CurrentProjectId { get; set; }
        public string? CurrentProjectName { get; set; }
        public int? DefaultOperatorId { get; set; }
        public string? DefaultOperatorName { get; set; }
        public decimal? FuelBalance { get; set; }
    }
}
