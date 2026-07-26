using PNM.Core.DTO.Operator;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IOperatorService
    {
        Task<List<OperatorResponse>> GetAllAsync();

        Task<OperatorResponse?> GetByIdAsync(int opId);

        Task<OperatorResponse> SaveAsync(OperatorRequest request);

        Task<OperatorResponse?> UpdateAsync(int opId, OperatorRequest request);

        Task<OperatorResponse?> DeleteAsync(int opId);
    }
}
