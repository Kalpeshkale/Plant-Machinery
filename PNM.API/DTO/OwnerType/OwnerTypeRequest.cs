using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.OwnerType
{
    public class OwnerTypeRequest
    {
        public string OwnerType { get; set; } = string.Empty;

        public int SortOrder { get; set; }
    }
}
