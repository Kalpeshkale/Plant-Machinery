using PNM.Core.DTO.ServiceType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IServiceTypeService
    {
        Task<List<ServiceTypeResponse>> GetAllAsync();

        Task<ServiceTypeResponse?> GetByIdAsync(int servTypeId);

        Task<ServiceTypeResponse> SaveAsync(ServiceTypeRequest request);

        Task<ServiceTypeResponse?> UpdateAsync(int servTypeId, ServiceTypeRequest request);

        Task<ServiceTypeResponse?> DeleteAsync(int servTypeId);
    }
}
