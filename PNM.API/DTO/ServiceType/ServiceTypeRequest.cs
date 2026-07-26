using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.ServiceType
{
    public class ServiceTypeRequest
    {
        public int ServTypeId { get; set; }

        public int ServiAreaId { get; set; }

        public string ServTypeName { get; set; } = string.Empty;

        public decimal? ApproximateCost { get; set; }
    }
}
