using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.Role
{
    public class RoleResponse
    {
        public int RoleId { get; set; }

        public string Role { get; set; } = string.Empty;

        public string? RoleDesc { get; set; }
    }
}
