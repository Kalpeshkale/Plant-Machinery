using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.ProjOpAllocation
{
    public class ProjOpAllocationRequest
    {
        public int ProjId { get; set; }

        public int OpId { get; set; }

        public DateOnly AllocationDate { get; set; }

        public DateOnly? ReleaseDate { get; set; }

        public string? Remarks { get; set; }
    }
}
