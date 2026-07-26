using System.Collections.Generic;

namespace PNM.Core.DTO.Permission
{
    public class RoleMenuAccessRequest
    {
        public int RoleId { get; set; }
        public List<int> PermissionIds { get; set; } = new();
    }
}
