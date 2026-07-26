using PNM.Core.DTO.Role;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IRoleService
    {
        Task<List<RoleResponse>> GetAllAsync();

        Task<RoleResponse?> GetByIdAsync(int roleId);

        Task<RoleResponse> SaveAsync(RoleRequest request);

        Task<RoleResponse?> UpdateAsync(int roleId, RoleRequest request);

        Task<RoleResponse?> DeleteAsync(int roleId);
    }
}
