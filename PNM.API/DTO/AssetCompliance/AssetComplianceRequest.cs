using System;

namespace PNM.Core.DTO.AssetCompliance
{
    public class AssetComplianceRequest
    {
        public int AssetId { get; set; }
        public DateOnly? InsuranceExpDate { get; set; }
        public DateOnly? PucexpDate { get; set; }
        public DateOnly? FitnessExpDate { get; set; }
        public DateOnly? PermitExpDate { get; set; }
        public DateOnly? RoadTaxExpDate { get; set; }
        public DateOnly? RtoexpDate { get; set; }
        public string? Remarks { get; set; }
    }
}
