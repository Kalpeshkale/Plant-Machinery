using PNM.Core.DTO.ProjOpAllocation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IProjOpAllocationService
    {
        Task<List<ProjOpAllocationResponse>> GetAllAsync();

        Task<ProjOpAllocationResponse?> GetByIdAsync(int projOpAllocId);

        Task<ProjOpAllocationResponse> SaveAsync(ProjOpAllocationRequest request);

        Task<ProjOpAllocationResponse?> UpdateAsync(int projOpAllocId, ProjOpAllocationRequest request);

        Task<ProjOpAllocationResponse?> DeleteAsync(int projOpAllocId);

        Task<ProjOpAllocationResponse?> DeallocateAsync(int projOpAllocId);
    }
}
