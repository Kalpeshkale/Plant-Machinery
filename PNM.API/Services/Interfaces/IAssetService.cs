using PNM.Core.DTO.Asset;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IAssetService
    {
        Task<List<AssetResponse>> GetAllAsync();

        Task<AssetResponse?> GetByIdAsync(int assetId);

        Task<AssetResponse> SaveAsync(AssetRequest request);

        Task<AssetResponse?> UpdateAsync(int assetId, AssetRequest request);

        Task<AssetResponse?> DeleteAsync(int assetId);

        Task<AssetResponse?> UpdateStatusAsync(int assetId, string status);
    }
}
