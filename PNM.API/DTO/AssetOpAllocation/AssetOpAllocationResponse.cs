using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.AssetOpAllocation
{
    public class AssetOpAllocationResponse
    {
        public int AssetOpAllocId { get; set; }

        public int AssetId { get; set; }

        public string? AssetName { get; set; }

        public int OpId { get; set; }

        public string? OpFullName { get; set; }

        public DateOnly AllocationDate { get; set; }

        public DateOnly? ReleaseDate { get; set; }

        public string? Remarks { get; set; }
    }
}
