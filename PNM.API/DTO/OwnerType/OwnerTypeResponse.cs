using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.OwnerType
{
    public class OwnerTypeResponse
    {
        public int OwnerId { get; set; }

        public string OwnerType { get; set; } = string.Empty;

        public int SortOrder { get; set; }
    }
}
