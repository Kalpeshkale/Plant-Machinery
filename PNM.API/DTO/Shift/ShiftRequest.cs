using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Shift
{
    public class ShiftRequest
    {
        public string ShiftCode { get; set; } = string.Empty;

        public string ShiftName { get; set; } = string.Empty;

        public TimeOnly StartTime { get; set; }

        public TimeOnly EndTime { get; set; }
    }
}
