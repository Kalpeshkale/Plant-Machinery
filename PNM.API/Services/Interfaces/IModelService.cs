using PNM.Core.DTO.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PNM.Service.Services.Interfaces
{
    public interface IModelService
    {
        Task<List<ModelResponse>> GetAllAsync();

        Task<ModelResponse?> GetByIdAsync(int modelId);

        Task<ModelResponse> SaveAsync(ModelRequest request);

        Task<ModelResponse?> UpdateAsync(int modelId, ModelRequest request);

        Task<ModelResponse?> DeleteAsync(int modelId);
    }
}
