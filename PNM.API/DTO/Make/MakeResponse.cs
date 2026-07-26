using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Make
{
    public class MakeResponse
    {
        public int MakeId { get; set; }

        public int? SubTypeId { get; set; }

        public string? SubTypeName { get; set; }

        public string MakeName { get; set; } = string.Empty;
    }
}
