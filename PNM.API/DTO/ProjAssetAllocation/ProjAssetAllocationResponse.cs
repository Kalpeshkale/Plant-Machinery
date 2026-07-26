using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.ProjAssetAllocation
{
    public class ProjAssetAllocationResponse
    {
        public int ProjAssetAllocId { get; set; }

        public int ProjId { get; set; }

        public string? ProjName { get; set; }

        public int AssetId { get; set; }

        public string? AssetName { get; set; }

        public DateOnly AllocationDate { get; set; }

        public DateOnly? ReleaseDate { get; set; }

        public string? Remarks { get; set; }
    }
}
