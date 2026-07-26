using PNM.Core.DTO.ProjAssetAllocation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IProjAssetAllocationService
    {
        Task<List<ProjAssetAllocationResponse>> GetAllAsync();

        Task<ProjAssetAllocationResponse?> GetByIdAsync(int projAssetAllocId);

        Task<ProjAssetAllocationResponse> SaveAsync(ProjAssetAllocationRequest request);

        Task<ProjAssetAllocationResponse?> UpdateAsync(int projAssetAllocId, ProjAssetAllocationRequest request);

        Task<ProjAssetAllocationResponse?> DeleteAsync(int projAssetAllocId);
    }
}
