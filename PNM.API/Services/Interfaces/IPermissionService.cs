using PNM.Core.DTO.Permission;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IPermissionService
    {
        Task<List<MenuPermissionResponse>> GetUserMenuPermissionsAsync(int userId);
        Task<List<MenuPermissionResponse>> GetAllMenuPermissionsAsync();
        Task<bool> SaveRoleMenuAccessAsync(RoleMenuAccessRequest request);
        Task<bool> SaveEmployeeMenuAccessAsync(EmployeeMenuAccessRequest request);
        Task<MenuPermissionResponse> SaveMenuPermissionAsync(MenuPermissionRequest request);
        Task<MenuPermissionResponse?> UpdateMenuPermissionAsync(int id, MenuPermissionRequest request);
        Task<MenuPermissionResponse?> DeleteMenuPermissionAsync(int id);
    }
}
