using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.DailyLog
{
    public class DailyLogResponse
    {
        public int DailyLogId { get; set; }

        public DateOnly LogDate { get; set; }

        public int ProjId { get; set; }

        public string? ProjName { get; set; }

        public int AssetId { get; set; }

        public string? AssetName { get; set; }

        public int OpId { get; set; }

        public string? OpFullName { get; set; }

        public int ShiftId { get; set; }

        public string? ShiftName { get; set; }

        public decimal StartReading { get; set; }

        public decimal EndReading { get; set; }

        public decimal TotalReading { get; set; }

        public decimal? FuelIssued { get; set; }

        public decimal? FuelBalance { get; set; }

        public decimal? WorkingHours { get; set; }

        public bool Breakdown { get; set; }

        public string? BreakdownRemarks { get; set; }

        public string? WorkDescription { get; set; }

        public string? StartReadingPhoto { get; set; }

        public string? EndReadingPhoto { get; set; }

        public string? OperatorRemarks { get; set; }

        public string Sicstatus { get; set; } = string.Empty;

        public int? Sicby { get; set; }

        public DateTime? Sicon { get; set; }

        public string? Sicremarks { get; set; }

        public string AdminStatus { get; set; } = string.Empty;

        public int? AdminBy { get; set; }

        public DateTime? AdminOn { get; set; }

        public string? AdminRemarks { get; set; }
    }
}
