using PNM.Core.DTO.ServiceArea;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IServiceAreaService
    {
        Task<List<ServiceAreaResponse>> GetAllAsync();

        Task<ServiceAreaResponse?> GetByIdAsync(int servAreaId);

        Task<ServiceAreaResponse> SaveAsync(ServiceAreaRequest request);

        Task<ServiceAreaResponse?> UpdateAsync(int servAreaId, ServiceAreaRequest request);

        Task<ServiceAreaResponse?> DeleteAsync(int servAreaId);
    }
}
