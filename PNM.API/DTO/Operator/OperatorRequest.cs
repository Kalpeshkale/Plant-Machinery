using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Operator
{
    public class OperatorRequest
    {
        public string OpCode { get; set; } = string.Empty;

        public string? OpType { get; set; }

        public string FullName { get; set; } = string.Empty;

        public DateOnly? DateOfBirth { get; set; }

        public string? Gender { get; set; }

        public string? Mobile { get; set; }

        public string? AadhaarNo { get; set; }

        public string? LicenseNo { get; set; }

        public string? Address { get; set; }

        public DateOnly? Doj { get; set; }

        public string? Status { get; set; }

        public string? PhotoPath { get; set; }
    }
}
