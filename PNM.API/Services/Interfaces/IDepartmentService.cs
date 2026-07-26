using PNM.Core.DTO.Department;
using PNM.Infrastructure.Entities;

namespace PNM.Service.Services.Interfaces
{
    public interface IDepartmentService
    {
        Task<List<DepartmentResponse>> GetAllAsync();
        Task<DepartmentResponse?> GetByIdAsync(int deptId);
        Task<DepartmentResponse> SaveAsync(DepartmentRequest request);
        Task<DepartmentResponse?> UpdateAsync(int deptId, DepartmentRequest request);
        Task<DepartmentResponse?> DeleteAsync(int deptId);

    }

}