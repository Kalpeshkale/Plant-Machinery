using PNM.Core.DTO.Type;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface ITypeService
    {
        Task<List<TypeResponse>> GetAllAsync();

        Task<TypeResponse?> GetByIdAsync(int typeId);

        Task<TypeResponse> SaveAsync(TypeRequest request);

        Task<TypeResponse?> UpdateAsync(int typeId, TypeRequest request);

        Task<TypeResponse?> DeleteAsync(int typeId);
    }
}
