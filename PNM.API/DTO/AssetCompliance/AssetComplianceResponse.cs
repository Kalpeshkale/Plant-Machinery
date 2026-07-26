using System;

namespace PNM.Core.DTO.AssetCompliance
{
    public class AssetComplianceResponse
    {
        public int ComplianceId { get; set; }
        public string UniqueId { get; set; } = null!;
        public int AssetId { get; set; }
        public string AssetName { get; set; } = null!;
        public string AssetCode { get; set; } = null!;
        public DateOnly? InsuranceExpDate { get; set; }
        public DateOnly? PucexpDate { get; set; }
        public DateOnly? FitnessExpDate { get; set; }
        public DateOnly? PermitExpDate { get; set; }
        public DateOnly? RoadTaxExpDate { get; set; }
        public DateOnly? RtoexpDate { get; set; }
        public string? Remarks { get; set; }
    }
}
