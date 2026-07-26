using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.SubType
{
    public class SubTypeRequest
    {
        public int? TypeId { get; set; }

        public string SubTypeName { get; set; } = string.Empty;

        public string? AssetUnit { get; set; }

        public string? OutputUnit { get; set; }

        public string? FuelType { get; set; }

        public string? FuelUnit { get; set; }
    }
}
