using System.Collections.Generic;

namespace PNM.Core.DTO.Permission
{
    public class EmployeeMenuAccessOverride
    {
        public string PermissionKey { get; set; } = null!;
        public bool IsActive { get; set; }
    }

    public class EmployeeMenuAccessRequest
    {
        public int EmployeeId { get; set; }
        public List<EmployeeMenuAccessOverride> Overrides { get; set; } = new();
    }
}
