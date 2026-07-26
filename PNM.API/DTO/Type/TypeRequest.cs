using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Type
{
    public class TypeRequest
    {
        public int? CatId { get; set; }

        public string TypeName { get; set; } = string.Empty;
    }
}
