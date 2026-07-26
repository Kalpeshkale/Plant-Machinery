using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.SubType
{
    public class SubTypeResponse
    {
        public int SubTypeId { get; set; }

        public int? TypeId { get; set; }

        public string? TypeName { get; set; }

        public string SubTypeName { get; set; } = string.Empty;

        public string? AssetUnit { get; set; }

        public string? OutputUnit { get; set; }

        public string? FuelType { get; set; }

        public string? FuelUnit { get; set; }
    }
}
