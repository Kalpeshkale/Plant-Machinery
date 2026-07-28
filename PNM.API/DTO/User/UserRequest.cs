using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Core.DTO.User
{
    public class UserRequest
    {
        // Core identity
        public string EmpId { get; set; } = string.Empty;        // Mandatory — login identifier
        public string UserName { get; set; } = string.Empty;     // Display name / full name used as username
        public int DeptId { get; set; }
        public int RoleId { get; set; }                          // From mst_Role (excludes Admin/Super Admin)

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

        // Password — optional; if not provided a default hash is used
        // Will be wired to a proper login flow later
        public string? Password { get; set; }
    }
}
