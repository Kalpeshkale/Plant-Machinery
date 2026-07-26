using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.User
{
    public class UserResponse
    {
        public int UserId { get; set; }

        public int DeptId { get; set; }

        public string? DeptName { get; set; }

        public int RoleId { get; set; }

        public string? RoleName { get; set; }

        public string EmpId { get; set; } = string.Empty;

        public string UserName { get; set; } = string.Empty;
    }
}
