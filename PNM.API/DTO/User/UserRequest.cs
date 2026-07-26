using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.User
{
    public class UserRequest
    {
        public int DeptId { get; set; }

        public int RoleId { get; set; }

        public string EmpId { get; set; } = string.Empty;

        public string UserName { get; set; } = string.Empty;

        public string? Password { get; set; }
    }
}
