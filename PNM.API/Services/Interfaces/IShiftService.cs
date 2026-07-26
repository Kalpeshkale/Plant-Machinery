using PNM.Core.DTO.Shift;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IShiftService
    {
        Task<List<ShiftResponse>> GetAllAsync();

        Task<ShiftResponse?> GetByIdAsync(int shiftId);

        Task<ShiftResponse> SaveAsync(ShiftRequest request);

        Task<ShiftResponse?> UpdateAsync(int shiftId, ShiftRequest request);

        Task<ShiftResponse?> DeleteAsync(int shiftId);
    }
}
