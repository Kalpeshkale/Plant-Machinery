using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Category
{
    public class CategoryRequest
    {
        public int? DeptId { get; set; }

        public string CatName { get; set; } = string.Empty;
    }
}
