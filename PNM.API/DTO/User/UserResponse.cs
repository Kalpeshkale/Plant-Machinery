using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.User
{
    public class UserResponse
    {
        // Core identity
        public int UserId { get; set; }
        public string EmpId { get; set; } = string.Empty;
        public string UserName { get; set; } = string.Empty;

        // Role & Department
        public int DeptId { get; set; }
        public string? DeptName { get; set; }
        public int RoleId { get; set; }
        public string? RoleName { get; set; }

        // Personal details
        public string? FullName { get; set; }
        public DateOnly? DateOfBirth { get; set; }
        public string? Gender { get; set; }
        public string? Mobile { get; set; }
        public string? Address { get; set; }

        // Documents
        public string? AadhaarNo { get; set; }
        public string? LicenseNo { get; set; }

        // Employment
        public DateOnly? Doj { get; set; }
        public string? Status { get; set; }

        // Photo
        public string? PhotoPath { get; set; }
    }
}
