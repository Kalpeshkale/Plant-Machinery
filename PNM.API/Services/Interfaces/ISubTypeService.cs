using PNM.Core.DTO.SubType;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface ISubTypeService
    {
        Task<List<SubTypeResponse>> GetAllAsync();

        Task<SubTypeResponse?> GetByIdAsync(int subTypeId);

        Task<SubTypeResponse> SaveAsync(SubTypeRequest request);

        Task<SubTypeResponse?> UpdateAsync(int subTypeId, SubTypeRequest request);

        Task<SubTypeResponse?> DeleteAsync(int subTypeId);
    }
}
