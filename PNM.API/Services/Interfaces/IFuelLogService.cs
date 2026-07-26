using PNM.Core.DTO.FuelLog;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IFuelLogService
    {
        Task<List<FuelLogResponse>> GetAllAsync();
        Task<FuelLogResponse?> GetByIdAsync(int fuelLogId);
        Task<FuelLogResponse> SaveAsync(FuelLogRequest request);
        Task<FuelLogResponse?> UpdateAsync(int fuelLogId, FuelLogRequest request);
        Task<FuelLogResponse?> DeleteAsync(int fuelLogId);
    }
}
