using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Category
{
    public class CategoryResponse
    {
        public int CatId { get; set; }

        public int? DeptId { get; set; }

        public string? DeptName { get; set; }

        public string CatName { get; set; } = string.Empty;
    }
}
