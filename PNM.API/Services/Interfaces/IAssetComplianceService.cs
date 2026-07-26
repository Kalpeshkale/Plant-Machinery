using PNM.Core.DTO.AssetCompliance;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IAssetComplianceService
    {
        Task<List<AssetComplianceResponse>> GetAllAsync();
        Task<AssetComplianceResponse?> GetByIdAsync(int id);
        Task<AssetComplianceResponse> SaveAsync(AssetComplianceRequest request);
        Task<AssetComplianceResponse?> UpdateAsync(int id, AssetComplianceRequest request);
        Task<AssetComplianceResponse?> DeleteAsync(int id);
    }
}
