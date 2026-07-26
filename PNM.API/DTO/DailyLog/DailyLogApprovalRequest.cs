using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.DailyLog
{
    public class DailyLogApprovalRequest
    {
        public string Status { get; set; } = string.Empty;

        public string? Remarks { get; set; }
    }
}
