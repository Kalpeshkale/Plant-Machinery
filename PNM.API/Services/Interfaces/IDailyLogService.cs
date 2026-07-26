using PNM.Core.DTO.DailyLog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IDailyLogService
    {
        Task<List<DailyLogResponse>> GetAllAsync();

        Task<DailyLogResponse?> GetByIdAsync(int dailyLogId);

        Task<DailyLogResponse> SaveAsync(DailyLogRequest request);

        Task<DailyLogResponse?> UpdateAsync(int dailyLogId, DailyLogRequest request);

        Task<DailyLogResponse?> DeleteAsync(int dailyLogId);

        Task<DailyLogResponse?> SicApprovalAsync(int dailyLogId, int sicBy, DailyLogApprovalRequest request);

        Task<DailyLogResponse?> AdminApprovalAsync(int dailyLogId, int adminBy, DailyLogApprovalRequest request);
        Task<AssetLoggingDetailsResponse?> GetAssetLoggingDetailsAsync(int assetId);
        Task<List<DailyLogResponse>> SaveBulkAsync(List<DailyLogRequest> requests);
    }
}
