using PNM.Core.DTO.OwnerType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IOwnerTypeService
    {
        Task<List<OwnerTypeResponse>> GetAllAsync();

        Task<OwnerTypeResponse?> GetByIdAsync(int ownerId);

        Task<OwnerTypeResponse> SaveAsync(OwnerTypeRequest request);

        Task<OwnerTypeResponse?> UpdateAsync(int ownerId, OwnerTypeRequest request);

        Task<OwnerTypeResponse?> DeleteAsync(int ownerId);
    }
}
