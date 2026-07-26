using PNM.Core.DTO.Make;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IMakeService
    {
        Task<List<MakeResponse>> GetAllAsync();

        Task<MakeResponse?> GetByIdAsync(int makeId);

        Task<MakeResponse> SaveAsync(MakeRequest request);

        Task<MakeResponse?> UpdateAsync(int makeId, MakeRequest request);

        Task<MakeResponse?> DeleteAsync(int makeId);
    }
}
