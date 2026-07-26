using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.ServiceArea
{
    public class ServiceAreaResponse
    {
        public int ServAreaId { get; set; }

        public int? ModelId { get; set; }

        public string? ModelNo { get; set; }

        public int? ServAreaName { get; set; }

        public bool IsCheckType { get; set; }

        public string? Priority { get; set; }
    }
}
