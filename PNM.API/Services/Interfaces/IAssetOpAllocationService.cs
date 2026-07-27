using PNM.Core.DTO.AssetOpAllocation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IAssetOpAllocationService
    {
        Task<List<AssetOpAllocationResponse>> GetAllAsync();

        Task<AssetOpAllocationResponse?> GetByIdAsync(int assetOpAllocId);

        Task<AssetOpAllocationResponse> SaveAsync(AssetOpAllocationRequest request);

        Task<AssetOpAllocationResponse?> UpdateAsync(int assetOpAllocId, AssetOpAllocationRequest request);

        Task<AssetOpAllocationResponse?> DeleteAsync(int assetOpAllocId);

        Task<AssetOpAllocationResponse?> DeallocateAsync(int assetOpAllocId);
    }
}
